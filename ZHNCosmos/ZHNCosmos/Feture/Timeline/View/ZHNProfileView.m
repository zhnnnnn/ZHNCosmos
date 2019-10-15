//
//  ZHNSatusHeadView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNProfileView.h"
#import "UIImageView+ZHNWebimage.h"

@interface ZHNProfileView()
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) YYLabel *nameLabel;
@property (nonatomic,strong) YYLabel *dateSourceLabel;
@property (nonatomic,strong) UIImageView *vipIcon;
@end

@implementation ZHNProfileView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.dateSourceLabel];
        [self addSubview:self.vipIcon];
    }
    return self;
}

- (void)setLayout:(ZHNTimelineLayoutModel *)layout {
    _layout = layout;
    // frame
    self.frame = layout.profileF;
    self.headImageView.frame = layout.AvatarF;
    self.nameLabel.frame = layout.nameF;
    self.dateSourceLabel.frame = layout.dateSourceF;
    
    // status
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:layout.status.user.avatarHd] placeholder:[UIImage imageNamed:@"placeholder_user_man"]];
    self.dateSourceLabel.text = layout.status.dateAndSourceStr;
    self.nameLabel.text = layout.status.user.name;
    if (![self.nameLabel.textColor isEqual:[ZHNThemeManager zhn_getThemeColor]]) {
        self.nameLabel.textColor = [ZHNThemeManager zhn_getThemeColor];
    }
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius = KHeadIconSize/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self zhn_routerEventWithName:KCellTapAvatarOrUsernameAction
                                 userInfo:@{KCellTapAvatarOrUsernameUserModelKey:self.layout.status.user}];
        }];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (YYLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[YYLabel alloc]init];
        _nameLabel.textColor = [ZHNThemeManager zhn_getThemeColor];
        _nameLabel.font = [UIFont zhn_fontWithSize:KHeadNameFont];
        _nameLabel.displaysAsynchronously = YES;
        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
        _nameLabel.fadeOnHighlight = NO;
        @weakify(self);
        _nameLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            [self zhn_routerEventWithName:KCellTapAvatarOrUsernameAction
                                 userInfo:@{KCellTapAvatarOrUsernameUserModelKey:self.layout.status.user}];
        };
    }
    return _nameLabel;
}
- (YYLabel *)dateSourceLabel {
    if (_dateSourceLabel == nil) {
        _dateSourceLabel = [[YYLabel alloc]init];
        _dateSourceLabel.font = [UIFont zhn_fontWithSize:KHeadDateFont];
        _dateSourceLabel.textColor = [UIColor lightGrayColor];
        _dateSourceLabel.displaysAsynchronously = YES;
        _dateSourceLabel.fadeOnAsynchronouslyDisplay = NO;
        _dateSourceLabel.fadeOnHighlight = NO;
    }
    return _dateSourceLabel;
}

- (UIImageView *)vipIcon {
    if (_vipIcon == nil) {
        _vipIcon = [[UIImageView alloc]init];
    }
    return _vipIcon;
}
@end
