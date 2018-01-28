//
//  UIView+ZHNframeLayout.m
//  ZHNframeLayout
//
//  Created by zhn on 16/4/22.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIView+ZHNframeLayout.h"
#import "ZHNframeLayoutMaker.h"

@implementation UIView (ZHNframeLayout)


- (CGFloat)zhn_left{
    return self.frame.origin.x;
}
- (CGFloat)zhn_right{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)zhn_top{
    return self.frame.origin.y;
}
- (CGFloat)zhn_bottom{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)zhn_centerX{
    return self.center.x;
}
- (CGFloat)zhn_centerY{
    return self.center.y;
}
- (CGPoint)zhn_center{
    return self.center;
}
- (CGFloat)zhn_weight{
    return self.frame.size.width;
}
- (CGFloat)zhn_height{
    return self.frame.size.height;
}
- (CGFloat)zhn_superLeft{
    return self.bounds.origin.x;
}
- (CGFloat)zhn_superRight{
    return self.bounds.size.width;
}
- (CGFloat)zhn_superTop{
    return self.bounds.origin.y;
}
- (CGFloat)zhn_superBottom{
    return self.bounds.size.height;
}

- (void)ZHN_makeFrame:(void (^)(ZHNframeLayoutMaker * maker))block{
    
    ZHNframeLayoutMaker * maker = [[ZHNframeLayoutMaker alloc]initWithSupView:self];
    block(maker);
    self.frame = [maker getViewFrame];
}

@end
