//
//  ZHNRefreshHeader.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRefreshHeader.h"

typedef NS_ENUM(NSInteger,ZHNRefreshHeaderIdotType) {
    ZHNRefreshHeaderIdotTypeNone,
    ZHNRefreshHeaderIdotTypeAnimating,
    ZHNRefreshHeaderIdotTypeDone,
};

static CGFloat const KVpadding = 30;
static CGFloat const KHpadding = 25;
static CGFloat const KWH = 16;
static CGFloat const KnormalAlpha = 0.3;
static CGFloat const KeverageDelta = 0.2;
static CGFloat const KHeaderHeight = 50;
@interface ZHNRefreshHeader()
@property (nonatomic,strong) NSMutableArray <UIImageView *> *idotArray;
@property (nonatomic,assign) ZHNRefreshHeaderIdotType idotType;
@property (nonatomic,assign) int idotIndex;
@property (nonatomic,assign) CGFloat idotPercent;
@end

@implementation ZHNRefreshHeader
- (void)prepare {
    [super prepare];
    self.mj_h = KHeaderHeight;
    for (int i = 0; i < 3; i++) {
        UIImageView *idotView = [[UIImageView alloc]init];
        idotView.isCustomThemeColor = YES;
        idotView.layer.cornerRadius = KWH/2;
        idotView.alpha = KnormalAlpha;
        idotView.bounds = CGRectMake(0, 0, KWH, KWH);
        
        CGFloat delta = i - 1;
        CGFloat centerX  = [UIScreen mainScreen].bounds.size.width/2 + delta * KHpadding;
        CGFloat centerY = KHeaderHeight/2;
        idotView.center = CGPointMake(centerX, centerY);
        idotView.transform = CGAffineTransformMakeTranslation(0, -KVpadding);

        [self addSubview:idotView];
        [self.idotArray addObject:idotView];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    CGFloat Kmin = 1 - 3 * KeverageDelta;
    if (pullingPercent > Kmin) {
        CGFloat findex = (pullingPercent - Kmin)/KeverageDelta;
        int index = findex;
        if (index < 3) {
            self.idotIndex = index;
            self.idotPercent = findex - index;
            self.idotType = ZHNRefreshHeaderIdotTypeAnimating;
        }else {
            self.idotType = ZHNRefreshHeaderIdotTypeDone;
        }
    }else {
        self.idotType = ZHNRefreshHeaderIdotTypeNone;
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateRefreshing:
        {
            [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CABasicAnimation *opAnimate = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opAnimate.toValue = @(KnormalAlpha);
                opAnimate.duration = 0.6;
                opAnimate.repeatCount = MAXFLOAT;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * idx * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [obj.layer addAnimation:opAnimate forKey:nil];
                });
            }];
        }
        case MJRefreshStateIdle:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.layer removeAllAnimations];
                }];
            });
        }
        default:
            break;
    }
}

#pragma mark - pravite methods
- (void)p_viewIndex:(int)index percent:(CGFloat)percent {
    [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.transform = CGAffineTransformMakeTranslation(0, (percent - 1) * KVpadding);
            obj.alpha = KnormalAlpha;
        }
        
        if (idx < index) {
            obj.transform = CGAffineTransformIdentity;
            obj.alpha = 1;
        }
        
        if (idx > index) {
            obj.transform = CGAffineTransformMakeTranslation(0, -KVpadding);
            obj.alpha = KnormalAlpha;
        }
    }];
}

#pragma mark - setters
- (void)setIdotType:(ZHNRefreshHeaderIdotType)idotType {
    _idotType = idotType;
    switch (idotType) {
        case ZHNRefreshHeaderIdotTypeAnimating:
        {
            [self p_viewIndex:self.idotIndex percent:self.idotPercent];
        }
            break;
        case ZHNRefreshHeaderIdotTypeNone:
        {
            [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = CGAffineTransformMakeTranslation(0, -KVpadding);
                obj.alpha = KnormalAlpha;
            }];
        }
            break;
        case ZHNRefreshHeaderIdotTypeDone:
        {
            [self.idotArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = CGAffineTransformIdentity;
                obj.alpha = 1;
            }];
        }
            break;
    }
}

#pragma mark - getters
- (NSMutableArray *)idotArray {
    if (_idotArray == nil) {
        _idotArray = [NSMutableArray array];
    }
    return _idotArray;
}
@end
