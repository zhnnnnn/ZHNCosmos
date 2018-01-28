//
//  ZHNCosmosNavigationViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNNavigationViewController.h"
#import "ZHNCosmosTabbarController.h"
#import "ZHNScrollingNavigationController.h"
#import "ZHNTabbarAnimateManager.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNNavigationViewController ()

@end

@implementation ZHNNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_barItemFlollowAlpha = YES;
    self.expandOnActive = NO;
    
    @weakify(self);
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        [ZHNThemeManager zhn_extraNightHandle:^{
            self.navigationBar.barStyle = UIBarStyleBlack;
            self.navigationBar.barTintColor = [UIColor clearColor];
            [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            self.navigationBar.tintColor = [ZHNThemeManager zhn_getThemeColor];
        } dayHandle:^{
            self.navigationBar.barStyle = UIBarStyleDefault;
            ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
            UIColor *textColor = common.navigationbarFitThemeColor ? [UIColor whiteColor] : [UIColor blackColor];
            [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor}];
            [self p_navigationBarTintColorFollowThemeColorIfNeed];
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadFakeNavibarTitleLabelTextColor];
        });
    };
    
    self.extraThemeColorChangeHandle = ^{
        @strongify(self);
        [ZHNThemeManager zhn_extraNightHandle:^{
            self.navigationBar.barTintColor = [UIColor clearColor];
        } dayHandle:^{
            [self p_navigationBarTintColorFollowThemeColorIfNeed];
        }];
    };
    
    NSString *navibarFollowThemeNotificaiton = [ZHNCosmosConfigCommonModel zhn_resetConfigSuccessNotificationNameForPropertyName:NSStringFromSelector(@selector(navigationbarFitThemeColor))];
    [[[[NSNotificationCenter defaultCenter]
    rac_addObserverForName:navibarFollowThemeNotificaiton object:nil]
    takeUntil:self.rac_willDeallocSignal]
    subscribeNext:^(id x) {
        @strongify(self);
        if (self.extraThemeColorChangeHandle) {
            self.extraThemeColorChangeHandle();
        }
    }];
}

- (void)p_navigationBarTintColorFollowThemeColorIfNeed {
    ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
    if (common.navigationbarFitThemeColor) {
        self.navigationBar.barTintColor = [ZHNThemeManager zhn_getThemeColor];
        self.navigationBar.tintColor = [UIColor whiteColor];
    }else {
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.tintColor = [ZHNThemeManager zhn_getThemeColor];
    }
}

+ (void)zhn_showWholeNavibarIfNeed {
    ZHNCosmosTabbarController *tabbarController = (ZHNCosmosTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *selectedController = tabbarController.tabbar.selectedController;
    if ([selectedController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        [(ZHNScrollingNavigationController *)selectedController showNavbarWithAnimate:YES duration:0.1];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
