//
//  ZHNRibbonLabel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRibbonLabel.h"

@implementation ZHNRibbonLabel
- (void)intitallizeRibbonWithSuperViewFrame:(CGRect)superFrame rabbionHeight:(CGFloat)height rabbionCornerPadding:(CGFloat)padding {
    CGFloat centerx = superFrame.size.width - padding;
    CGFloat centery = padding;
    CGFloat centerOffset = sqrt((pow(height/2, 2)/2));
    centerx = centerx + centerOffset;
    centery = centery - centerOffset;
    CGFloat width = sqrt((pow((padding * 2), 2) * 2));
    self.center = CGPointMake(centerx, centery);
    self.bounds = CGRectMake(0, 0, width, height);
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.transform = CGAffineTransformMakeRotation(M_PI/4);
}
@end
