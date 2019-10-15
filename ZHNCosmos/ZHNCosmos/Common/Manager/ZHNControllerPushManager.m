//
//  ZHNControllerPushManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControllerPushManager.h"
#import "ZHNNavigationViewController.h"

@implementation ZHNControllerPushManager
+ (void)zhn_pushViewControllerWithClass:(Class)cls {
    UIViewController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *ctr = [[UINavigationController alloc]initWithRootViewController:[[cls alloc]init]];
    [ZHNThemeManager zhn_extraNightHandle:^{
        ctr.navigationBar.barStyle = UIBarStyleBlack;
    } dayHandle:^{
        ctr.navigationBar.barStyle = UIBarStyleDefault;
    }];
    ctr.navigationBar.tintColor = [ZHNThemeManager zhn_getThemeColor];
    [tabbarController presentViewController:ctr animated:YES completion:nil];
}
@end
