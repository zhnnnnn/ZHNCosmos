
//
//  UIImage+YYWebimageCache.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIImage+YYWebimageCache.h"
#import "ZHNCosmosConfigManager.h"
#import "NSString+imageQuality.h"

@implementation UIImage (YYWebimageCache)
+ (BOOL)cacheContainsImageForURLString:(NSString *)imageURLStr {
    NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURLStr]];
    return [[YYWebImageManager sharedManager].cache containsImageForKey:key];
}

+ (UIImage *)getYYCachedImageForURLString:(NSString *)imageURLStr {
    NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURLStr]];
    return [[YYWebImageManager sharedManager].cache getImageForKey:key];
}

+ (void)asyncGetYYCachedImageForURLString:(NSString *)imageURLStr successHandle:(void(^)(UIImage *))successHandle {
    NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURLStr]];
    [[YYWebImageManager sharedManager].cache getImageForKey:key withType:YYImageCacheTypeAll withBlock:^(UIImage * _Nullable image, YYImageCacheType type) {
        successHandle(image);
    }];
}

+ (NSString *)policyMappingBigPicUrlStrForNormalPicUrlStr:(NSString *)picUrlStr {
    ZHNCosmosConfigCommonModel *commonModel = [ZHNCosmosConfigManager commonConfigModel];
    NSString *bigPicUrlStr = picUrlStr;
    switch (commonModel.bigpicQuality) {
        case bigpicQualityMiddle_720P:
        {
            bigPicUrlStr = [bigPicUrlStr middle_720P];
        }
            break;
        case bigpicQualityOriginal_large:
        {
            bigPicUrlStr = [bigPicUrlStr large];
        }
            break;
        case bigpicQualitySmart:
        {
            if ([[ZHNNetworkManager shareInstance] isWIFI]) {
                bigPicUrlStr = [bigPicUrlStr large];
            }else {
                bigPicUrlStr = [bigPicUrlStr middle_720P];
            }
        }
            break;
    }
    // Cached large image priority highest
    if ([UIImage cacheContainsImageForURLString:[bigPicUrlStr large]]) {
        bigPicUrlStr = [bigPicUrlStr large];
    }
    return bigPicUrlStr;
}

+ (UIImage *)fitPlaceholderForImageUrlStr:(NSString *)imageUrlStr normalPlaceholder:(UIImage *)norPlaceholder {
    UIImage *placeholder;
    NSString *policyImageUrlStr = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:imageUrlStr];
    placeholder = [UIImage getYYCachedImageForURLString:policyImageUrlStr];
    if (!placeholder) {
        placeholder = [UIImage getYYCachedImageForURLString:[imageUrlStr middle_360P]];
        if (!placeholder) {
            placeholder = norPlaceholder;
        }
    }
    return placeholder;
}

+ (NSData *)saveToIphoneImageDataForImageURLStr:(NSString *)imageUrlStr {
    imageUrlStr = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:imageUrlStr];
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:imageUrlStr]];
    return [manager.cache getImageDataForKey:key];
}
@end
