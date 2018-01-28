//
//  UIView+ZHNAdd.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIView+ZHNAdd.h"

@implementation UIView (ZHNAdd)
- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}
- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

@end
