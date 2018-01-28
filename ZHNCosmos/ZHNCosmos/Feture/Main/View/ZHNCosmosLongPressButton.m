//
//  ZHNCosmosLongPressButton.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosLongPressButton.h"
#import "ZHNUniversalSettingMenu.h"

static const CGFloat KLongPressMinTime = 0.3;
@interface ZHNCosmosLongPressButton()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) ZHNUniversalSettingMenu *settingMenu;
@end

@implementation ZHNCosmosLongPressButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImageView.center = CGPointMake(self.width/2, self.height/2);
    self.iconImageView.bounds = CGRectMake(0, 0, 40, 40);
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.isCustomThemeColor = YES;
    self.iconImageView.image = [UIImage imageNamed:self.imageName];
    // tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    // long press gesture
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.minimumPressDuration = KLongPressMinTime;
    [self addGestureRecognizer:longPressGesture];
    // dealing gesture relationship
    [tapGesture requireGestureRecognizerToFail:longPressGesture];
}

#pragma mark - target action
- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    if (self.tapAction) {
        self.tapAction();
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.settingMenu = [ZHNUniversalSettingMenu zhn_universalSettingMenuWithMenuActivityArray:self.coronaActivityArray      centerIocnName:self.imageName];
            [self.settingMenu show];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.settingMenu.coronaMenu.hostGesture = longPressGesture;
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            [self.settingMenu disMiss];
            self.settingMenu.coronaMenu.hostGesture = longPressGesture;
        }
            break;
        default:
            break;
    }
}

#pragma mark - getters
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}
@end
