//
//  ZHNVideoLoading.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVideoLoading.h"
static NSInteger const count = 3;
static CGFloat const padding = 10;
@interface ZHNVideoLoading()
@property (nonatomic,strong) UIColor *idotColor;
@end

@implementation ZHNVideoLoading
- (void)layoutSubviews {
    [super layoutSubviews];
    for (int index = 0; index < count; index++) {
        CGFloat size = (self.width - (count - 1) * padding)/count;
        UIImageView *idot = [[UIImageView alloc]init];
        idot.layer.cornerRadius = size/2;
        CGFloat y = (self.frame.size.height - size)/2;
        CGFloat x = (padding + size) * index;
        idot.frame = CGRectMake(x, y, size, size);
        idot.backgroundColor = self.idotColor;
        [self addSubview:idot];
    }
}

+ (instancetype)zhn_createLoadForColor:(UIColor *)color {
    ZHNVideoLoading *loading = [[ZHNVideoLoading alloc]init];
    loading.idotColor = color;
    return loading;
}

- (void)zhn_loading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.layer removeAllAnimations];
            CABasicAnimation *opAnimate = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opAnimate.toValue = @(0.2);
            opAnimate.duration = 0.5;
            opAnimate.repeatCount = MAXFLOAT;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * idx * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [obj.layer addAnimation:opAnimate forKey:nil];
            });
        }];
    });
}

- (void)zhn_endLoading {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


@end
