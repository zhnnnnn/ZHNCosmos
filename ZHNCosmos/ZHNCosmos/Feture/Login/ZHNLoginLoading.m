//
//  ZHNLoginLoading.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/18.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNLoginLoading.h"
static CGFloat const KCycleCount = 3;
@implementation ZHNLoginLoading
- (instancetype)initWithCycleSize:(CGFloat)size cycleColor:(UIColor *)Color {
    if (self = [super init]) {
        for (int index = 0; index < KCycleCount; index++) {
            UIView *circle = [[UIView alloc]init];
            circle.backgroundColor = Color;
            circle.layer.cornerRadius = size/2;
            circle.bounds = CGRectMake(0, 0, size, size);
            [self addSubview:circle];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int index = 0; index < KCycleCount; index++) {
        UIView *cycle = self.subviews[index];
        CGFloat centerx = (index - 1) * cycle.width + self.width/2;
        CGFloat centery = self.height/2;
        cycle.center = CGPointMake(centerx, centery);
    }
}

- (void)startAnimate {
    CABasicAnimation *rotationAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimate.duration = 1;
    rotationAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimate.repeatCount = MAXFLOAT;
    rotationAnimate.fromValue = @(0);
    rotationAnimate.toValue = @(M_PI * 2);
    [self.layer addAnimation:rotationAnimate forKey:nil];
}
@end
