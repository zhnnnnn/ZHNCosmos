//
//  ZHNImageSaveToIphoneManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNImageSaveToIphoneManager : NSObject
+ (void)zhn_saveImageDataToIphone:(NSData *)imageDate
                        imageType:(NSString *)imageType
                          success:(void(^)())successHandle
                          failure:(void(^)())failureHanlde;
@end
