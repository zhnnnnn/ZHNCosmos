//
//  UIView+ZHNJellyMagicSwitch.m
//  zhnSegmentSwitch
//
//  Created by zhn on 2017/12/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIView+ZHNJellyMagicSwitch.h"

@implementation UIView (ZHNJellyMagicSwitch)
- (CGFloat)zhn_jmsX {
    return self.frame.origin.x;
}

- (CGFloat)zhn_jmsY {
    return self.frame.origin.y;
}

- (CGFloat)zhn_jmsWidth {
    return self.frame.size.width;
}

- (CGFloat)zhn_jmsHeight {
    return self.frame.size.height;
}

- (void)setZhn_jmsX:(CGFloat)zhn_jmsX {
    self.frame = CGRectMake(zhn_jmsX, self.zhn_jmsY, self.zhn_jmsWidth, self.zhn_jmsHeight);
}

- (void)setZhn_jmsY:(CGFloat)zhn_jmsY {
    self.frame = CGRectMake(self.zhn_jmsX, zhn_jmsY, self.zhn_jmsWidth, self.zhn_jmsHeight);
}

- (void)setZhn_jmsWidth:(CGFloat)zhn_jmsWidth {
    self.frame = CGRectMake(self.zhn_jmsX, self.zhn_jmsY, zhn_jmsWidth, self.zhn_jmsHeight);
}

- (void)setZhn_jmsHeight:(CGFloat)zhn_jmsHeight {
  self.frame = CGRectMake(self.zhn_jmsX, self.zhn_jmsY, self.zhn_jmsWidth, zhn_jmsHeight);
}
@end

