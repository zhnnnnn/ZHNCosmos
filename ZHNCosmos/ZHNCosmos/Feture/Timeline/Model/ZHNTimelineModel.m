//
//  ZHNTimelineModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineModel.h"
#import "YYModel.h"
#import "NSString+substring.h"

@implementation ZHNTimelineStatus
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"statusID":@"id",
             @"createdDate":@"created_at",
             @"thumbnailPic":@"thumbnail_pic",
             @"bmiddlePic":@"bmiddle_pic",
             @"originalPic":@"original_pic",
             @"repostsCount":@"reposts_count",
             @"commentsCount":@"comments_count",
             @"attitudesCount":@"attitudes_count",
             @"sourceAllowclick":@"source_allowclick",
             @"picUrlDicts":@"pic_urls",
             @"retweetedStatus":@"retweeted_status",
             @"picVideo":@"pic_video",
             @"picIds":@"pic_ids",
             @"gifIds":@"gif_ids"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picMetaDatas" : [ZHNTimelinePicMetaData class],
             @"urlStructs" : [ZHNTimelineURL class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.picUrlStrings = nil;
    self.dateAndSourceStr = nil;
    @autoreleasepool {
        // Date and source
        NSString *dateString = [self.createdDate displayDateString];
        NSString *sourceString = [ZHNStatusHelper regexedSouceString:self.source];
        sourceString = sourceString ? sourceString : @"";
        self.dateAndSourceStr = [NSString stringWithFormat:@"%@  %@",dateString,sourceString];
        // Pics deal
        // Pic url string array
        NSMutableArray *urlsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *picDict in _picUrlDicts) {
            if (picDict[@"thumbnail_pic"]) {
                [urlsArray addObject:picDict[@"thumbnail_pic"]];
            }
        }
        self.picUrlStrings = urlsArray;
        // Fit searched timeline status
        if (self.picIds.count > 0) {
            NSMutableArray *gifIDArray = [NSMutableArray array];
            NSArray *metaGifs = [self.gifIds componentsSeparatedByString:@","];
            for (NSString *metaGif in metaGifs) {
                NSString *gifID = [metaGif zhn_substringToStr:@"|"];
                [gifIDArray addObject:gifID];
            }
            
            NSMutableArray *fitUrlArray = [NSMutableArray array];
            for (NSString *picID in self.picIds) {
                NSString *subToStr = [self.thumbnailPic containsString:@".jpg"] ? @".jpg" : @".gif";
                NSString *picURL = [self.thumbnailPic zhn_replaceStringFromStr:@"/" toString:subToStr useStr:picID];
                if ([gifIDArray containsObject:picID]) {
                    if ([picURL containsString:@".jpg"]) {
                        picURL = [picURL stringByReplacingOccurrencesOfString:@".jpg" withString:@".gif"];
                    }
                }
                if (picURL) {
                    [fitUrlArray addObject:picURL];
                }
            }
            self.picUrlStrings = fitUrlArray;
        }
        // Live photo
        NSArray *livePhotoDatas = [self.picVideo componentsSeparatedByString:@","];
        NSMutableArray *livePhotoIndexs = [NSMutableArray array];
        NSMutableArray *livePhotoMovs = [NSMutableArray array];
        for (NSString *livePhotoData in livePhotoDatas) {
            [livePhotoIndexs addObject:[livePhotoData substringToIndex:1]];
            NSString *livePhotoMovID = [livePhotoData substringFromIndex:2];
            NSString *livePhotoMovUrl = [NSString stringWithFormat:@"%@%@.mov",KNetWorkLivePhotoHost,livePhotoMovID];
            [livePhotoMovs addObject:livePhotoMovUrl];
        }
        // To mdoel
        NSMutableArray *picMetaModelArray = [NSMutableArray array];
        [self.picUrlStrings enumerateObjectsUsingBlock:^(NSString * urlString, NSUInteger idx, BOOL * _Nonnull stop) {
            ZHNTimelinePicMetaData *metaData = [[ZHNTimelinePicMetaData alloc]init];
            metaData.picUrl = urlString;
            metaData.picType = TimelinePicTypeNormal;
            if ([urlString containsString:@".gif"]) {
                metaData.picType = TimelinePicTypeGif;
            }
            // live photo
            NSString *strIndex = [NSString stringWithFormat:@"%ld",(unsigned long)idx];
            if ([livePhotoIndexs containsObject:strIndex]) {
                NSInteger movIndex = [livePhotoIndexs indexOfObject:strIndex];
                metaData.picType = TimelinePicTypeLivePhoto;
                metaData.livePhotoMovUrl = livePhotoMovs[movIndex];
            }
            [picMetaModelArray addObject:metaData];
        }];
        self.picMetaDatas = [picMetaModelArray copy];
    }

    return YES;
}
@end

////////////////////////////////////////////////////////
@implementation ZHNTimelineUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID":@"id",
             @"userDescription":@"description",
             @"profileImageUrl":@"profile_image_url",
             @"coverImage":@"cover_image",
             @"followersCount":@"followers_count",
             @"friendsCount":@"friends_count",
             @"statusesCount":@"statuses_count",
             @"avatarLarge":@"avatar_large",
             @"coverImagePhone":@"cover_image_phone",
             @"avatarHd":@"avatar_hd",
             @"verifiedReason":@"verified_reason",
             @"verifiedLevel":@"verified_level",
             @"verifiedType":@"verified_type",
             @"followMe":@"follow_me"
             };
}
@end

////////////////////////////////////////////////////////
@implementation ZHNTimelineURL
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"urlShort":@"url_short",
             @"urlLong":@"url_long"
             };
}
- (ZHNVideoMeteData *)zhn_searchVideoMetaData {
    if (!self.urlShort) {return nil;}
    NSDictionary *sqlParams = @{@"shortUrl":self.urlShort};
    return [[ZHNVideoMeteData searchWithWhere:sqlParams] lastObject];
}

+ (ZHNVideoMeteData *)zhn_searchVideoMetaDataForShortURLStr:(NSString *)shortURLStr {
    if (!shortURLStr) {return nil;}
    NSDictionary *sqlParams = @{@"shortUrl":shortURLStr};
    return [[ZHNVideoMeteData searchWithWhere:sqlParams] lastObject];
}
@end

////////////////////////////////////////////////////////
@implementation ZHNTimelinePicMetaData

@end

////////////////////////////////////////////////////////
@implementation ZHNVideoMeteData
+ (NSString *)getPrimaryKey {
    return @"shortUrl";
}
@end

