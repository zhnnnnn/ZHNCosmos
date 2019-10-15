//
//  ZHNNightVersionChangeTransitionManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/19.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNNightVersionChangeTransitionManager.h"
#import "ZHNThemeManager.h"
#import "ZHNTimelineStatusConfigReloadObserver.h"

@interface ZHNNightVersionChangeTransitionManager()
@property (nonatomic,strong) UIWindow *transitionWindow;
@end

@implementation ZHNNightVersionChangeTransitionManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNNightVersionChangeTransitionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNNightVersionChangeTransitionManager alloc]init];
    });
    return manager;
}
+ (void)zhn_transition {
    // Init maskImage view
    ZHNNightVersionChangeTransitionManager *manager = [ZHNNightVersionChangeTransitionManager shareManager];
    UIWindow *transitionWindow = manager.transitionWindow;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *maskImageView = [keyWindow snapshotViewAfterScreenUpdates:NO];
    maskImageView.frame = keyWindow.bounds;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    UIView *fakeStatusBar = [statusBar snapshotViewAfterScreenUpdates:NO];
    fakeStatusBar.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_statusBar_height);
    [maskImageView addSubview:fakeStatusBar];
    [transitionWindow addSubview:maskImageView];
    transitionWindow.hidden = NO;
    
    // Call change theme version
    [ZHNThemeManager zhn_changeNightVersion];
    
    // Animate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat radius = sqrt(pow(K_SCREEN_WIDTH, 2) + pow(K_SCREEN_HEIGHT, 2));
        // Animate
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillRule = kCAFillRuleEvenOdd;// Layer fillRule UIBezierPath usesEvenOddFillRule need mating
        UIBezierPath *bigPath = [UIBezierPath bezierPath];
        [bigPath addArcWithCenter:CGPointZero radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
        UIBezierPath *smallPath = [UIBezierPath bezierPath];
        [smallPath addArcWithCenter:CGPointZero radius:1 startAngle:0 endAngle:M_PI clockwise:YES];
        [bigPath appendPath:smallPath];
        bigPath.usesEvenOddFillRule = YES;
        layer.path = [bigPath CGPath];
        maskImageView.layer.mask = layer;

        UIBezierPath *toBigPath = [UIBezierPath bezierPath];
        [toBigPath addArcWithCenter:CGPointZero radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
        UIBezierPath *toSmallPath = [UIBezierPath bezierPath];
        [toSmallPath addArcWithCenter:CGPointZero radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
        [toBigPath appendPath:toSmallPath];
        toBigPath.usesEvenOddFillRule = YES;

        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
        animate.toValue = (id)[toBigPath CGPath];
        animate.duration = 0.15;
        animate.fillMode = kCAFillModeForwards;
        animate.removedOnCompletion = NO;
        [layer addAnimation:animate forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [maskImageView removeFromSuperview];
            transitionWindow.hidden = YES;
        });
    });
}

- (UIWindow *)transitionWindow {
    if (_transitionWindow == nil) {
        _transitionWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *tempRootViewController = [[UIViewController alloc]init];
        tempRootViewController.view.userInteractionEnabled = NO;
        _transitionWindow.rootViewController = tempRootViewController;
        _transitionWindow.userInteractionEnabled = NO;
        _transitionWindow.windowLevel = UIWindowLevelStatusBar + 999;
    }
    return _transitionWindow;
}
@end
