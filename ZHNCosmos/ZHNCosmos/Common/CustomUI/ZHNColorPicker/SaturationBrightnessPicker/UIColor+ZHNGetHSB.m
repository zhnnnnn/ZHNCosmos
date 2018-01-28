//
//  UIColor+ZHNGetHSB.m
//  ZHNColorPicker
//
//  Created by zhn on 2017/10/12.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIColor+ZHNGetHSB.h"

@implementation UIColor (ZHNGetHSB)
- (HSBType)HSB {
    HSBType hsb;
    hsb.hue = 0;
    hsb.saturation = 0;
    hsb.brightness = 0;
    CGFloat hue,saturation,brightness,alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    hsb.hue = hue;
    hsb.saturation = saturation;
    hsb.brightness = brightness;
    return hsb;
}
@end
