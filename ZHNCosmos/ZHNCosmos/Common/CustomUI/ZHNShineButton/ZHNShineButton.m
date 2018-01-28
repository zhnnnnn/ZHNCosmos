//
//  ZHNShineButton.m
//  ZHNShineButton
//
//  Created by zhn on 2017/8/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNShineButton.h"

#define K_VIEW_WIDTH self.frame.size.width
CGFloat const KcycleMiniPercnet = 0.2;
CGFloat const KcycleMidPercent = 0.6;
CGFloat const KAnimateStep1Duration = 0.1;
CGFloat const KAnimateStep2Duration = 0.2;
CGFloat const KLineAnimateStep1Duration = 0.2;
CGFloat const KLineAnimateStep2Duration = 0.35;
CGFloat const KLineDleta = 3;
CGFloat const KImageLayerShowScale = 0.65;
CGFloat const KMinLineWH = 1.5;
NSString *const KAnimateStep1Key = @"KAnimateStep1Key";
NSString *const KAnimateStep2Key = @"KAnimateStep2Key";
NSString *const KAnimateStep3Key = @"KAnimateStep3Key";
NSString *const KLineAnimateStep1Key = @"KLineAnimateStep1Key";
NSString *const KLineAnimateStep2Key = @"KLineAnimateStep2Key";
NSString *const KAnimateStopKey = @"KAnimateStopKey";
@interface ZHNShineButton()<CAAnimationDelegate>
// proprety
@property (nonatomic,copy) zhnActionBlcok normalAction;
@property (nonatomic,copy) zhnActionBlcok hightlihgtAction;
@property (nonatomic,strong) UIColor *shineTintColor;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightImage;
// view
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) ZHNAnimateLineContainerView *lineContainerView;
@property (nonatomic,strong) CAShapeLayer *maskLayer;
// tag
@property (nonatomic,assign) BOOL isAnimating;
@property (nonatomic,assign) BOOL isHightLight;
@end

@implementation ZHNShineButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lineContainerView];
        [self.layer addSublayer:self.circleLayer];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.circleLayer.frame = self.bounds;
    self.lineContainerView.frame = self.bounds;
    self.maskLayer.frame = self.bounds;
    self.imageView.frame = self.bounds;
    self.imageView.transform = CGAffineTransformMakeScale(KImageLayerShowScale, KImageLayerShowScale);
    UIImage *curImage = self.isHightLight ? self.highlightImage : self.normalImage;
    self.imageView.image = curImage;
    self.lineContainerView.lineColor = self.shineTintColor;
    self.circleLayer.fillColor = self.shineTintColor.CGColor;
    // gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_animateStep1)];
    [self addGestureRecognizer:tap];
}

#pragma mark - delegates
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.circleLayer animationForKey:KAnimateStep1Key]) {
        [self p_animateStep2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.lineContainerView lineAnimate];
            [self p_imageLayerAnimate];
        });
    }
    if (anim == [self.circleLayer animationForKey:KAnimateStep2Key]) {
        self.circleLayer.hidden = YES;
    }
    if (anim == [self.imageView.layer animationForKey:KAnimateStopKey]) {
        [self.maskLayer removeAllAnimations];
        self.maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:0]].CGPath;
        self.isAnimating = NO;
    }
}

#pragma mark - public methods
- (void)clearHightLight {
    self.isHightLight = NO;
    self.imageView.image = self.normalImage;
}

- (void)noAnimationHgihtLight {
    self.isHightLight = YES;
    self.imageView.image = self.highlightImage;
}

- (void)animateHightLight {
    [self p_animateStep1];
}

+ (instancetype)zhn_shineButtonWithTintColor:(UIColor *)tintColor normalImage:(UIImage *)normalImage hightLightImage:(UIImage *)hightLightImage normalTypeTapAction:(zhnActionBlcok)normalAction hightLightTypeTapAction:(zhnActionBlcok)hightLightAction {
    ZHNShineButton *button = [[ZHNShineButton alloc]init];
    button.shineTintColor = tintColor;
    button.normalImage = normalImage;
    button.highlightImage = hightLightImage;
    button.normalAction = normalAction;
    button.hightlihgtAction = hightLightAction;
    button.isNeedDealingActions = YES;
    return button;
}

- (void)reloadStateWithNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightLightImage tintColor:(UIColor *)tintColor {
    self.normalImage = normalImage;
    self.highlightImage = hightLightImage;
    self.shineTintColor = tintColor;
    self.lineContainerView.lineColor = self.shineTintColor;
    self.circleLayer.fillColor = self.shineTintColor.CGColor;
    self.lineContainerView.lineColor = self.shineTintColor;
    if (self.isHightLight) {
        self.imageView.image = hightLightImage;
    }
}

- (void)reloadStateWithNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightLightImage showingImage:(UIImage *)showingImage tintColor:(UIColor *)tintColor {
    [self reloadStateWithNormalImage:normalImage hightlightImage:hightLightImage tintColor:tintColor];
    self.imageView.image = showingImage;
}

#pragma mark - pravite methods
- (void)p_animateStep1 {
    // animateing if have hight action dealing
    if (self.isAnimating) {
        if (self.isNeedDealingActions) {
            if (self.hightlihgtAction) {
                self.hightlihgtAction();
            }
        }
        return;
    }
    
    //tap action
    if (self.isHightLight) {
        if (self.isNeedDealingActions) {
            if (self.hightlihgtAction) {
                self.hightlihgtAction();
            }
        }
        if (self.isCycleResponse) {
            [self clearHightLight];
            return;
        }
        if (!self.isNeedAnimateEverytime) {
            return;
        }
    }else {
        if (self.isNeedDealingActions) {
            if (self.normalAction) {
                self.normalAction();
            }
        }
    }
    // tag
    self.isAnimating = YES;
    self.isHightLight = YES;
    // icon
    self.imageView.hidden = YES;
    // layer
    self.lineContainerView.hidden = NO;
    self.circleLayer.hidden = NO;
    // animate
    CABasicAnimation *animateStep1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animateStep1.delegate = self;
    animateStep1.fromValue = (id)[UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:KcycleMiniPercnet]].CGPath;
    animateStep1.toValue = (id)[UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:KcycleMidPercent]].CGPath;;
    animateStep1.duration = KAnimateStep1Duration;
    animateStep1.removedOnCompletion = NO;
    animateStep1.fillMode = kCAFillModeForwards;
    [self.circleLayer addAnimation:animateStep1 forKey:KAnimateStep1Key];
}

- (void)p_animateStep2 {
    // 1.circle
    // need remove
    [self.circleLayer removeAllAnimations];
    CABasicAnimation *animateStep2 = [CABasicAnimation animationWithKeyPath:@"path"];
    // start
    UIBezierPath *fromSmallPath = [UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:0]];
    UIBezierPath *fromBigPath = [UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:KcycleMidPercent]];
    fromBigPath.usesEvenOddFillRule = YES;
    [fromBigPath appendPath:fromSmallPath];
    // end
    UIBezierPath *toSmallPath = [UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:1]];
    UIBezierPath *toBigPath = [UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:1]];
    toBigPath.usesEvenOddFillRule = YES;
    [toBigPath appendPath:toSmallPath];
    // animate
    animateStep2.fromValue = (id)fromBigPath.CGPath;
    animateStep2.toValue = (id)toBigPath.CGPath;
    animateStep2.duration = KAnimateStep2Duration;
    animateStep2.removedOnCompletion = NO;
    animateStep2.fillMode = kCAFillModeForwards;
    animateStep2.delegate = self;
    [self.circleLayer addAnimation:animateStep2 forKey:KAnimateStep2Key];
    
    // 2.mask
    CABasicAnimation *maskAnimateStep2 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimateStep2.fromValue = (id)[UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:KcycleMidPercent]].CGPath;
    maskAnimateStep2.toValue = (id)[UIBezierPath bezierPathWithOvalInRect:[self p_createOvalWithPercent:1]].CGPath;
    maskAnimateStep2.duration = KAnimateStep2Duration;
    maskAnimateStep2.removedOnCompletion = NO;
    maskAnimateStep2.fillMode = kCAFillModeForwards;
    [self.maskLayer addAnimation:maskAnimateStep2 forKey:nil];
}

- (void)p_imageLayerAnimate {
    self.imageView.hidden = NO;
    self.imageView.image = self.highlightImage;
    CAKeyframeAnimation *imageScaleAnimate = [[CAKeyframeAnimation alloc]init];
    imageScaleAnimate.keyPath = @"transform.scale";
    imageScaleAnimate.values = @[@(0),@(KImageLayerShowScale + 0.2),@(KImageLayerShowScale - 0.15),@(KImageLayerShowScale),@(KImageLayerShowScale - 0.1),@(KImageLayerShowScale)];
    imageScaleAnimate.keyTimes = @[@(0),@(KAnimateStep2Duration + 0.15),@(KAnimateStep2Duration + 0.3 ),@(KAnimateStep2Duration + 0.4),@(KAnimateStep2Duration + 0.45),@(KAnimateStep2Duration + 0.45)];
    imageScaleAnimate.duration = KAnimateStep2Duration + 0.65;
    imageScaleAnimate.removedOnCompletion = NO;
    imageScaleAnimate.fillMode = kCAFillModeForwards;
    imageScaleAnimate.delegate = self;
    [self.imageView.layer addAnimation:imageScaleAnimate forKey:KAnimateStopKey];
}

- (CGRect)p_createOvalWithPercent:(CGFloat)percent {
    CGFloat weightHeight = self.frame.size.width * percent;
    CGFloat x = (self.frame.size.width - weightHeight) / 2;
    CGFloat y = (self.frame.size.height - weightHeight) / 2;
    return CGRectMake(x, y, weightHeight, weightHeight);
}

#pragma mark - setters
- (void)setUnconventionalImage:(UIImage *)unconventionalImage {
    _unconventionalImage = unconventionalImage;
    self.imageView.image = unconventionalImage;
}

#pragma mark - getters
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (CAShapeLayer *)circleLayer {
    if (_circleLayer == nil) {
        _circleLayer = [[CAShapeLayer alloc]init];
        _circleLayer.fillRule = kCAFillRuleEvenOdd;
    }
    return _circleLayer;
}

- (UIView *)lineContainerView {
    if (_lineContainerView == nil) {
        _lineContainerView = [[ZHNAnimateLineContainerView alloc]init];
        _lineContainerView.layer.mask = self.maskLayer;
    }
    return _lineContainerView;
}

- (CAShapeLayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [[CAShapeLayer alloc]init];
    }
    return _maskLayer;
}
@end

/////////////////////////////////////////////////////
@interface ZHNAnimateLineContainerView()<CAAnimationDelegate>
@property (nonatomic,strong) NSMutableArray *lineArray;
@end

@implementation ZHNAnimateLineContainerView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int index = 0; index < 5; index++) {
            // line
            CAShapeLayer *line = [[CAShapeLayer alloc]init];
            [self.layer addSublayer:line];
            [self.lineArray addObject:line];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int index = 0; index < self.lineArray.count; index++) {
        CAShapeLayer *line = self.lineArray[index];
        line.fillColor = self.lineColor.CGColor;
        line.transform = CATransform3DIdentity;
        line.anchorPoint = CGPointMake(0, 0.5);
        line.frame = CGRectMake(K_VIEW_WIDTH / 2, K_VIEW_WIDTH / 2, K_VIEW_WIDTH / 2, KMinLineWH);
        line.path = [UIBezierPath bezierPathWithRect:CGRectMake(KLineDleta, 0, K_VIEW_WIDTH / 2 - KLineDleta - 1, KMinLineWH)].CGPath;
        line.transform = CATransform3DMakeRotation(M_PI * 2 / 5 * index + M_PI_2, 0, 0, KMinLineWH);
    }
}

#pragma mark - delegates
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CAShapeLayer *layer = self.lineArray.firstObject;
    if (anim == [layer animationForKey:KLineAnimateStep1Key]) {
        [self p_lineAlphaTranslateAnimate];
    }
    if (anim == [layer animationForKey:KLineAnimateStep2Key]) {
        self.hidden = YES;
        for (CAShapeLayer *line in self.lineArray) {
            [line removeAllAnimations];
            line.path = [UIBezierPath bezierPathWithRect:CGRectMake(KLineDleta, 0, K_VIEW_WIDTH / 2 - KLineDleta - 1, KMinLineWH)].CGPath;
        }
    }
}

#pragma mark - public methods
- (void)lineAnimate {
    for (int index = 0; index < self.lineArray.count; index++) {
        CAShapeLayer *line = self.lineArray[index];
        CABasicAnimation *lineAnimate = [CABasicAnimation animationWithKeyPath:@"path"];
        lineAnimate.fromValue = (id)[UIBezierPath bezierPathWithRect:CGRectMake(KLineDleta, 0, K_VIEW_WIDTH / 2 - KLineDleta - 1, KMinLineWH)].CGPath;
        lineAnimate.toValue = (id)[UIBezierPath bezierPathWithRect:CGRectMake(K_VIEW_WIDTH / 2 - KLineDleta - KMinLineWH, 0, KMinLineWH, KMinLineWH)].CGPath;
        lineAnimate.duration = KLineAnimateStep1Duration;
        lineAnimate.fillMode = kCAFillModeForwards;
        lineAnimate.removedOnCompletion = NO;
        lineAnimate.delegate = self;
        [line addAnimation:lineAnimate forKey:KLineAnimateStep1Key];
    }
}

#pragma mark - pravite methods
- (void)p_lineAlphaTranslateAnimate {
    for (int index = 0; index < self.lineArray.count; index++) {
        CAShapeLayer *line = self.lineArray[index];
        [line removeAllAnimations];
        CABasicAnimation *lineAnimate = [CABasicAnimation animationWithKeyPath:@"path"];
        lineAnimate.fromValue = (id)[UIBezierPath bezierPathWithRect:CGRectMake(K_VIEW_WIDTH / 2 - KLineDleta - 2, 0, KMinLineWH, KMinLineWH)].CGPath;
        lineAnimate.toValue = (id)[UIBezierPath bezierPathWithRect:CGRectMake(K_VIEW_WIDTH / 2 - KMinLineWH, 0, KMinLineWH, KMinLineWH)].CGPath;
        lineAnimate.duration = KLineAnimateStep2Duration;
        lineAnimate.fillMode = kCAFillModeForwards;
        lineAnimate.removedOnCompletion = NO;
        lineAnimate.delegate = self;
        [line addAnimation:lineAnimate forKey:KLineAnimateStep2Key];
    }
}

#pragma mark - setters
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self.lineArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *layer = (CAShapeLayer *)obj;
        layer.fillColor = self.lineColor.CGColor;
    }];
}

#pragma mark - getters
- (NSMutableArray *)lineArray {
    if (_lineArray == nil) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

@end

