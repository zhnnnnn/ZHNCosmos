//
//  UIView+ZHNDoodleMenuBar.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UIView+ZHNDoodleMenuBar.h"
#import <objc/runtime.h>

@interface UIView()
@property (nonatomic,copy) ZHNDoodleMenuBarSelectItemHandle clickHandle;
@end

@implementation UIView (ZHNDoodleMenuBar)
- (void)zhn_showDoodleMenuBarWithMenuButtonItemArray:(NSArray<ZHNDoodleMenuButtonItem *> *)menuItemArray tintColor:(UIColor *)tintColor clickItemHandle:(ZHNDoodleMenuBarSelectItemHandle)handle{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint center = [self.superview convertPoint:self.center toView:window];
    ZHNDoodleMenuBar *bar = [ZHNDoodleMenuBar zhn_doodleMenuBarWithMenuButtonItemArray:menuItemArray];
    bar.tintColor = tintColor;
    bar.delegate = self;
    self.clickHandle = handle;
    [bar zhn_animateShowDoodleMenuBarWithAnchroPoint:center];
}

- (void)zhn_showDoodleMenuBarWithMenuButtonItemArray:(NSArray<ZHNDoodleMenuButtonItem *> *)menuItemArray clickItemHandle:(ZHNDoodleMenuBarSelectItemHandle)handle{
    [self zhn_showDoodleMenuBarWithMenuButtonItemArray:menuItemArray tintColor:[UIColor redColor] clickItemHandle:handle];
}

- (void)ZHNDoodleMenuBarClickIndex:(NSInteger)index barItemIsSelectAfter:(BOOL)select {
    if (self.clickHandle) {
        self.clickHandle(index, select);
    }
}

- (void)setClickHandle:(ZHNDoodleMenuBarSelectItemHandle)clickHandle {
    objc_setAssociatedObject(self, @selector(clickHandle), clickHandle, OBJC_ASSOCIATION_COPY);
}

- (ZHNDoodleMenuBarSelectItemHandle)clickHandle {
    return objc_getAssociatedObject(self, _cmd);
}
@end
