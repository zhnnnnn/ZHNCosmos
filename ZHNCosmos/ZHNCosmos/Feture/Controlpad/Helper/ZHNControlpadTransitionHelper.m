//
//  ZHNControlpadTransitionHelper.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadTransitionHelper.h"
#import "ZHNControlpad.h"
#define KControlpadHeight (IS_IPHONEX ? (200 + K_tabbar_safeArea_height) : 200)
@interface ZHNControlpadTransitionHelper()
@property (nonatomic,strong) ZHNControlpad *controlpad;
@property (nonatomic,strong) UIView *shadowView;
@end

@implementation ZHNControlpadTransitionHelper
+ (instancetype)shareinstance {
    static ZHNControlpadTransitionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ZHNControlpadTransitionHelper alloc]init];
    });
    return helper;
}

+ (void)showControlpad {
    // init
    [ZHNControlpadTransitionHelper shareinstance].controlpad = [ZHNControlpad loadView];
    ZHNControlpad *controlpad = [ZHNControlpadTransitionHelper shareinstance].controlpad;
    UIView *shadowView = [[UIView alloc]init];
    [ZHNControlpadTransitionHelper shareinstance].shadowView = shadowView;
    shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    shadowView.alpha = 0;
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    UIView *tabbarView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    // frame
    [keywindow addSubview:shadowView];
    shadowView.frame = [UIScreen mainScreen].bounds;
    [keywindow addSubview:controlpad];
    controlpad.frame = CGRectMake(0, K_SCREEN_HEIGHT - KControlpadHeight, K_SCREEN_WIDTH, KControlpadHeight);
    controlpad.transform = CGAffineTransformMakeTranslation(0, KControlpadHeight);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:nil];
    }];
    [shadowView addGestureRecognizer:tap];
    
    // animate
    [UIView animateWithDuration:0.4 animations:^{
        shadowView.alpha = 1;
        tabbarView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        controlpad.transform = CGAffineTransformIdentity;
    }];
}

+ (void)dismissControlpadCompletion:(void(^)())completion; {
    ZHNControlpad *controlpad = [ZHNControlpadTransitionHelper shareinstance].controlpad;
    UIView *shadowView = [ZHNControlpadTransitionHelper shareinstance].shadowView;
    UIView *tabbarView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [UIView animateWithDuration:0.4 animations:^{
        tabbarView.transform = CGAffineTransformIdentity;
        controlpad.transform = CGAffineTransformMakeTranslation(0, KControlpadHeight);
        shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [[ZHNControlpadTransitionHelper shareinstance].controlpad removeFromSuperview];
        [ZHNControlpadTransitionHelper shareinstance].controlpad = nil;
        [[ZHNControlpadTransitionHelper shareinstance].shadowView removeFromSuperview];
        [ZHNControlpadTransitionHelper shareinstance].shadowView = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}
@end
