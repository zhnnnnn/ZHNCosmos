//
//  ZHNTopHud.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/31.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTopHud.h"
#define ZHN_HUD_IS_IPHONEX (K_SCREEN_HEIGHT == 812)
#define KStatusBarFitHeight (ZHN_HUD_IS_IPHONEX ? 20 : 0)
#define KHudContentHeight 36
#define KHudHeight (KHudContentHeight + KStatusBarFitHeight)
#define KHudPadding 8
#define KCornerRadius 8
@interface ZHNTopHud()
@property (nonatomic,strong) UIWindow *hudWindow;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIImageView *hudContainerView;
@property (nonatomic,strong) UIVisualEffectView *blurEffectView;
@property (nonatomic,strong) NSTimer *dismissTimer;
@end

@implementation ZHNTopHud
+ (ZHNTopHud *)shareinstance {
    static ZHNTopHud *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // hud
        hud = [[ZHNTopHud alloc]init];
        UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        hud.hudWindow = window;
        UIViewController *tempRootViewController = [[UIViewController alloc]init];
        tempRootViewController.view.userInteractionEnabled = NO;
        window.rootViewController = tempRootViewController;
        window.userInteractionEnabled = NO;
        window.windowLevel = UIWindowLevelStatusBar + 999;
        // containerView
        UIImageView *containerView = [[UIImageView alloc]init];
        hud.hudContainerView = containerView;
        containerView.frame = CGRectMake(KHudPadding, KHudPadding, K_SCREEN_WIDTH - 2 * KHudPadding, KHudHeight);
        [window addSubview:containerView];
        containerView.layer.cornerRadius = KCornerRadius;
        
        // blureffect
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        blurView.layer.cornerRadius = KCornerRadius;
        blurView.clipsToBounds = YES;
        hud.blurEffectView = blurView;
        blurView.frame = containerView.bounds;
        [containerView addSubview:blurView];
        // icon
        UIImageView *iconImageView = [[UIImageView alloc]init];
        [containerView addSubview:iconImageView];
        CGFloat yDelta = (KHudContentHeight - 20) / 2;
        iconImageView.frame = CGRectMake(10, yDelta + KStatusBarFitHeight, 20, 20);
        hud.iconImageView = iconImageView;
        // title
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        hud.titleLabel = titleLabel;
        [containerView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(40, KStatusBarFitHeight, K_SCREEN_WIDTH - 50, KHudContentHeight);
        // shadow
        containerView.layer.shadowColor = [UIColor whiteColor].CGColor;
        containerView.layer.shadowOpacity = 0.5;
        containerView.layer.shadowOffset = CGSizeMake(0, 2);
        // transform
        containerView.transform = CGAffineTransformMakeTranslation(0, - KHudHeight);
    });
    return hud;
}

#pragma mark - public methods
+ (void)setDefaultMaskType:(ZHNTopHudMaskType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBlurEffectStyle style = type == ZHNTopHudMaskTypeLight ? UIBlurEffectStyleExtraLight : UIBlurEffectStyleDark;
        UIColor *textColor = type == ZHNTopHudMaskTypeLight ? [UIColor blackColor] : [UIColor whiteColor];
        UIColor *shadowColor = type == ZHNTopHudMaskTypeLight ? [UIColor blackColor] : [UIColor whiteColor];
        ZHNTopHud *hud = [ZHNTopHud shareinstance];
        hud.blurEffectView.effect = [UIBlurEffect effectWithStyle:style];
        hud.titleLabel.textColor = textColor;
        hud.hudContainerView.layer.shadowColor = shadowColor.CGColor;
    });
}

+ (void)setHUDTintColor:(UIColor *)HUDTintColor isNeedBlur:(BOOL)needBlur {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZHNTopHud shareinstance].hudContainerView.backgroundColor = HUDTintColor;
        [ZHNTopHud shareinstance].blurEffectView.hidden = !needBlur;
    });
}

+ (void)setTextColor:(UIColor *)textColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZHNTopHud shareinstance].titleLabel.textColor = textColor;
    });
}

+ (void)showMessage:(NSString *)message withIconImagename:(NSString *)imagename {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZHNTopHud shareinstance].iconImageView.image = [UIImage imageNamed:imagename];
        [ZHNTopHud shareinstance].titleLabel.text = message;
        [ZHNTopHud p_delayDismissAnimate];
        [ZHNTopHud shareinstance].hudWindow.hidden = NO;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
            [ZHNTopHud shareinstance].hudContainerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    });
}

+ (void)showSuccess:(NSString *)success {
    [ZHNTopHud showMessage:success withIconImagename:@"notice_type_success"];
}

+ (void)showError:(NSString *)error {
    [ZHNTopHud showMessage:error withIconImagename:@"notice_type_error"];
}

+ (void)showWarning:(NSString *)warning {
    [ZHNTopHud showMessage:warning withIconImagename:@"notice_type_warnning"];
}

#pragma mark - pravite methods
+ (void)dismissHud {
    [UIView animateWithDuration:0.3 animations:^{
        [ZHNTopHud shareinstance].hudContainerView.transform = CGAffineTransformMakeTranslation(0, - KHudHeight - 30);
    } completion:^(BOOL finished) {
        [ZHNTopHud shareinstance].hudWindow.hidden = YES;
    }];
}

+ (void)p_delayDismissAnimate {
    ZHNTopHud *hud = [ZHNTopHud shareinstance];
    // clear old timer
    [hud.dismissTimer invalidate];
    hud.dismissTimer = nil;
    // init new timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [ZHNTopHud dismissHud];
    }];
    hud.dismissTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
@end
