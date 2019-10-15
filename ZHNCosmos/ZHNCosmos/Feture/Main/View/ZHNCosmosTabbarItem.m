//
//  ZHNCosmosTabbarItem.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosTabbarItem.h"
#import "ZHNShineButton.h"

@interface ZHNCosmosTabbarItem()
@property (nonatomic,strong) ZHNShineButton *button;
@property (nonatomic,strong) UIView *badgeIdot;
@end

@implementation ZHNCosmosTabbarItem
- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.button];
    [self addSubview:self.badgeIdot];
    self.button.center = CGPointMake(self.width/2, self.height/2);
    self.button.bounds = CGRectMake(0, 0, 35, 35);
    // reload theme color
    COSWEAKSELF
    self.extraThemeColorChangeHandle = ^{
        [weakSelf.button reloadStateWithNormalImage:weakSelf.normalImage
                                    hightlightImage:[weakSelf.normalImage imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]]
                                          tintColor:[ZHNThemeManager zhn_getThemeColor]];
    };
}

#pragma mark - public methods
- (void)deselect {
    [self.button clearHightLight];
}

- (void)select {
    [self.button animateHightLight];
}

- (void)noAnimateSelect {
    self.button.isNeedDealingActions = NO;
    [self.button noAnimationHgihtLight];
    self.button.isNeedDealingActions = YES;
}

#pragma mark - setters
- (void)setIsNeedDealAction:(BOOL)isNeedDealAction {
    _isNeedDealAction = isNeedDealAction;
    self.button.isNeedDealingActions = isNeedDealAction;
}

#pragma mark - getters
- (UIView *)badgeIdot {
    if (_badgeIdot == nil) {
        _badgeIdot = [[UIView alloc]init];
        _badgeIdot.backgroundColor = [UIColor greenColor];
    }
    return _badgeIdot;
}

- (ZHNShineButton *)button {
    if (_button == nil) {
        @weakify(self);
        _button = [ZHNShineButton
                   zhn_shineButtonWithTintColor:[ZHNThemeManager zhn_getThemeColor]
                   normalImage:self.normalImage
                   hightLightImage:[self.normalImage imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]]
                   normalTypeTapAction:^{
                       @strongify(self);
                       if (self.selectAction) {
                           self.selectAction();
                       }
                   } hightLightTypeTapAction:^{
                       @strongify(self);
                       if (self.reloadAction) {
                           self.reloadAction();
                       }
                   }];
    }
    return _button;
}
@end
