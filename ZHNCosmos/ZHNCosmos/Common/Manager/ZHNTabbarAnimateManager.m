//
//  ZHNTabbarAnimateManager.m
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTabbarAnimateManager.h"
#import "ZHNCosmosTabbarController.h"
#import "ZHNMagicTransition.h"
#import "ZHNCosmosTabbar.h"

#define COSMOS_TABBARCONTROLLER (ZHNCosmosTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
#define K_CUSTOM_TABBAR_HEIGHT (K_tabbar_height + K_tabbar_safeArea_height)
@implementation ZHNTabbarAnimateManager
+ (void)hideAnimate {
    ZHNCosmosTabbarController *tabbarController =  COSMOS_TABBARCONTROLLER;
    [UIView animateWithDuration:KMagicTransitionAnimateDuration animations:^{
        tabbarController.tabbar.frame = CGRectMake(0, K_SCREEN_HEIGHT, K_SCREEN_WIDTH, K_CUSTOM_TABBAR_HEIGHT);
    }];
}

+ (void)showAnimate {
    ZHNCosmosTabbarController *tabbarController =  COSMOS_TABBARCONTROLLER;
    [UIView animateWithDuration:KMagicTransitionAnimateDuration animations:^{
        tabbarController.tabbar.frame = CGRectMake(0, K_SCREEN_HEIGHT - K_CUSTOM_TABBAR_HEIGHT, K_SCREEN_WIDTH, K_CUSTOM_TABBAR_HEIGHT);
    }];
}

+ (void)translateWithPercent:(CGFloat)percent {
    ZHNCosmosTabbarController *tabbarController =  COSMOS_TABBARCONTROLLER;
    tabbarController.tabbar.frame = CGRectMake(0, K_SCREEN_HEIGHT - K_CUSTOM_TABBAR_HEIGHT * percent, K_SCREEN_WIDTH, K_CUSTOM_TABBAR_HEIGHT);
}
@end
