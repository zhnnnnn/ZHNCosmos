//
//  UIColor+ZHNGetHSB.h
//  ZHNColorPicker
//
//  Created by zhn on 2017/10/12.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef struct {
    float hue;
    float saturation;
    float brightness;
} HSBType;

@interface UIColor (ZHNGetHSB)
/**
 uicolor hsb value

 @return hsb value
 */
- (HSBType)HSB;
@end
