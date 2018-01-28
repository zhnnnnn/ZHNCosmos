//
//  ZHNMainControllerColorPickerTrasitionHelper.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNMainControllerColorPickerTrasitionHelper.h"
#import "ZHNThemeColorPickerView.h"

static CGFloat const KColorPickerTrasitionDuration = 0.15;
static CGFloat const KWidthPerent = 0.8;
#define KHeihgtPercent (IS_IPHONEX ? 0.65 : (IS_IPHONE_6P_7P_8P ? 0.75 : (IS_IPHONE_6_7_8 ? 0.75 : (IS_IPHONE_5_5S_5C ? 0.85 : 0.9))))
@interface ZHNMainControllerColorPickerTrasitionHelper()
@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) ZHNThemeColorPickerView *colorPickerMenuView;
@property (nonatomic,assign) UIView *tabbarControllerView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *colorNoticeBackgroundView;
@property (nonatomic,assign) BOOL isShowed;
@end

@implementation ZHNMainControllerColorPickerTrasitionHelper
+ (void)showColorPicker {
    ZHNMainControllerColorPickerTrasitionHelper *helper = [ZHNMainControllerColorPickerTrasitionHelper p_shareinstance];
    UIView *containerView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    helper.tabbarControllerView = containerView;
    // add a mask
    UIView *maskView = [[UIView alloc]init];
    UIView *colorNoticeBackgroundView = [[UIView alloc]init];
    maskView.frame = [UIScreen mainScreen].bounds;
    colorNoticeBackgroundView.frame = maskView.bounds;
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    colorNoticeBackgroundView.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
    maskView.layer.zPosition = -1000;
    colorNoticeBackgroundView.layer.zPosition = -1000;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow insertSubview:maskView belowSubview:containerView];
    [keyWindow insertSubview:colorNoticeBackgroundView belowSubview:maskView];
    helper.maskView = maskView;
    helper.colorNoticeBackgroundView = colorNoticeBackgroundView;
    
    helper.window = keyWindow;
    ZHNThemeColorPickerView *colorPickerMenuView = [[ZHNThemeColorPickerView alloc]init];
    colorPickerMenuView.userInteractionEnabled = YES;
    colorPickerMenuView.center = CGPointMake(K_SCREEN_WIDTH/2, K_SCREEN_HEIGHT/2);
    colorPickerMenuView.bounds = CGRectMake(0, 0, KWidthPerent * K_SCREEN_WIDTH, KHeihgtPercent * K_SCREEN_HEIGHT);
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = 1.0 / -500;
    trans = CATransform3DRotate(trans, -M_PI_2, 0.0f, 1.0f, 0.0f);
    colorPickerMenuView.layer.transform = trans;
    [keyWindow addSubview:colorPickerMenuView];
    helper.colorPickerMenuView = colorPickerMenuView;
    
    // animate
    [UIView animateWithDuration:KColorPickerTrasitionDuration animations:^{
        CATransform3D trans = CATransform3DIdentity;
        trans.m34 = 1.0/-500;
        trans = CATransform3DRotate(trans, M_PI_2, 0.0f, 1.0f, 0.0f);
        trans = CATransform3DScale(trans, KWidthPerent, KHeihgtPercent, 1);
        containerView.layer.transform = trans;
    } completion:^(BOOL finished) {
        [self p_animateShowColorPicker];
    }];
    
    [UIView animateWithDuration:3*KColorPickerTrasitionDuration animations:^{
        maskView.alpha = 0.6;
    }];
}

+ (void)disMissColorPciker {
    ZHNMainControllerColorPickerTrasitionHelper *helper = [ZHNMainControllerColorPickerTrasitionHelper p_shareinstance];
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = 1.0 / -500;
    trans = CATransform3DRotate(trans, -M_PI_2, 0.0f, 1.0f, 0.0f);
    trans = CATransform3DScale(trans, KWidthPerent, KHeihgtPercent, 1);
    helper.tabbarControllerView.layer.transform = trans;
    [UIView animateWithDuration:KColorPickerTrasitionDuration animations:^{
        CATransform3D trans = CATransform3DIdentity;
        trans.m34 = 1.0 / -500;
        trans = CATransform3DRotate(trans, M_PI_2, 0.0f, 1.0f, 0.0f);
        helper.colorPickerMenuView.layer.transform = trans;
    } completion:^(BOOL finished) {
        [helper.colorPickerMenuView removeFromSuperview];
        helper.colorPickerMenuView.hidden = YES;
        helper.colorPickerMenuView = nil;
        helper.window = nil;
        [self p_animateDismissColorPicker];
    }];
    
    [UIView animateWithDuration:3*KColorPickerTrasitionDuration animations:^{
        helper.maskView.alpha = 0;
    }];
}

+ (void)disMissColorPickerWithCompletion:(ZHNColorPickerDismissCompletionBlock)completion {
    [ZHNMainControllerColorPickerTrasitionHelper disMissColorPciker];
    if (!completion) {return;}
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KColorPickerTrasitionDuration * 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });
}

#pragma mark - pravite methods
+ (void)p_animateShowColorPicker {
    ZHNMainControllerColorPickerTrasitionHelper *helper = [ZHNMainControllerColorPickerTrasitionHelper p_shareinstance];
    [UIView animateWithDuration:KColorPickerTrasitionDuration * 3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helper.colorPickerMenuView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
    }];
    
    // change back color
    [helper.colorPickerMenuView.colorChangeSubject subscribeNext:^(UIColor *color) {
        helper.colorNoticeBackgroundView.backgroundColor = color;
    }];
}

+ (void)p_animateDismissColorPicker {
    ZHNMainControllerColorPickerTrasitionHelper *helper = [ZHNMainControllerColorPickerTrasitionHelper p_shareinstance];
    UIView *containerView = helper.tabbarControllerView;
    [UIView animateWithDuration:KColorPickerTrasitionDuration animations:^{
        containerView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        helper.window = nil;
        [helper.colorPickerMenuView removeFromSuperview];
        helper.colorPickerMenuView = nil;
        [helper.maskView  removeFromSuperview];
        helper.maskView = nil;
        [helper.colorNoticeBackgroundView removeFromSuperview];
        helper.colorNoticeBackgroundView = nil;
        helper.tabbarControllerView = nil;
    }];
}

+ (instancetype)p_shareinstance {
    static ZHNMainControllerColorPickerTrasitionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ZHNMainControllerColorPickerTrasitionHelper alloc]init];
    });
    return helper;
}
@end
