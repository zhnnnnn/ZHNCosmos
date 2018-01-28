//
//  UIViewController+ZHNCosmosNavibarAlpha.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIViewController+ZHNCosmosNavibarAlpha.h"
#import <objc/runtime.h>
#import "UINavigationController+ZHNCosmosNavibarAlpha.h"

@implementation UIViewController (ZHNCosmosNavibarAlpha)
- (void)setZhn_navibarAlpha:(CGFloat)zhn_navibarAlpha {
    if (zhn_navibarAlpha > 1) {
        zhn_navibarAlpha = 1;
    }
    if (zhn_navibarAlpha < 0) {
        zhn_navibarAlpha = 0;
    }
    self.navigationController.zhn_navibarAlpha = zhn_navibarAlpha;
    objc_setAssociatedObject(self, @selector(zhn_navibarAlpha), @(zhn_navibarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zhn_navibarAlpha {
    id navibarAlpha = objc_getAssociatedObject(self, _cmd);
    if (navibarAlpha == nil) {
        return 1;
    }else {
        return [navibarAlpha floatValue];
    }
}
@end

/////////////////////////////////////////////////////
@implementation ZHNNavibarAlphaDeallocer
+ (instancetype)zhn_deallocerWithHandle:(ZHNNavibarAlphaDeallocHandle)handle {
    ZHNNavibarAlphaDeallocer *deallocer = [[ZHNNavibarAlphaDeallocer alloc]init];
    deallocer.handle = handle;
    return deallocer;
}

- (void)dealloc {
    if (self.handle) {
        self.handle();
    }
}
@end
