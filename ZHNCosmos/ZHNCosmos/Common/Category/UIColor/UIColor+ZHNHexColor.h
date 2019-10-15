//
//  UIColor+ZHNHexColor.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/15.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZHNHexColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
- (NSString *)hexString;
@end
