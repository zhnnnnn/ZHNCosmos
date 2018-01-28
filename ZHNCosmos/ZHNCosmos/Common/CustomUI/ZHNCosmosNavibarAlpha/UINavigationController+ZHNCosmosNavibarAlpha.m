//
//  UINavigationController+ZHNCosmosNavibarAlpha.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UINavigationController+ZHNCosmosNavibarAlpha.h"
#import "UIViewController+ZHNCosmosNavibarAlpha.h"
#import "ZHNMethodSwizzingHelper.h"
#import "ZHNCosmosNavibar.h"

@implementation UINavigationController (ZHNCosmosNavibarAlpha)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ZHNMethodSwizzingHelper swizzinClass:[self class] OriginalSEL:@selector(viewDidLoad) TonewSEL:@selector(zhnNavibar_viewDidLoad)];
    });
}

- (void)zhnNavibar_viewDidLoad {
    [self zhnNavibar_viewDidLoad];
    [self setValue:[[ZHNCosmosNavibar alloc]init] forKey:@"navigationBar"];
}

- (void)setZhn_navibarAlpha:(CGFloat)zhn_navibarAlpha {
    [super setZhn_navibarAlpha:zhn_navibarAlpha];
    if (self.zhn_barItemFlollowAlpha) {
        [(ZHNCosmosNavibar *)self.navigationBar setCanAlphaBeSet:YES];
        self.navigationBar.alpha = zhn_navibarAlpha;
        [(ZHNCosmosNavibar *)self.navigationBar setCanAlphaBeSet:NO];
    }else {
        [self p_baritemNotFollowAlpha:zhn_navibarAlpha];
    }
}

- (void)setZhn_barItemFlollowAlpha:(BOOL)zhn_barItemFlollowAlpha {
    objc_setAssociatedObject(self, @selector(zhn_barItemFlollowAlpha), @(zhn_barItemFlollowAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhn_barItemFlollowAlpha {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)p_baritemNotFollowAlpha:(CGFloat)alpha {
    UIView *backGroundView = [self.navigationBar.subviews firstObject];
    UIView *backgroundEffectView = [backGroundView valueForKey:@"_backgroundEffectView"];
    UIView *shadowView = [backGroundView valueForKey:@"_shadowView"];
    backgroundEffectView.alpha = alpha;
    shadowView.alpha = alpha;
    // Browser bug fix.
    UIView *bottomLine = [backGroundView.subviews firstObject];
    if (alpha == 0) {
        bottomLine.hidden = YES;
    }else {
        bottomLine.alpha = alpha;
        bottomLine.hidden = NO;
    }
}
@end
