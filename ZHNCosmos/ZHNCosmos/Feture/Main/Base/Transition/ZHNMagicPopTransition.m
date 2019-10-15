//
//  ZHNMagicPopTransition.m
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/19.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNMagicPopTransition.h"

@implementation ZHNMagicPopTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return KMagicTransitionAnimateDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    // to vc transform init
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    toVC.view.transform = CGAffineTransformScale(toVC.view.transform, 1, KMagicTransitionScale);
    toVC.view.transform = CGAffineTransformTranslate(toVC.view.transform, -(screenWidth + KMagicTransitionDelta), 0);
    [containerView addSubview:toVC.view];
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        // to vc view animate
        toVC.view.transform = CGAffineTransformIdentity;
        // from vc view animate
        fromVC.view.transform = CGAffineTransformTranslate(fromVC.view.transform, (screenWidth + KMagicTransitionDelta), 0);
        fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, 1, KMagicTransitionScale);
    } completion:^(BOOL finished) {
        // clear status if not may effect next push
        fromVC.view.transform = CGAffineTransformIdentity;
        toVC.view.transform = CGAffineTransformIdentity;
        // need call this method to complete transition
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
