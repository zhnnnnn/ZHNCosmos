//
//  ZHNStatusHelper.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStatusHelper.h"
#import "WBEmojiInfoModel.h"
#import "YYModel.h"
#import "YYText.h"
#import "ZHNTimelineModel.h"
#import "ZHNLinkerTypeModel.h"

@implementation ZHNStatusHelper
+ (CGFloat)oneLineTextHeightWithFont:(CGFloat)font {
    NSString *temp = @"啊";
    CGRect stringRect = [temp boundingRectWithSize:CGSizeMake(1000, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return stringRect.size.height;
}

+ (CGFloat)caluateTextHeightWithText:(NSString *)text MaxWidth:(CGFloat)maxWidth font:(CGFloat)font {
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return stringRect.size.height;
}

+ (CGFloat)caluateTextWidthWithText:(NSString *)text MaxHeight:(CGFloat)maxHeight font:(CGFloat)font {
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return stringRect.size.width;
}

+ (NSData *)WBDataWithSourceName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@""];
    if (path == nil) {
        return nil;
    }else {
        return [NSData dataWithContentsOfFile:path];
    }
}

+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexSource {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).*?(?=<)" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexUrl {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%=]*)?" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexDominName {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\b([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}\\b" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (BOOL)isShortUrl:(NSString *)urlString {
    if ([urlString containsString:@"http://t.cn/"]) {
        return YES;
    }else {
        return NO;
    }
}

+ (NSString *)regexedSouceString:(NSString *)needRegexString {
    if (!needRegexString) {return nil;}
    NSArray *souceArray = [[ZHNStatusHelper regexSource] matchesInString:needRegexString options:kNilOptions range:NSMakeRange(0, needRegexString.length)];
    NSTextCheckingResult *check = souceArray.firstObject;
    if (check.range.location == NSNotFound || check.range.length <= 1) {
        return nil;
    }else {
        return [needRegexString substringWithRange:check.range];
    }
}

+ (NSDictionary *)WBEmojiDict {
    static NSMutableDictionary *emojiDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiDict = [NSMutableDictionary dictionary];
        NSString *emojiBunldePath = [[NSBundle mainBundle]pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        NSString *emojiResourcepistPath = [emojiBunldePath stringByAppendingPathComponent:@"emoticons.plist"];
        NSDictionary *resourceDict = [NSDictionary dictionaryWithContentsOfFile:emojiResourcepistPath];
        NSArray *rArray = resourceDict[@"packages"];
        for (NSDictionary *emoji in rArray) {
            NSString *folderName = emoji[@"id"];
            NSString *emojiImageFolderPath = [emojiBunldePath stringByAppendingPathComponent:folderName];
            NSString *emojiInfoPlistpath = [[emojiBunldePath stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:@"EmotionsInfo.plist"];
            NSDictionary *emojiInfo = [NSDictionary dictionaryWithContentsOfFile:emojiInfoPlistpath];
            WBEmojiInfoModel *infoModel = [WBEmojiInfoModel yy_modelWithDictionary:emojiInfo];
            for (WBEmojiItemModel *emoji in infoModel.emoticons) {
                NSString *emojiImagePath = [emojiImageFolderPath stringByAppendingPathComponent:emoji.png];
                if (emojiImagePath.length == 0) {continue;}
                if (emoji.cht.length > 0) {
                    [emojiDict setObject:emojiImagePath forKey:emoji.cht];
                }
                if (emoji.chs.length > 0) {
                    [emojiDict setObject:emojiImagePath forKey:emoji.chs];
                }
            }
        }
    });
    return emojiDict;
}

+ (NSDictionary *)WBLinkerTypeDict {
    static NSMutableDictionary *linkerTypeDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        linkerTypeDict = [NSMutableDictionary dictionary];
        NSString *linkerTypePath = [[NSBundle mainBundle]pathForResource:@"WeiboLinkType" ofType:@"plist"];
        NSArray *linkerTypeArray = [NSArray arrayWithContentsOfFile:linkerTypePath];
        NSArray *linkerModelArray = [NSArray yy_modelArrayWithClass:[ZHNLinkerTypeModel class] json:linkerTypeArray];
        for (ZHNLinkerTypeModel *linkerModel in linkerModelArray) {
            [linkerTypeDict setObject:linkerModel forKey:linkerModel.keyword];
        }
    });
    return linkerTypeDict;
}

+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText maxWidth:(CGFloat)maxWidth {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributeText];
    return layout.textBoundingSize.height;
}

+ (NSString *)formatterDate:(NSDate *)date; {
    NSDateFormatter *showFormatter = [[NSDateFormatter alloc]init];
    showFormatter.dateFormat = @"yyyy HH:mm";
    NSString *showString = [showFormatter stringFromDate:date];
    return showString;
}

+ (void)longURLDisposeForStatusArray:(NSArray<ZHNTimelineStatus *> *)statusArray success:(void (^)())success failure:(void (^)())failure {
    for (ZHNTimelineStatus *status in statusArray) {
        NSMutableArray *shortUrls = [NSMutableArray array];
        NSArray *regularArray = [[ZHNStatusHelper regexUrl] matchesInString:status.text options:kNilOptions range:NSMakeRange(0, status.text.length)];
        for (NSTextCheckingResult *result in regularArray) {
            if (result.range.location == NSNotFound || result.range.length <= 1) {continue;}
            NSMutableString *temp = [[NSMutableString alloc]initWithString:status.text];
            NSString *shortUrl = [temp substringWithRange:result.range];
            if ([ZHNStatusHelper isShortUrl:shortUrl]) {
                [shortUrls addObject:shortUrl];
            }
        }
    }
}
@end
