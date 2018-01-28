//
//  UIColor+highlight.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIColor+highlight.h"

@implementation UIColor (highlight)
- (UIColor *)zhn_lightTypeHighlightForPercent:(CGFloat)percent {
    CGFloat h,s,b,a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s - percent brightness:b alpha:a];
}

- (UIColor *)zhn_lightTypeHighlight {
    return [self zhn_lightTypeHighlightForPercent:0.4];
}

- (UIColor *)zhn_darkTypeHighlightForPercent:(CGFloat)percent {
    CGFloat h,s,b,a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b - percent alpha:a];
}

- (UIColor *)zhn_darkTypeHighlight {
    return [self zhn_darkTypeHighlightForPercent:0.2];
}


@end
