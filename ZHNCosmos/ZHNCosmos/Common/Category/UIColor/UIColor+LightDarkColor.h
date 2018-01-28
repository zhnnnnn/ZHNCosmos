//
//  UIColor+LightDarkColor.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LightDarkColor)
/**
 judge light color or dark color

 @return color type
 */
- (BOOL) isLightColor;
@end
