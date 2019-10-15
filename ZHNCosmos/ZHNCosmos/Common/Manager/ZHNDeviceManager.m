//
//  ZHNDeviceManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNDeviceManager.h"

@implementation ZHNDeviceManager
+ (void)zhn_statusBarAnimateToLandscapeRight {
    [ZHNDeviceManager p_statusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

+ (void)zhn_statusBarAnimateToPortrait {
    [ZHNDeviceManager p_statusBarOrientation:UIInterfaceOrientationPortrait];
}

+ (void)zhn_fadeAnimateStatusBarHidden:(BOOL)hidden {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:hidden animated:YES];
#pragma clang diagnostic pop
}

+ (void)zhn_slideAnimateStatusBarHidden:(BOOL)hidden {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
#pragma clang diagnostic pop
}

+ (void)p_statusBarOrientation:(UIInterfaceOrientation)orientation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
#pragma clang diagnostic pop
}


@end
