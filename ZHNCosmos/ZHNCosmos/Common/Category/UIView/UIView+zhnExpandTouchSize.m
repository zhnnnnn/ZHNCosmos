//
//  UIView+zhnExpandTouchSize.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/9.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UIView+zhnExpandTouchSize.h"
#import <objc/runtime.h>

void expandTouch_swizzingMethod(Class class,SEL orig,SEL new){
    Method origMethod = class_getInstanceMethod(class, orig);
    Method newMethod = class_getInstanceMethod(class, new);
    if (class_addMethod(class, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
}
@implementation UIView (zhnExpandTouchSize)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expandTouch_swizzingMethod([self class], @selector(pointInside:withEvent:), @selector(zhn_expandTouchPointInside:withEvent:));
    });
}

- (BOOL)zhn_expandTouchPointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.zhn_expandTouchInset, UIEdgeInsetsZero)||self.hidden||([self isKindOfClass:[UIControl class]] && !((UIControl *)self).enabled)) {
        [self zhn_expandTouchPointInside:point withEvent:event];
    }
    CGRect hitRect = UIEdgeInsetsInsetRect(self.bounds, self.zhn_expandTouchInset);
    hitRect.size.width  = MAX(hitRect.size.width, 0);
    hitRect.size.height = MAX(hitRect.size.height, 0);
    return CGRectContainsPoint(hitRect, point);
}

- (void)setZhn_expandTouchInset:(UIEdgeInsets)zhn_expandTouchInset {
    objc_setAssociatedObject(self, @selector(zhn_expandTouchInset), [NSValue valueWithUIEdgeInsets:zhn_expandTouchInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)zhn_expandTouchInset {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}
@end
