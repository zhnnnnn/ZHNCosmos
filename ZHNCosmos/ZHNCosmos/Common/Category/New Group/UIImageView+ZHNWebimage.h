//
//  UIImageView+ZHNWebimage.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineModel.h"
typedef NS_ENUM(NSInteger,ZHNImageType) {
    ZHNImageTypeGif,
    ZHNImageTypeNormal,
    ZHNImageTypeLongImage,
};
typedef void (^ZHNVideoMeteDataHanlde)(long long videoSize, int videoDuration);
typedef void (^ZHNImageLoaderHandle)(TimelinePicType picType);
@interface UIImageView (ZHNWebimage)
/**
 Set video image
 
 @param shortUrl video short url
 @param placeholder placeholer image string
 */
- (void)zhn_setImageWithVideoShortUrl:(NSString *)shortUrl
                          placeholder:(NSString *)placeholder
                             complete:(ZHNVideoMeteDataHanlde)complete;

/**
 Set normal image

 @param picMeteData image mete data
 @param placeHolderStr placeholder
 @param complete complete handle
 */
- (void)zhn_setImageWithPicMeteData:(ZHNTimelinePicMetaData *)picMeteData
                     placeholderStr:(NSString *)placeHolderStr
                           complete:(ZHNImageLoaderHandle)complete;
@end

////////////////////////////////////////////////////////
@interface ZHNAsyncVideoLoader: NSObject
@property (nonatomic,strong) NSOperationQueue *videoQueue;
+ (instancetype)shareLoader;
@end

