//
//  RSColorPickerState.m
//  RSColorPicker
//
//  Created by Alex Nichol on 12/16/13.
//

#import "RSColorPickerState.h"

static CGFloat _calculateHue(CGPoint point);
static CGFloat _calculateSaturation(CGPoint point);
static CGPoint _calculatePoint(CGFloat hue, CGFloat saturation);

@implementation RSColorPickerState

@synthesize brightness, alpha;

- (CGFloat)hue {
    return _calculateHue(scaledRelativePoint);
}

- (CGFloat)saturation {
    return _calculateSaturation(scaledRelativePoint);
}

- (UIColor *)color {
    return [UIColor colorWithHue:self.hue saturation:self.saturation brightness:brightness alpha:alpha];
}

+ (RSColorPickerState *)stateForPoint:(CGPoint)point size:(CGFloat)size padding:(CGFloat)padding {
    // calculate everything we need to know
    CGPoint relativePoint = CGPointMake(point.x - (size / 2.0), (size / 2.0) - point.y);
    CGPoint scaledRelativePoint = relativePoint;
    scaledRelativePoint.x /= (size / 2.0) - padding;
    scaledRelativePoint.y /= (size / 2.0) - padding;
    return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint
                                                        brightness:1 alpha:1];
}

- (id)initWithColor:(UIColor *)_selectionColor {
    if ((self = [super init])) {
        CGFloat rgba[4];
        RSGetComponentsForColor(rgba, _selectionColor);
        UIColor * selectionColor = [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
        CGFloat hue, saturation;
        [selectionColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        scaledRelativePoint = _calculatePoint(hue, saturation);
    }
    return self;
}

- (id)initWithScaledRelativePoint:(CGPoint)p brightness:(CGFloat)V alpha:(CGFloat)A {
    if ((self = [super init])) {
        scaledRelativePoint = p;
        brightness = V;
        alpha = A;
    }
    return self;
}

- (id)initWithHue:(CGFloat)H saturation:(CGFloat)S brightness:(CGFloat)V alpha:(CGFloat)A {
    if ((self = [super init])) {
        scaledRelativePoint = _calculatePoint(H, S);
        brightness = V;
        alpha = A;
    }
    return self;
}

- (CGPoint)selectionLocationWithSize:(CGFloat)size padding:(CGFloat)padding {
    CGPoint unscaled = scaledRelativePoint;
    unscaled.x *= (size / 2.0) - padding;
    unscaled.y *= (size / 2.0) - padding;
    return CGPointMake(unscaled.x + (size / 2.0), (size / 2.0) - unscaled.y);
}

#pragma mark - Modification

- (RSColorPickerState *)stateBySettingBrightness:(CGFloat)newBright {
    return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint brightness:newBright alpha:alpha];
}

- (RSColorPickerState *)stateBySettingAlpha:(CGFloat)newAlpha {
    return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint brightness:brightness alpha:newAlpha];
}

- (RSColorPickerState *)stateBySettingHue:(CGFloat)newHue {
    CGPoint newPoint = _calculatePoint(newHue, self.saturation);
    return [[RSColorPickerState alloc] initWithScaledRelativePoint:newPoint brightness:brightness alpha:alpha];
}

- (RSColorPickerState *)stateBySettingSaturation:(CGFloat)newSaturation {
    CGPoint newPoint = _calculatePoint(self.hue, newSaturation);
    return [[RSColorPickerState alloc] initWithScaledRelativePoint:newPoint brightness:brightness alpha:alpha];
}

#pragma mark - Debugging

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p { ", NSStringFromClass([self class]), self];

    [description appendFormat:@"scaledPoint:%@ ", NSStringFromCGPoint(scaledRelativePoint)];
    [description appendFormat:@"brightness:%f ", brightness];
    [description appendFormat:@"alpha:%f", alpha];

    [description appendString:@"} >"];
    return description;
}

@end

#pragma mark - Helper Functions

static CGFloat _calculateHue(CGPoint point) {
    double angle = atan2(point.y, point.x);
    if (angle < 0) angle += M_PI * 2;
    return angle / (M_PI * 2);
}

static CGFloat _calculateSaturation(CGPoint point) {
    CGFloat radius = sqrt(pow(point.x, 2) + pow(point.y, 2));
    if (radius > 1) {
        radius = 1;
    }
    return radius;
}

static CGPoint _calculatePoint(CGFloat hue, CGFloat saturation) {
    // convert to HSV
    CGFloat angle = hue * (2.0 * M_PI);
    CGFloat pointX = cos(angle) * saturation;
    CGFloat pointY = sin(angle) * saturation;
    return CGPointMake(pointX, pointY);
}
