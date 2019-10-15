//
//  NSObject+ZHNCosmosTheme.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSObject+ZHNCosmosTheme.h"
CGFloat const KZHNColorThemeChangeDuration = 0.3;
@implementation NSObject (ZHNCosmosTheme)
//-------------------------- night version --------------------------
- (ZHNCosmosNightVersionHandle)extraNightVersionChangeHandle {
    return objc_getAssociatedObject(self, @selector(extraNightVersionChangeHandle));
}

- (void)setExtraNightVersionChangeHandle:(ZHNCosmosNightVersionHandle)extraNightVersionChangeHandle {
    if (extraNightVersionChangeHandle) {
        extraNightVersionChangeHandle();
    };
    objc_setAssociatedObject(self, @selector(extraNightVersionChangeHandle), extraNightVersionChangeHandle, OBJC_ASSOCIATION_COPY);
    // add observer
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DKNightVersionThemeChangingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhn_themeChangeExtraHandle) name:DKNightVersionThemeChangingNotification object:nil];
    // auto remove observer
    if (objc_getAssociatedObject(self, @"nightVersionDeallocer")) {return;}
    COSWEAKSELF
    ZHNThemeDeallocer *deallocer = [ZHNThemeDeallocer deallocerWithBlcok:^{
        [[NSNotificationCenter defaultCenter]removeObserver:weakSelf name:DKNightVersionThemeChangingNotification object:nil];
    }];
    objc_setAssociatedObject(self, @"nightVersionDeallocer", deallocer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zhn_themeChangeExtraHandle {
    if (self.extraNightVersionChangeHandle) {
        self.extraNightVersionChangeHandle();
    }
}

//-------------------------- theme color --------------------------
- (void)setIsCustomThemeColor:(BOOL)isCustomThemeColor {
    if (!isCustomThemeColor) {return;}
    // set backgroundcolor
    if ([self respondsToSelector:@selector(setBackgroundColor:)]) {
        [self performSelector:@selector(setBackgroundColor:) withObject:[ZHNThemeManager zhn_getThemeColor]];
    }
    // add property
    objc_setAssociatedObject(self, @selector(isCustomThemeColor), @(isCustomThemeColor), OBJC_ASSOCIATION_ASSIGN);
    // add observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZHNCosmosThemeColorChangingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhn_normalColorThemeChangeHandle) name:ZHNCosmosThemeColorChangingNotification object:nil];
    // auto remove observer
    if (objc_getAssociatedObject(self, @"zhnColorThemeDeallocer")) {return;}
    __unsafe_unretained typeof(self) weakSelf = self;
    ZHNThemeDeallocer *deallocer = [ZHNThemeDeallocer deallocerWithBlcok:^{
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:ZHNCosmosThemeColorChangingNotification object:nil];
    }];
    objc_setAssociatedObject(self, @"zhnColorThemeDeallocer", deallocer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCustomThemeColor {
    return objc_getAssociatedObject(self, @selector(isCustomThemeColor));
}

- (void)zhn_normalColorThemeChangeHandle{
    [UIView animateWithDuration:KZHNColorThemeChangeDuration animations:^{
        // normal set color
        if ([self respondsToSelector:@selector(setBackgroundColor:)]) {
            [self performSelector:@selector(setBackgroundColor:) withObject:[ZHNThemeManager zhn_getThemeColor]];
        }
    }];
}

//-------------------------- extra theme color change --------------------------
- (void)setExtraThemeColorChangeHandle:(ZHNCosmosThemeColorHandle)extraThemeColorChangeHandle {
    if (extraThemeColorChangeHandle) {
        extraThemeColorChangeHandle();
    }
    objc_setAssociatedObject(self, @selector(extraThemeColorChangeHandle), extraThemeColorChangeHandle, OBJC_ASSOCIATION_COPY);
    // add observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZHNCosmosThemeColorChangingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhn_extraThemeColorChange) name:ZHNCosmosThemeColorChangingNotification object:nil];
    // auto remove observer
    if (objc_getAssociatedObject(self, @"zhnExtraColorThemeDeallocer")) {return;}
    __unsafe_unretained typeof(self) weakSelf = self;
    ZHNThemeDeallocer *deallocer = [ZHNThemeDeallocer deallocerWithBlcok:^{
        [[NSNotificationCenter defaultCenter]removeObserver:weakSelf name:ZHNCosmosThemeColorChangingNotification object:nil];
    }];
    objc_setAssociatedObject(self, @"zhnExtraColorThemeDeallocer", deallocer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHNCosmosThemeColorHandle)extraThemeColorChangeHandle {
    return objc_getAssociatedObject(self, @selector(extraThemeColorChangeHandle));
}

- (void)zhn_extraThemeColorChange {
    [UIView animateWithDuration:KZHNColorThemeChangeDuration animations:^{
        // extra do some change
        if (self.extraThemeColorChangeHandle) {
            self.extraThemeColorChangeHandle();
        }
    }];
}
@end

////////////////////////////////////////////////////////
@implementation ZHNThemeDeallocer
- (void)dealloc {
    if (self.deallocAction) {
        self.deallocAction();
    }
}

+ (ZHNThemeDeallocer *)deallocerWithBlcok:(ZHNThemeDeallocerBlock)block {
    ZHNThemeDeallocer *deallocer = [[ZHNThemeDeallocer alloc]init];
    deallocer.deallocAction = block;
    return deallocer;
}

@end
