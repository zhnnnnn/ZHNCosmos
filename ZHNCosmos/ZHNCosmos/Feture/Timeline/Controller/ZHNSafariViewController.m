//
//  ZHNSafariViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/3.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSafariViewController.h"
#import "ZHNCosmosTabbarController.h"

@implementation ZHNSafariViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredControlTintColor = [ZHNThemeManager zhn_getThemeColor];
    [ZHNThemeManager zhn_extraNightHandle:^{
        self.preferredBarTintColor = [UIColor blackColor];
    } dayHandle:^{
        self.preferredBarTintColor = [UIColor whiteColor];
    }];
}
@end
