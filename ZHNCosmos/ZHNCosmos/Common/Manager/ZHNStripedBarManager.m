//
//  ZHNStripedBarManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStripedBarManager.h"
#import "M13ProgressViewStripedBar.h"

@interface ZHNStripedBarManager()
@property (nonatomic,strong) M13ProgressViewStripedBar *stripedBar;
@end

@implementation ZHNStripedBarManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNStripedBarManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNStripedBarManager alloc]init];
    });
    return manager;
}

+ (void)zhn_setProgress:(CGFloat)progress animate:(BOOL)animate {
#warning TODO iphonex fit
    ZHNStripedBarManager *manager = [self shareManager];
    [[UIApplication sharedApplication].keyWindow addSubview:manager.stripedBar];
    manager.stripedBar.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, 2);
    manager.stripedBar.animationDuration = 0.15;
    manager.stripedBar.stripeColor = [ZHNThemeManager zhn_getThemeColor];
    [manager.stripedBar setProgress:progress animated:animate];
}

+ (void)zhn_animateShowStripedBarToProgress:(CGFloat)progress {
    [self zhn_setProgress:progress animate:YES];
}

+ (void)zhn_animateFinish {
    [self zhn_setProgress:1 animate:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZHNStripedBarManager *manager = [self shareManager];
        [manager.stripedBar removeFromSuperview];
        manager.stripedBar = nil;
    });
}

- (M13ProgressViewStripedBar *)stripedBar {
    if (_stripedBar == nil) {
        _stripedBar = [[M13ProgressViewStripedBar alloc]init];
        _stripedBar.primaryColor = [UIColor whiteColor];
        _stripedBar.borderWidth = 0;
        _stripedBar.cornerType = M13ProgressViewStripedBarCornerTypeRounded;
    }
    return _stripedBar;
}

@end
