//
//  UIView+ZHNSnapchot.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UIView+ZHNSnapchot.h"

@implementation UIView (ZHNSnapchot)
- (UIImage *)zhn_viewSnapchot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)zhn_layerSnapchot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
