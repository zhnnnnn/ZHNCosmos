//
//  ZHNColorPickerView.m
//  ZHNColorPicker
//
//  Created by zhn on 2017/10/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNColorPickerView.h"
#import "RSColorPickerView.h"
#import "ZHNColorSaturationBrightnessPickerView.h"
#import "UIColor+ZHNGetHSB.h"

CGFloat const KColorPickerPadding = 46;
@interface ZHNColorPickerView()<ZHNColorSaturationBrightnessPickerDeleate>
@property (nonatomic,strong) RSColorPickerView *colorPicker;
@property (nonatomic,strong) ZHNColorSaturationBrightnessPickerView *sbPicker;
// path for calculate
@property (nonatomic,strong) UIBezierPath *bigPath;
@property (nonatomic,strong) UIBezierPath *smallPath;
@property (nonatomic,strong) UIView *indicatorView;
@property (nonatomic,assign) BOOL isLayouted;
@property (nonatomic,assign) BOOL isNeedUpdateSbColorPicker;
@end

@implementation ZHNColorPickerView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.colorPicker];
        [self addSubview:self.indicatorView];
        [self addSubview:self.sbPicker];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isLayouted) {return;}
    self.isLayouted = YES;
    self.colorPicker.frame = self.bounds;
    // indicator
    self.indicatorView.bounds = CGRectMake(0, 0, KColorPickerPadding, KColorPickerPadding);
    self.indicatorView.layer.cornerRadius = KColorPickerPadding/2;
    // mask path
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CGFloat smallRadius = self.frame.size.width -KColorPickerPadding * 2;
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(KColorPickerPadding, KColorPickerPadding, smallRadius, smallRadius)];
    self.bigPath = bigPath;
    self.smallPath = smallPath;
    bigPath.usesEvenOddFillRule = YES;
    [bigPath appendPath:smallPath];
    // mask layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.path = bigPath.CGPath;
    self.colorPicker.layer.mask = maskLayer;
    // saturation brightness picker
    self.sbPicker.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat sbRadius = self.frame.size.width - KColorPickerPadding * 2 - self.sbPicker.indicatorRadius;
    self.sbPicker.bounds = CGRectMake(0, 0, sbRadius, sbRadius);
    // intital indicator position
    HSBType startColorHsbType = [self.showColor HSB];
    UIColor *colorPickerStartColor = [UIColor colorWithHue:startColorHsbType.hue saturation:1 brightness:1 alpha:1];
    self.colorPicker.selectionColor = colorPickerStartColor;
    self.indicatorView.backgroundColor = colorPickerStartColor;
    self.indicatorView.center = [self p_fitCenter:[self.colorPicker selection]];
    self.sbPicker.pickerTintColor = colorPickerStartColor;
    self.sbPicker.colorHSB = startColorHsbType;
}

#pragma mark - public methods
- (void)reloadShowColor:(UIColor *)showColor {
    self.showColor = showColor;
    HSBType startColorHsbType = [self.showColor HSB];
    UIColor *colorPickerStartColor = [UIColor colorWithHue:startColorHsbType.hue saturation:1 brightness:1 alpha:1];
    self.colorPicker.selectionColor = colorPickerStartColor;
    self.indicatorView.backgroundColor = colorPickerStartColor;
    self.indicatorView.center = [self p_fitCenter:[self.colorPicker selection]];
    [self.sbPicker reloadPickerWithPickerColor:colorPickerStartColor colorHSB:startColorHsbType];
    [self.delegate ZHNColorPickerPickColor:showColor];
}

#pragma mark - touch 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [self p_touchPoint:touches];
    if ([self.bigPath containsPoint:touchPoint]) {
        if (![self.smallPath containsPoint:touchPoint]) {
            [self p_indicatorDealingWithTouches:touches];
            [UIView animateWithDuration:0.2 animations:^{
                self.indicatorView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self p_indicatorDealingWithTouches:touches];
    [self.delegate ZHNColorPickerPickColor:self.sbPicker.selectColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        [self p_indicatorDealingWithTouches:touches];
        self.indicatorView.transform = CGAffineTransformIdentity;
    }];
    [self.delegate ZHNColorPickerPickColor:self.sbPicker.selectColor];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        [self p_indicatorDealingWithTouches:touches];
        self.indicatorView.transform = CGAffineTransformIdentity;
    }];
    [self.delegate ZHNColorPickerPickColor:self.sbPicker.selectColor];
}

#pragma mark - delegate
- (void)zhn_saturationBrightnessPickerSelectedColor:(UIColor *)color {
    [self.delegate ZHNColorPickerPickColor:self.sbPicker.selectColor];
}

- (void)zhn_saturationBrightnessPickerDragingColor:(UIColor *)color {
    [self.delegate ZHNColorPickerPickColor:self.sbPicker.selectColor];
}

#pragma mark - pravite methods
- (CGPoint)p_touchPoint:(NSSet<UITouch *> *)touches {
    UITouch *cTouch = [touches anyObject];
    CGPoint touchPoint = [cTouch locationInView:self];
    return touchPoint;
}

- (CGPoint)p_fitCenter:(CGPoint)oldCenter {
    CGFloat radius = self.bounds.size.width / 2;
    CGPoint center = CGPointMake(radius, radius);
    CGFloat fitRadius = radius - 0.5 * KColorPickerPadding;
    CGFloat distance = sqrt(pow(center.x - oldCenter.x, 2) + pow(oldCenter.y - center.y, 2));
    CGFloat x = center.x - fitRadius / distance * (center.x - oldCenter.x);
    CGFloat y = center.y + fitRadius / distance * (oldCenter.y - center.y);
    oldCenter = CGPointMake(x, y);
    return oldCenter;
}

- (void) p_indicatorDealingWithTouches:(NSSet<UITouch *> *)touches {
    CGPoint touchPoint = [self p_touchPoint:touches];
    CGPoint fitCenter = [self p_fitCenter:touchPoint];
    // while add picker view in window may cause `Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan nan]` error. no idea about so i shield this. any one know why plz tell me.
    if (isnan(touchPoint.x) || isnan(touchPoint.y) || isnan(fitCenter.x) || isnan(fitCenter.y)) {return;}
    self.indicatorView.center = fitCenter;
    self.indicatorView.backgroundColor = [self.colorPicker colorAtPoint:fitCenter];
    [self.sbPicker updatePickerColor:self.indicatorView.backgroundColor];
}

#pragma mark - getters
- (UIColor *)pickerSelectColor {
    return self.sbPicker.selectColor;
}

- (RSColorPickerView *)colorPicker {
    if (_colorPicker == nil) {
        _colorPicker = [[RSColorPickerView alloc]init];
        _colorPicker.brightness = 1;
        _colorPicker.opacity = 1;
        _colorPicker.showLoupe = NO;
        _colorPicker.userInteractionEnabled = NO;
    }
    return _colorPicker;
}

- (ZHNColorSaturationBrightnessPickerView *)sbPicker {
    if (_sbPicker == nil) {
        _sbPicker = [[ZHNColorSaturationBrightnessPickerView alloc]init];
        _sbPicker.delegate = self;
    }
    return _sbPicker;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc]init];
        _indicatorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _indicatorView.layer.borderWidth = 1.5;
    }
    return _indicatorView;
}
@end
