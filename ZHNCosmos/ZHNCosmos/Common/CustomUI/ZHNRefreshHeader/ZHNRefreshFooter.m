//
//  ZHNRefreshFooter.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRefreshFooter.h"

static CGFloat const KFooterHeight = 50;
static CGFloat const KWH = 16;
static CGFloat const KHpadding = 25;

@interface ZHNRefreshFooter()
@property (nonatomic,strong) NSMutableArray *idotArray;
@end

@implementation ZHNRefreshFooter
- (void)prepare {
    [super prepare];
    self.mj_h = KFooterHeight;
    self.triggerAutomaticallyRefreshPercent = 1;
    for (int i = 0; i < 3; i++) {
        UIImageView *idotView = [[UIImageView alloc]init];
        idotView.isCustomThemeColor = YES;
        idotView.layer.cornerRadius = KWH/2;
        idotView.bounds = CGRectMake(0, 0, KWH, KWH);
        
        CGFloat delta = i - 1;
        CGFloat centerX  = [UIScreen mainScreen].bounds.size.width/2 + delta * KHpadding;
        CGFloat centerY = KFooterHeight/2;
        idotView.center = CGPointMake(centerX, centerY);
        
        [self addSubview:idotView];
        [self.idotArray addObject:idotView];
    }
    self.hidden = YES;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateRefreshing:
        {
            [self p_startAnimateing];
        }
            break;
        case MJRefreshStateIdle:
        {
            [self p_stopAnimating];
        }
            break;
        default:
            break;
    }
}

- (void)p_startAnimateing {
    [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CABasicAnimation *opAnimate = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opAnimate.toValue = @(0.3);
        opAnimate.duration = 0.6;
        opAnimate.repeatCount = MAXFLOAT;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * idx * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [obj.layer addAnimation:opAnimate forKey:nil];
        });
    }];
}

- (void)p_stopAnimating {
    [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [obj.layer removeAllAnimations];
        });
    }];
}

- (NSMutableArray *)idotArray {
    if (_idotArray == nil) {
        _idotArray = [NSMutableArray array];
    }
    return _idotArray;
}

@end
