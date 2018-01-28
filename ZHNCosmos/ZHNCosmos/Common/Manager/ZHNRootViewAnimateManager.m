//
//  ZHNRootViewAnimateManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRootViewAnimateManager.h"

@implementation ZHNRootViewAnimateManager
+ (void)showAnimateWithTransformScale:(CGFloat)scale {
    [ZHNRootViewAnimateManager showAnimateWithTransformScale:scale animateDuration:0.3];
}

+ (void)hideAnimateWithTramsformScale:(CGFloat)scale {
    [ZHNRootViewAnimateManager hideAnimateWithTramsformScale:scale animateDuration:0.3];
}

+ (void)showAnimateWithTransformScale:(CGFloat)scale animateDuration:(CGFloat)duration {
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [UIView animateWithDuration:duration animations:^{
        rootView.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

+ (void)hideAnimateWithTramsformScale:(CGFloat)scale animateDuration:(CGFloat)duration {
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [UIView animateWithDuration:duration animations:^{
        rootView.transform = CGAffineTransformIdentity;
    }];
}
@end
