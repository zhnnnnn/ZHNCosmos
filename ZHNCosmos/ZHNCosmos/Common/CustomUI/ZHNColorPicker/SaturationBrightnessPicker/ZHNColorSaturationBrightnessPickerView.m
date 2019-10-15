//
//  ZHNColorSaturationBrightnessPickerView.m
//  ZHNColorPicker
//
//  Created by zhn on 2017/9/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNColorSaturationBrightnessPickerView.h"
#import "UIColor+ZHNGetHSB.h"

CGFloat const KIndicatorRadius = 20;
@interface ZHNColorSaturationBrightnessPickerView()
@property (nonatomic,strong) ZHNBrightnessView *brightnessView;
@property (nonatomic,strong) ZHNSaturationView *colorSaturationView;
@property (nonatomic,strong) ZHNSAPickerIndicator *indicator;
@property (nonatomic,strong) UIBezierPath *cyclePath;
@property (nonatomic,assign) BOOL isLayouted;
@end

@implementation ZHNColorSaturationBrightnessPickerView
#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isLayouted) {return;}
    self.isLayouted = YES;
    NSAssert(self.frame.size.width == self.frame.size.height, @"widht need equal to height");
    // saturation
    [self addSubview:self.colorSaturationView];
    self.colorSaturationView.frame = self.bounds;
    self.colorSaturationView.sbColor = self.pickerTintColor;
    // brightness
    [self addSubview:self.brightnessView];
    self.brightnessView.frame = self.bounds;
    // cycle
    self.cyclePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    // indicator
    [self addSubview:self.indicator];
    self.indicator.bounds = CGRectMake(0, 0, KIndicatorRadius, KIndicatorRadius);
    [self p_intitalIndicatiorStatus];
}

#pragma mark - public methods
- (void)updatePickerColor:(UIColor *)pickerColor {
    self.colorSaturationView.sbColor = pickerColor;
    self.pickerTintColor = pickerColor;
    [self.colorSaturationView updateSbColor:pickerColor];
}

- (void)reloadPickerWithPickerColor:(UIColor *)pickerColor colorHSB:(HSBType)colrHSB {
    [self updatePickerColor:pickerColor];
    self.colorHSB = colrHSB;
    [self p_intitalIndicatiorStatus];
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.indicator zhn_indicatorTouchBeginWithTouch:touch limitCyclePath:self.cyclePath];
    [self p_extractColorWithTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.indicator zhn_indicatorTouchMovedWithTouch:touch limitCyclePath:self.cyclePath];
    [self p_extractColorWithTouch:touch];
    [self.delegate zhn_saturationBrightnessPickerDragingColor:self.indicator.backgroundColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.indicator zhn_indicatorTouchEndWithTouch:touch limitCyclePath:self.cyclePath];
    [self.delegate zhn_saturationBrightnessPickerSelectedColor:self.indicator.backgroundColor];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.indicator zhn_indicatorTouchEndWithTouch:touch limitCyclePath:self.cyclePath];
    [self.delegate zhn_saturationBrightnessPickerSelectedColor:self.indicator.backgroundColor];
}

#pragma mark - pravite mehtods
- (void)p_extractColorWithTouch:(UITouch *)touch {
    // get correct point
    CGPoint point = [touch locationInView:self];
    [self p_setIndicotarColorWithPoint:point];
}

- (void) p_setIndicotarColorWithPoint:(CGPoint)point {
    point = [self.indicator fitPointWithOldPoint:point limitCyclePath:self.cyclePath];
    CGFloat angle = [self p_angleForPoint:point];
    CGFloat anglePercent;
    if (angle > 0) {
        anglePercent = 1 - angle/360;
    }else {
        anglePercent = 1 - (angle + 360) / 360;
    }
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat distance = sqrt(pow(centerPoint.x - point.x, 2) + pow(centerPoint.y - point.y, 2));
    CGFloat distancePercent = distance / (self.frame.size.width/2);
    self.indicator.indicatorColor = [UIColor colorWithHue:self.pickerTintColor.HSB.hue saturation:anglePercent brightness:distancePercent alpha:1];
}

- (CGFloat)p_angleForPoint:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGPoint horizonPoint = CGPointMake(self.frame.size.width, self.frame.size.height/2);
    CGFloat a = point.x - centerPoint.x;
    CGFloat b = point.y - centerPoint.y;
    CGFloat c = horizonPoint.x - centerPoint.x;
    CGFloat d = horizonPoint.y - centerPoint.y;
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    if (point.y > horizonPoint.y) {
        rads = -rads;
    }
    rads =  180 * rads / M_PI;
    return rads;
}

- (void)p_intitalIndicatiorStatus {
    // const
    CGFloat anglePercent = self.colorHSB.saturation;
    CGFloat distancePercent = self.colorHSB.brightness;
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    // delta
    CGFloat distance = self.frame.size.width / 2 * distancePercent;
    CGFloat angle = anglePercent * M_PI * 2;
    CGFloat yDelta = distance * sin(angle);
    CGFloat xDelta = distance * cos(angle);
    // point
    CGFloat x = centerPoint.x + xDelta;
    CGFloat y = centerPoint.y + yDelta;
    self.indicator.center = CGPointMake(x, y);
    [self p_setIndicotarColorWithPoint:self.indicator.center];
}

#pragma mark - setters
- (void)setPickerTintColor:(UIColor *)pickerTintColor {
    _pickerTintColor = pickerTintColor;
    [self p_setIndicotarColorWithPoint:self.indicator.center];
}


#pragma mark - getters
- (UIColor *)selectColor {
    return self.indicator.indicatorColor;
}

- (ZHNSAPickerIndicator *)indicator {
    if (_indicator == nil) {
        _indicator = [[ZHNSAPickerIndicator alloc]init];
    }
    return _indicator;
}

- (CGFloat)indicatorRadius {
    return KIndicatorRadius;
}

- (ZHNSaturationView *)colorSaturationView {
    if (_colorSaturationView == nil) {
        _colorSaturationView =[[ZHNSaturationView alloc]init];
    }
    return _colorSaturationView;
}

- (ZHNBrightnessView *)brightnessView {
    if (_brightnessView == nil) {
        _brightnessView = [[ZHNBrightnessView alloc]init];
    }
    return _brightnessView;
}
@end

/////////////////////////////////////////////////////
static const CGFloat yDelta = 20;
static const CGFloat xDelta = 20;
static const CGFloat KindicatorAnimateDuration = 0.2;
static const CGFloat KindicatorTouchingScale = 4;
@interface ZHNSAPickerIndicator()
@property (nonatomic,strong) UIImageView *indicatorView;
@end

@implementation ZHNSAPickerIndicator
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width/2;
    [self addSubview:self.indicatorView];
    self.indicatorView.frame = self.bounds;
    self.indicatorView.layer.cornerRadius = self.frame.size.width/2;
    self.indicatorView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.indicatorView.layer.borderWidth = 1;
}

- (void)zhn_indicatorTouchBeginWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path {
    CGPoint touchPoint = [touch locationInView:self.superview];
    if ([path containsPoint:touchPoint]) {
        self.center = [self p_normalNewCenter:touchPoint];
        [UIView animateWithDuration:KindicatorAnimateDuration animations:^{
            self.transform = CGAffineTransformMakeScale(KindicatorTouchingScale, KindicatorTouchingScale);
        }];
    }
}

- (void)zhn_indicatorTouchMovedWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path {
    CGPoint touchPoint = [touch locationInView:self.superview];
    if ([path containsPoint:touchPoint]) {
        self.center = [self p_normalNewCenter:touchPoint];
    }else {
        self.center = [self p_normalNewCenter:[self p_outSidePathCenter:touchPoint]];
    }
}

- (void)zhn_indicatorTouchEndWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path{
    CGPoint endPoint = [touch locationInView:self.superview];
    if (isnan(endPoint.x) || isnan(endPoint.y)) {return;}
    if ([path containsPoint:endPoint]) {
        [UIView animateWithDuration:KindicatorAnimateDuration animations:^{
            self.center = endPoint;
            self.transform = CGAffineTransformIdentity;
        }];
    }else {
        [UIView animateWithDuration:KindicatorAnimateDuration animations:^{
            self.center = [self p_outSidePathCenter:endPoint];
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (CGPoint)fitPointWithOldPoint:(CGPoint)oldPoint limitCyclePath:(UIBezierPath *)path {
    if ([path containsPoint:oldPoint]) {
        return oldPoint;
    }else {
        return [self p_outSidePathCenter:oldPoint];
    }
}

#pragma mark - pravite mehtods
- (CGPoint)p_normalNewCenter:(CGPoint)oldCenter {
    CGPoint newPoint = CGPointMake(oldCenter.x + xDelta, oldCenter.y - yDelta);
    return newPoint;
}

- (CGPoint)p_outSidePathCenter:(CGPoint)oldCenter {
    CGFloat radius = self.superview.bounds.size.width / 2;
    CGPoint center = CGPointMake(radius, radius);
    CGFloat distance = sqrt(pow(center.x - oldCenter.x, 2) + pow(oldCenter.y - center.y, 2));
    CGFloat x = center.x - radius / distance * (center.x - oldCenter.x);
    CGFloat y = center.y + radius / distance * (oldCenter.y - center.y);
    oldCenter = CGPointMake(x, y);
    return oldCenter;
}

#pragma mark - setters
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

#pragma mark - getters
- (UIImageView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIImageView alloc]init];
    }
    return _indicatorView;
}
@end

///////////////////////////////////////////////////// 控制色彩
typedef void (^voidBlock)(void);
typedef float (^floatfloatBlock)(float);
typedef UIColor * (^floatColorBlock)(float);
@interface ZHNSaturationView()
@property (nonatomic,strong) CALayer *colorLayer;
@property (nonatomic,strong) dispatch_queue_t drawQueue;
@property (nonatomic,strong) dispatch_block_t drawBlockt;
@end

@implementation ZHNSaturationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.colorLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.colorLayer.frame = self.bounds;
    [self p_drawColorContent];
}

#pragma mark - public methods
- (void)updateSbColor:(UIColor *)color {
    self.sbColor = color;
   [self p_drawColorContent];
}

#pragma mark - pravite methods
- (void)p_drawColorContent {
    if (self.drawBlockt) {
        dispatch_block_cancel(self.drawBlockt);
    }
    
    CGFloat radius = self.frame.size.width/2;
    CGFloat h ,s ,b;
    h = self.sbColor.HSB.hue;
    s = self.sbColor.HSB.saturation;
    b = self.sbColor.HSB.brightness;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = self.bounds.size;
    
    dispatch_block_t drawContentBlockt = dispatch_block_create(0, ^{
        // draw gradient
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        [self drawGradientInContext:UIGraphicsGetCurrentContext() startingAngle:0 endingAngle:M_PI * 2 intRadius:^float(float f) {
            return 0;
        } outRadius:^float(float r) {
            return radius;
        } withGradientBlock:^UIColor *(float f) {
            return [UIColor colorWithHue:h saturation:f brightness:b alpha:f];
        } withSubdiv:360 withCenter:CGPointMake(radius, radius) withScale:1];
        // get image
        UIImage *graImage = UIGraphicsGetImageFromCurrentImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.colorLayer.contents = nil;
            self.colorLayer.contents = (__bridge id _Nullable)(graImage.CGImage);
        });
        UIGraphicsEndImageContext();
    });
    self.drawBlockt = drawContentBlockt;
    dispatch_async(self.drawQueue, self.drawBlockt);
}

// this method reference from https://stackoverflow.com/questions/11783114/draw-outer-half-circle-with-gradient-using-core-graphics-in-ios
- (CGPoint)pointForTrapezoidWithAngle:(float)a andRadius:(float)r  forCenter:(CGPoint)p{
    return CGPointMake(p.x + r*cos(a), p.y + r*sin(a));
}

- (void)drawGradientInContext:(CGContextRef)ctx  startingAngle:(float)a endingAngle:(float)b intRadius:(floatfloatBlock)intRadiusBlock outRadius:(floatfloatBlock)outRadiusBlock withGradientBlock:(floatColorBlock)colorBlock withSubdiv:(int)subdivCount withCenter:(CGPoint)center withScale:(float)scale
{
    float angleDelta = (b-a)/subdivCount;
    float fractionDelta = 1.0/subdivCount;
    
    CGPoint p0,p1,p2,p3, p4,p5;
    float currentAngle=a;
    p4=p0 = [self pointForTrapezoidWithAngle:currentAngle andRadius:intRadiusBlock(0) forCenter:center];
    p5=p3 = [self pointForTrapezoidWithAngle:currentAngle andRadius:outRadiusBlock(0) forCenter:center];
    CGMutablePathRef innerEnveloppe=CGPathCreateMutable(),
    outerEnveloppe=CGPathCreateMutable();
    
    CGPathMoveToPoint(outerEnveloppe, 0, p3.x, p3.y);
    CGPathMoveToPoint(innerEnveloppe, 0, p0.x, p0.y);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1);
    
    for (int i=0;i<subdivCount;i++)
    {
        float fraction = (float)i/subdivCount;
        currentAngle=a+fraction*(b-a);
        CGMutablePathRef trapezoid = CGPathCreateMutable();
        
        p1 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:intRadiusBlock(fraction+fractionDelta) forCenter:center];
        p2 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:outRadiusBlock(fraction+fractionDelta) forCenter:center];
        
        CGPathMoveToPoint(trapezoid, 0, p0.x, p0.y);
        CGPathAddLineToPoint(trapezoid, 0, p1.x, p1.y);
        CGPathAddLineToPoint(trapezoid, 0, p2.x, p2.y);
        CGPathAddLineToPoint(trapezoid, 0, p3.x, p3.y);
        CGPathCloseSubpath(trapezoid);
        
        CGPoint centerofTrapezoid = CGPointMake((p0.x+p1.x+p2.x+p3.x)/4, (p0.y+p1.y+p2.y+p3.y)/4);
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(-centerofTrapezoid.x, -centerofTrapezoid.y);
        CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
        CGAffineTransform concat = CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformInvert(t)));
        CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(trapezoid, &concat);
        
        CGContextAddPath(ctx, scaledPath);
        CGContextSetFillColorWithColor(ctx,colorBlock(fraction).CGColor);
        CGContextSetStrokeColorWithColor(ctx, colorBlock(fraction).CGColor);
        CGContextSetMiterLimit(ctx, 0);
        
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGPathRelease(trapezoid);
        p0=p1;
        p3=p2;
        
        CGPathAddLineToPoint(outerEnveloppe, 0, p3.x, p3.y);
        CGPathAddLineToPoint(innerEnveloppe, 0, p0.x, p0.y);
    }
    CGContextSetLineWidth(ctx, 0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddPath(ctx, outerEnveloppe);
    CGContextAddPath(ctx, innerEnveloppe);
    CGContextMoveToPoint(ctx, p0.x, p0.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextMoveToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextStrokePath(ctx);
}

#pragma mark - getters
- (CALayer *)colorLayer {
    if (_colorLayer == nil) {
        _colorLayer = [CALayer layer];
        _colorLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _colorLayer;
}

- (dispatch_queue_t)drawQueue {
    if (_drawQueue == nil) {
        _drawQueue = dispatch_queue_create("color.picker.draw.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _drawQueue;
}
@end

/////////////////////////////////////////////////////
@interface ZHNBrightnessView()
@property (nonatomic,strong) CALayer *brightnessLayer;
@end

@implementation ZHNBrightnessView
#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
    [self.layer addSublayer:self.brightnessLayer];
    self.brightnessLayer.frame = self.bounds;
    [self p_drawColorContent];
}

#pragma mark - pravite methods
- (void)p_drawColorContent {
    // draw gradient
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        0, 0, 0, 1.00,//start color(r,g,b,alpha)
        0, 0, 0, 0.00,//end color
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, 2);
    CGFloat radius = self.frame.size.width/2;
    CGPoint start = CGPointMake(radius , radius);
    CGPoint end = start;
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = radius;
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);
    // get image
    UIImage *graImage = UIGraphicsGetImageFromCurrentImageContext();
    self.brightnessLayer.contents = (__bridge id _Nullable)(graImage.CGImage);
    //releas
    CGGradientRelease(gradient);
    gradient=NULL;
    CGColorSpaceRelease(rgb);
    UIGraphicsEndImageContext();
}

#pragma mark - getters
- (CALayer *)brightnessLayer {
    if (_brightnessLayer == nil) {
        _brightnessLayer = [CALayer layer];
    }
    return _brightnessLayer;
}
@end
