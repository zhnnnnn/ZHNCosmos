//
//  ZHNPresentFakePushTransition.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPresentFakePushTransition.h"

@implementation ZHNPresentFakePushTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    CGRect fromFrame = fromView.frame;
    CGRect toFrame = toView.frame;
    
    fromView.frame = fromFrame;
    toView.frame = CGRectOffset(toFrame, toFrame.size.width, 0);
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        toView.frame = toFrame;
        fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width * 0.3 * -1, 0);
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}
@end
