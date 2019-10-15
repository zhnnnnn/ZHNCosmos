//
//  ZHNUniversalSettingMenu.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNUniversalSettingMenu.h"
#define KDismissAnimate 0.3
@interface ZHNUniversalSettingMenu()<ZHNAwesome3DMenuDelegate>
@property (nonatomic,strong) UIWindow *backWindow;
@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) UIVisualEffectView *blurView;
@end

@implementation ZHNUniversalSettingMenu
#pragma mark - delegate
- (void)ZHNAwesome3DMenuSelectedIndex:(NSInteger)index {
    ZHN3DMenuActivity *activity = self.menuActivityArray[index];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KDismissAnimate * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (activity.selectAction) {
            activity.selectAction();
        }
    });
}

#pragma mark - public methods
+ (ZHNUniversalSettingMenu *)zhn_universalSettingMenuWithMenuActivityArray:(NSArray<ZHN3DMenuActivity *> *)menuActivityArray centerIocnName:(NSString *)iconName{
    // create menu
    ZHNUniversalSettingMenu *universalMenu = [[ZHNUniversalSettingMenu alloc]init];
    universalMenu.menuActivityArray = menuActivityArray;
    universalMenu.coronaMenu.isCustomThemeColor = YES;
    universalMenu.coronaMenu.iconImageName = iconName;
    // create window
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    universalMenu.window = window;
    UIViewController *tempRootViewController = [[UIViewController alloc]init];
    tempRootViewController.view.userInteractionEnabled = NO;
    window.rootViewController = tempRootViewController;
    window.userInteractionEnabled = YES;
    window.windowLevel = UIWindowLevelStatusBar;
    // add blur
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = [UIScreen mainScreen].bounds;
    [window addSubview:blurView];
    universalMenu.blurView = blurView;
    blurView.alpha = 0;
    blurView.layer.zPosition = -1000;
    // add mebu
    [window addSubview:universalMenu];
    universalMenu.frame = [UIScreen mainScreen].bounds;
    return universalMenu;
}

- (void)show {
    self.backWindow.hidden = NO;
    self.window.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.coronaMenu.hidden = NO;
        self.coronaMenu.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.coronaMenu animateAllItem];
            self.blurView.alpha = 0.8;
            self.coronaMenu.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)disMiss {
    [UIView animateWithDuration:KDismissAnimate animations:^{
        self.blurView.alpha = 0;
        self.coronaMenu.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        self.backWindow.hidden = YES;
        self.window = nil;
        self.backWindow = nil;
    }];
}

#pragma mark - getters
- (void)setMenuActivityArray:(NSArray<ZHN3DMenuActivity *> *)menuActivityArray {
    _menuActivityArray = menuActivityArray;
    self.coronaMenu = [ZHNAwesome3DMenu zhn_3dMenuWithActivityArray:menuActivityArray];
    self.coronaMenu.delegate = self;
    // add subview
    [self addSubview:self.coronaMenu];
    
    CGFloat fitIos11Height = (K_tabbar_height - K_tabbar_response_height);
    self.coronaMenu.center = CGPointMake(K_SCREEN_WIDTH/2, K_SCREEN_HEIGHT - K_tabbar_response_height/2 - fitIos11Height);
    self.coronaMenu.bounds = CGRectMake(0, 0, KAUTOSCALE(250), KAUTOSCALE(250));
    self.coronaMenu.hidden = YES;
}
@end
