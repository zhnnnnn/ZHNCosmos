//
//  ZHNTimelineDetailToolView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailToolView.h"
#import "ZHNTimelineDetailSwitchCell.h"

@interface ZHNTimelineDetailToolView()<ZHNJellyMagicSwitchDataSource>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *popButton;
@property (nonatomic,strong) UIButton *shareButton;
@end

@implementation ZHNTimelineDetailToolView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(NormalViewBG);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.switcher];
        [self.contentView addSubview:self.popButton];
        [self.contentView addSubview:self.shareButton];
        
        // Shadow
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        [ZHNThemeManager zhn_extraNightHandle:^{
            self.layer.shadowColor = [UIColor whiteColor].CGColor;
        } dayHandle:^{
            self.layer.shadowColor = [UIColor blackColor].CGColor;
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat bottomInset = IS_IPHONEX ? K_tabbar_safeArea_height : 0;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, bottomInset, 0));
    }];
    [self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(0.4);
    }];
    [self.popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.height.equalTo(self.contentView).multipliedBy(0.4);
        make.width.equalTo(self.popButton.mas_height);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(self.contentView).multipliedBy(0.6);
        make.width.equalTo(self.shareButton.mas_height);
    }];
}

#pragma mark - delegate
- (NSInteger)numberOfItems {
    return 3;
}

- (Class)jellyMagicSwitchCellClass {
    return [ZHNTimelineDetailSwitchCell class];
}

- (void)displayJellyMagicSwitchCell:(ZHNJellyMagicSwitchCell *)cell ForIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [(ZHNTimelineDetailSwitchCell *)cell nameLabel].text = @"转发";
            [(ZHNTimelineDetailSwitchCell *)cell detailLabel].text = self.detailBasic.reposts ? self.detailBasic.reposts : 0;
        }
            break;
        case 1:
        {
            [(ZHNTimelineDetailSwitchCell *)cell nameLabel].text = @"微博";
            [(ZHNTimelineDetailSwitchCell *)cell detailLabel].text = @"详情";
        }
            break;
        case 2:
        {
            [(ZHNTimelineDetailSwitchCell *)cell nameLabel].text = @"评论";
            [(ZHNTimelineDetailSwitchCell *)cell detailLabel].text = self.detailBasic.comments ? self.detailBasic.comments : 0;
        }
            break;
        default:
            break;
    }
}

#pragma mark - setters
- (void)setDetailBasic:(ZHNDetailBasicModel *)detailBasic {
    _detailBasic = detailBasic;
    [self.switcher reloadData];
}

#pragma mark - getters
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

- (ZHNJellyMagicSwitch *)switcher {
    if (_switcher == nil) {
        _switcher = [ZHNJellyMagicSwitch zhn_jellyMagicSwitchWithBackgroundColor:[ZHNThemeManager zhn_getThemeColor] sliderColor:[UIColor whiteColor] cellContentNormalColor:[UIColor whiteColor] cellContentSelectColor:[ZHNThemeManager zhn_getThemeColor] contentpadding:2];
        _switcher.dataSource = self;
    }
    return _switcher;
}

- (UIButton *)popButton {
    if (_popButton == nil) {
        _popButton = [[UIButton alloc]init];
        _popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_popButton setImage:[[UIImage imageNamed:@"back"] imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]]  forState:UIControlStateNormal];
        @weakify(self);
        [[_popButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate toolViewClickToPopController];
        }];
        _popButton.zhn_expandTouchInset = UIEdgeInsetsMake(-5, -5, -5, -5);
    }
    return _popButton;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [[UIButton alloc]init];
        _shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_shareButton setImage:[[UIImage imageNamed:@"bubble_popover_share_activity"] imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]]  forState:UIControlStateNormal];
        [[_shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [ZHNHudManager showWarning:@"TODO"];
        }];
    }
    return _shareButton;
}
@end
