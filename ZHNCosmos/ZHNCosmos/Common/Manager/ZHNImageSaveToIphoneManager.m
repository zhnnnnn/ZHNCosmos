//
//  ZHNImageSaveToIphoneManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNImageSaveToIphoneManager.h"
#import <Photos/Photos.h>
#import "ZHNHudManager.h"

@implementation ZHNImageSaveToIphoneManager
+ (void)zhn_saveImageDataToIphone:(NSData *)imageDate imageType:(NSString *)imageType success:(void (^)())successHandle failure:(void (^)())failureHanlde {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageDate options:options];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [ZHNHudManager showSuccess:[NSString stringWithFormat:@"保存%@成功",imageType]];
                if (successHandle) {
                    successHandle();
                }
            }else {
                [ZHNHudManager showError:[NSString stringWithFormat:@"保存%@失败",imageType]];
                if (failureHanlde) {
                    failureHanlde();
                }
            }
        }];
    });
}
@end
