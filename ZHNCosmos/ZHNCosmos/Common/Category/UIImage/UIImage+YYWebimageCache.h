//
//  UIImage+YYWebimageCache.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYWebimageCache)

/**
 Judge if cache containes image

 @param imageURLStr cache key image url string
 @return is contain
 */
+ (BOOL)cacheContainsImageForURLString:(NSString *)imageURLStr;

/**
 Get cache image for url

 @param imageURLStr image url string
 @return cached image
 */
+ (UIImage *)getYYCachedImageForURLString:(NSString *)imageURLStr;

/**
 Async get cache image

 @param imageURLStr image url string
 @param successHandle get image handle
 */
+ (void)asyncGetYYCachedImageForURLString:(NSString *)imageURLStr
                            successHandle:(void(^)(UIImage *))successHandle;

/**
 Current big pic policy

 @param picUrlStr pic url string
 @return big pic url string
 */
+ (NSString *)policyMappingBigPicUrlStrForNormalPicUrlStr:(NSString *)picUrlStr;

/**
 Create broswer placeholder

 @param imageUrlStr show image url string
 @param norPlaceholder local placeholder image
 @return placeholder image
 */
+ (UIImage *)fitPlaceholderForImageUrlStr:(NSString *)imageUrlStr
                     normalPlaceholder:(UIImage *)norPlaceholder;

/**
 Get current policy to save to iphone image data

 @param imageUrlStr image url string
 @return image data
 */
+ (NSData *)saveToIphoneImageDataForImageURLStr:(NSString *)imageUrlStr;
@end
