//
//  UIView+ZHNFirework.m
//  ZHNFireworks
//
//  Created by zhn on 2017/9/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIView+ZHNFirework.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
static const CGFloat KfireworkItemCount = 50;
static const CGFloat KTransLateStep1XMaxdelta = 30;
static const CGFloat KTransLateStep1YMaxdelta = 50;
static const CGFloat KTransLateStep1YMiniAdd = 100;
@implementation UIView (ZHNFirework)
- (void)fireInTheHole {
    [self p_fire];
}

#pragma mark - pravite methods
- (void)p_fire {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = [self.superview convertPoint:self.center toView:window];
    for (int index = 0; index < KfireworkItemCount; index++) {
        ZHNFireView *item = [[ZHNFireView alloc]init];
        CGFloat wh = arc4random()%20 * 0.4 + 6;
        item.center = center;
        item.bounds = CGRectMake(0, 0, wh, wh);
        item.backgroundColor = RandomColor;
        item.layer.zPosition = 1000;
        // average left right item number
        if (index > KfireworkItemCount/2) {
            [item zhn_animateIsDirectionLeft:YES];
        }else {
            [item zhn_animateIsDirectionLeft:NO];
        }
        [window addSubview:item];
    }
}
@end

/////////////////////////////////////////////////////
static NSString *const KTranslateStep1Key = @"KTranslateStep1Key";
static NSString *const KTranslateStep2Key = @"KTranslateStep2Key";
static NSString *const KTranslateStep3Key = @"KTranslateStep3Key";
@interface ZHNFireView()<CAAnimationDelegate>
@property (nonatomic,assign) BOOL isDirectionLeft;
@property (nonatomic,assign) CGPoint currentPoint;
@end

@implementation ZHNFireView
- (void)zhn_animateIsDirectionLeft:(BOOL)isDirectionLeft {
    self.isDirectionLeft = isDirectionLeft;
    // translate step1
    CGPoint centerPoint = self.center;
    int step1YDelta = arc4random()%(int)KTransLateStep1YMaxdelta;
    int step1XDelta = arc4random()%(int)KTransLateStep1XMaxdelta;
    step1XDelta = isDirectionLeft ? -step1XDelta : step1XDelta;
    self.currentPoint = CGPointMake(centerPoint.x + step1XDelta, centerPoint.y - step1YDelta - KTransLateStep1YMiniAdd);
    CABasicAnimation *translateStep1Animate = [CABasicAnimation animationWithKeyPath:@"position"];
    translateStep1Animate.duration = 0.2;
    translateStep1Animate.toValue = @(self.currentPoint);
    translateStep1Animate.fillMode = kCAFillModeForwards;
    translateStep1Animate.removedOnCompletion = NO;
    translateStep1Animate.delegate = self;
    [self.layer addAnimation:translateStep1Animate forKey:KTranslateStep1Key];
    // rotation animate
    CGFloat rotaX = (CGFloat)(arc4random()%10)/10;
    CGFloat rotaY = (CGFloat)(arc4random()%10)/10;
    CGFloat rotaZ = (CGFloat)(arc4random()%10)/10;
    CABasicAnimation *rotationAnimate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimate.duration = (arc4random()%10) * 0.05 + 0.2;
    rotationAnimate.cumulative = YES;
    rotationAnimate.repeatCount = MAXFLOAT;
    rotationAnimate.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, rotaX, rotaY, rotaZ)];
    [self.layer addAnimation:rotationAnimate forKey:nil];
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.layer animationForKey:KTranslateStep1Key]) {
        [self p_translateAnimateStepTwo];
    }
    if (anim == [self.layer animationForKey:KTranslateStep2Key]) {
        [self removeFromSuperview];
    }
}

#pragma mark - pravite methods
- (void)p_translateAnimateStepTwo {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint currentPoint = self.currentPoint;
    [path moveToPoint:currentPoint];
    int controlPointXDelta = arc4random()%300;
    int controlPointYDelta = arc4random()%300 + 200;
    controlPointXDelta = self.isDirectionLeft ? -controlPointXDelta : controlPointXDelta;
    CGPoint controlPoint = CGPointMake(currentPoint.x + controlPointXDelta, currentPoint.y - controlPointYDelta);
    
    int toPointXDelta = arc4random()%300;
    toPointXDelta = self.isDirectionLeft ? -toPointXDelta : toPointXDelta;
    CGFloat toY = [UIScreen mainScreen].bounds.size.height;
    CGPoint toPoint = CGPointMake(currentPoint.x + controlPointXDelta - toPointXDelta, toY);
    
    [path addQuadCurveToPoint:toPoint controlPoint:controlPoint];
    CAKeyframeAnimation *translateAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    translateAnimate.delegate = self;
    translateAnimate.duration = arc4random()%5 * 0.1 + 1.3;
    translateAnimate.path = path.CGPath;
    translateAnimate.fillMode = kCAFillModeForwards;
    translateAnimate.removedOnCompletion = NO;
    [self.layer addAnimation:translateAnimate forKey:KTranslateStep2Key];
}

@end



