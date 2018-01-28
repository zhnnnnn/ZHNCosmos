//
//  RACSignal+statusMapping.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "RACSignal+statusMapping.h"
#import "ZHNTimelineModel.h"
#import "ZHNLinkerTypeModel.h"
#import "RACSignal+ZHNRichTextHelper.h"
#import "ZHNTimelineLayoutModel.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"

@implementation RACSignal (statusMapping)
- (RACSignal *)URLMapReweet:(BOOL)isReweet {
    __block NSArray *formatterStatusArray = nil;
    __block NSDictionary *staticShortUrlDict = nil;
    __block NSDictionary *staticLongUrlDict = nil;
    return
    [[[[self
        flattenMap:^RACStream *(NSArray *statusArray) {// 1.regex urls
            formatterStatusArray = statusArray;
            NSMutableDictionary *shortUrlDict = [NSMutableDictionary dictionary];
            NSMutableDictionary *longUrlDict = [NSMutableDictionary dictionary];
            [formatterStatusArray enumerateObjectsUsingBlock:^(ZHNTimelineStatus *status, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *machString = isReweet ? status.retweetedStatus.text : status.text;
                if (!machString) {return;}
                NSMutableArray *shortUrls = [NSMutableArray array];
                NSMutableArray *longUrls = [NSMutableArray array];
                NSArray *regularArray = [[ZHNStatusHelper regexUrl] matchesInString:machString options:kNilOptions range:NSMakeRange(0, machString.length)];
                for (NSTextCheckingResult *result in regularArray) {
                    if (result.range.location == NSNotFound || result.range.length <= 1) {continue;}
                    NSMutableString *temp = [[NSMutableString alloc]initWithString:machString];
                    NSString *url = [temp substringWithRange:result.range];
                    if ([ZHNStatusHelper isShortUrl:url]) {
                        [shortUrls addObject:url];
                    }else {
                        [longUrls addObject:url];
                    }
                }
                if (shortUrls.count > 0) {
                    [shortUrlDict setObject:shortUrls forKey:[NSString stringWithFormat:@"%ld",(unsigned long)idx]];
                }
                if (longUrls.count > 0) {
                    [longUrlDict setObject:longUrls forKey:[NSString stringWithFormat:@"%ld",(unsigned long)idx]];
                }
            }];
            staticShortUrlDict = shortUrlDict;
            staticLongUrlDict = longUrlDict;
            return [RACSignal return:shortUrlDict];
        }]
       flattenMap:^RACStream *(NSDictionary *shortUrlDict) {// 2.Short url switch to long url api params grouping
           // Short url switch to longurl api once only support 20 groups.
           NSMutableArray *urlParamsArray = [NSMutableArray array];
           NSArray *keys = [shortUrlDict allKeys];
           NSInteger tag = 0;
           NSString *urlParamsString = @"";
           for (NSString *key in keys) {
               NSArray *shortUrls = [shortUrlDict valueForKey:key];
               if (tag + shortUrls.count <= 20) {
                   tag = tag + shortUrls.count;
                   for (NSString *url in shortUrls) {
                       urlParamsString = [NSString stringWithFormat:@"%@&url_short=%@",urlParamsString,url];
                   }
                   if ([key isEqualToString:[keys lastObject]]) {
                       [urlParamsArray addObject:urlParamsString];
                   }
               }else {
                   [urlParamsArray addObject:[urlParamsString copy]];
                   tag = 0;
                   tag = tag + shortUrls.count;
                   urlParamsString = @"";
                   for (NSString *url in shortUrls) {
                       urlParamsString = [NSString stringWithFormat:@"%@&url_short=%@",urlParamsString,url];
                   }
               }
           }
           return [RACSignal return:urlParamsArray];
       }]
      flattenMap:^RACStream *(NSArray *urlParamsArray) {// 3.Call short url switch to long url api
          // call api to get longurl
          return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              NSMutableArray *longUrlModelArray = [NSMutableArray array];
              dispatch_group_t urlGroup = dispatch_group_create();
              for (NSString *paramsString in urlParamsArray) {
                  dispatch_group_enter(urlGroup);
                  NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/short_url/expand.json?access_token=%@%@",@"2.00KpVmsGfj3PXC49e06d9a040uAPRD",paramsString];
                  [ZHNNETWROK get:url params:nil responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
                      if (![result zhn_isDictionary]) {return;}
                      NSArray *modelArray = [NSArray yy_modelArrayWithClass:[ZHNTimelineURL class] json:result[@"urls"]];
                      [longUrlModelArray addObjectsFromArray:modelArray];
                      dispatch_group_leave(urlGroup);
                  } failure:^(NSError *error, NSURLSessionDataTask *task) {
                      [subscriber sendError:nil];
                      dispatch_group_leave(urlGroup);
                  }];
              }
              
              dispatch_group_notify(urlGroup, dispatch_get_global_queue(0, 0), ^{
                  NSMutableDictionary *mappingDict = [NSMutableDictionary dictionary];
                  for (ZHNTimelineURL *urlModel in longUrlModelArray) {
                      [mappingDict setObject:urlModel forKey:urlModel.urlShort];
                  }
                  [subscriber sendNext:mappingDict];
              });
              return nil;
          }];
      }]
     flattenMap:^RACStream *(NSDictionary *mappingDict) {// 4. Get url mapping show status (`color` `icon` `replacename` etc)
         // normal url. such as `pic` `video` etc.
         for (NSString *key in [staticShortUrlDict allKeys]) {
             NSMutableArray *longUrlModelArray = [NSMutableArray array];
             NSArray *shortUrlStringArray = [staticShortUrlDict valueForKey:key];
             BOOL isHaveVideo = NO;
             for (NSString *shortUrl in shortUrlStringArray) {
                 ZHNTimelineURL *longUrlModel = [mappingDict objectForKey:shortUrl];
                 longUrlModel.urlType = ZHNUrlTypeNormal;
                 if (longUrlModel) {
                     [longUrlModelArray addObject:longUrlModel];
                     [self p_mappingUrlStatusForModel:longUrlModel withUrl:longUrlModel.urlLong];
                     
                     // judge if it is video. if `yes` show video part in the cell.
                     if ([longUrlModel.replaceString isEqualToString:@"微博视频"] || [longUrlModel.replaceString isEqualToString:@"秒拍"]) {
                         isHaveVideo = YES;
                     }
                 }
             }
             NSInteger idx = [key integerValue];
             ZHNTimelineStatus *status = formatterStatusArray[idx];
             if (isReweet) {
                 status.retweetedStatus.urlStructs = longUrlModelArray;
                 status.retweetedStatus.isHaveVideo = isHaveVideo;
             }else {
                 status.urlStructs = longUrlModelArray;
                 status.isHaveVideo = isHaveVideo;
             }
         }
         
         // special url. show full text url
         for (NSString *key in [staticLongUrlDict allKeys]) {
             NSInteger idx = [key integerValue];
             ZHNTimelineStatus *status = formatterStatusArray[idx];
             NSArray *longUrlStringArray = [staticLongUrlDict valueForKey:key];
             NSMutableArray *longUrlModelArray = [NSMutableArray array];
             if (isReweet) {
                 [longUrlModelArray addObjectsFromArray:status.retweetedStatus.urlStructs];
             }else {
                 [longUrlModelArray addObjectsFromArray:status.urlStructs];
             }
             
             for (NSString *longUrl in longUrlStringArray) {
                 ZHNTimelineURL *longUrlModel = [[ZHNTimelineURL alloc]init];
                 longUrlModel.urlLong = longUrl;
                 longUrlModel.urlType = ZHNUrlTypeMoreStatues;
                 [longUrlModelArray addObject:longUrlModel];
                 [self p_mappingUrlStatusForModel:longUrlModel withUrl:longUrlModel.urlLong];
             }
             
             if (isReweet) {
                 status.retweetedStatus.urlStructs = longUrlModelArray;
             }else {
                 status.urlStructs = longUrlModelArray;
             }
         }
         return [RACSignal return:formatterStatusArray];
     }];
}

- (void)p_mappingUrlStatusForModel:(ZHNTimelineURL *)urlModel withUrl:(NSString *)url{
    NSArray *regularArray = [[ZHNStatusHelper regexDominName] matchesInString:url options:kNilOptions range:NSMakeRange(0, url.length)];
    for (NSTextCheckingResult *result in regularArray) {
        if (result.range.location == NSNotFound || result.range.length <= 1) {continue;}
        NSMutableString *urlStr = [[[url mutableCopy] substringWithRange:result.range] mutableCopy];
        NSRange wwwRange = [urlStr rangeOfString:@"www."];
        if (wwwRange.length == 4) {
            [urlStr deleteCharactersInRange:wwwRange];
        }
        NSDictionary *linkerDict = [ZHNStatusHelper WBLinkerTypeDict];
        ZHNLinkerTypeModel *linkerType = [linkerDict objectForKey:urlStr];
        if (linkerType) {
            urlModel.urlColor = linkerType.color;
            urlModel.replaceString = linkerType.replaceString;
            urlModel.imageName = linkerType.imageName;
        }else {
            urlModel.urlColor = [ZHNThemeManager zhn_themeColorHexString];
            urlModel.replaceString = @"网页链接";
            urlModel.imageName = @"linkIcon_link";
        }
    }
}

- (RACSignal *)formatterRichTextMaxWidth:(CGFloat)maxWidth; {
    return [self flattenMap:^RACStream *(NSArray *statusArray) {
        [statusArray enumerateObjectsUsingBlock:^(NSObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
            // Layout or status
            ZHNTimelineStatus *status = nil;
            if ([object isKindOfClass:[ZHNTimelineStatus class]]) {
                status = (ZHNTimelineStatus *)object;
            }else if ([object isKindOfClass:[ZHNTimelineLayoutModel class]]) {
                status = [(ZHNTimelineLayoutModel *)object status];
            }
            // Oneself status
            [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSAttributedString *attribuString = [[NSAttributedString alloc] initWithString:status.text];
                [subscriber sendNext:attribuString];
                return nil;
            }]
             atFormatter]
             topicFormatter]
             emojiFormatter]
             urlFormatter:status richTextMaxWidth:maxWidth]
             subscribeNext:^(NSAttributedString *richText) {
                 status.richTextData = [richText yy_archiveToData];
             }];
        
            // Retweet status
            if (status.retweetedStatus) {
                if (!status.retweetedStatus.isReweetAtnameAdded) {
                    status.retweetedStatus.isReweetAtnameAdded = YES;
                    NSString *username = status.retweetedStatus.user.name;
                    NSString *text = status.retweetedStatus.text;
                    status.retweetedStatus.text = [NSString stringWithFormat:@"@%@:%@",username,text];
                }
                [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSAttributedString *attribuString = [[NSAttributedString alloc] initWithString:status.retweetedStatus.text];
                    [subscriber sendNext:attribuString];
                    return nil;
                }]
                 atFormatter]
                 topicFormatter]
                 emojiFormatter]
                 urlFormatter:status.retweetedStatus richTextMaxWidth:maxWidth]
                 subscribeNext:^(NSAttributedString *richText) {
                     status.retweetedStatus.richTextData = [richText yy_archiveToData];
                 }];
            }
        }];
        return [RACSignal return:statusArray];
    }];
}

- (RACSignal *)layout {
    NSMutableArray *layoutArray = [NSMutableArray array];
    return [self flattenMap:^RACStream *(NSArray *statusArray) {
        [statusArray enumerateObjectsUsingBlock:^(NSObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
            ZHNTimelineStatus *status = nil;
            if ([object isKindOfClass:[ZHNTimelineLayoutModel class]]) {
                status = [(ZHNTimelineLayoutModel *)object status];
            }
            if ([object isKindOfClass:[ZHNTimelineStatus class]]) {
                status = (ZHNTimelineStatus *)object;
            }
            ZHNTimelineLayoutModel *layout = [ZHNTimelineLayoutModel zhn_layoutWithStatusModel:status layoutType:ZHNTimelineLayoutTypeNormal];
            [layoutArray addObject:layout];
        }];
        return [RACSignal return:layoutArray];
    }];
}

- (RACSignal *)completeFormatter {
    return [[[[self
           URLMapReweet:YES]
           URLMapReweet:NO]
           formatterRichTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]]
           layout];
}

@end
