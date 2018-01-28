//
//  UIColor+highlight.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (highlight)
- (UIColor *)zhn_darkTypeHighlightForPercent:(CGFloat)percent;
- (UIColor *)zhn_lightTypeHighlightForPercent:(CGFloat)percent;
- (UIColor *)zhn_darkTypeHighlight;
- (UIColor *)zhn_lightTypeHighlight;
@end
