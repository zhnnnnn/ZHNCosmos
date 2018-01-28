//
//  ZHNHomePageHeaderView.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/1.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomePageHeaderView.h"
#import "ZHNHomePageInformationTool.h"
#import "ZHNHomepageRelationshipButton.h"
#import "ZHNStatusHelper.h"

static CGFloat const KSwitcherHeight = 34;
static CGFloat const KAvatarSize = 60;
static CGFloat const KNormalPadding = 5;
static CGFloat const KIntroPadding = 50;
static CGFloat const KIntroFont = 13;
static CGFloat const KNameFont = 20;
static CGFloat const KScaleCoefficient = 0.5;

@interface ZHNHomePageHeaderView()
@property (nonatomic,strong) UIImageView *curvePlaceholder;
@property (nonatomic,strong) UIView *avatar;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *introLabel;
@property (nonatomic,strong) ZHNHomepageRelationshipButton *relationShipBtn;
@property (nonatomic,strong) ZHNHomePageInformationTool *informationTool;
@property (nonatomic,assign) CGFloat rsBtnHeight;
@end

@implementation ZHNHomePageHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.curvePlaceholder];
        [self addSubview:self.timelineTypeSwitcher];
        [self addSubview:self.avatar];
        [self addSubview:self.informationTool];
        [self addSubview:self.nameLabel];
        [self addSubview:self.introLabel];
        [self addSubview:self.relationShipBtn];
        [self.avatar addSubview:self.avatarImageView];
        
        @weakify(self);
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);            
            self.curvePlaceholder.image = [[UIImage imageNamed:@"user_tableHeader_curve"] imageWithTintColor:ZHNCurrentThemeFitColorForkey(CellBG)];
        };
        
        self.extraThemeColorChangeHandle = ^{
            @strongify(self);
            [self.timelineTypeSwitcher reloadNormalSwitchThemeColor:[ZHNThemeManager zhn_getThemeColor]];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timelineTypeSwitcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-KNormalPadding);
        make.width.equalTo(self).multipliedBy(0.7);
        make.height.mas_equalTo(KSwitcherHeight);
    }];
    [self.informationTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.timelineTypeSwitcher.mas_top).offset(-10);
        make.height.mas_equalTo(30);
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.informationTool.mas_top).offset(-KNormalPadding);
        make.centerX.equalTo(self);
        make.width.mas_lessThanOrEqualTo(K_SCREEN_WIDTH - KIntroPadding * 2);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.introLabel.mas_top).offset(-KNormalPadding);
    }];
    [self.relationShipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-KNormalPadding);
        make.width.mas_equalTo(self.relationShipBtn.fitWidth);
        make.height.mas_equalTo(self.rsBtnHeight);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.relationShipBtn.mas_top).offset(-KNormalPadding);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KAvatarSize, KAvatarSize));
    }];
    [self.curvePlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.avatar.mas_centerY);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
}

- (void)zhn_fantasyChangeWithPercent:(CGFloat)percent {
    CGFloat scale = 1 - KScaleCoefficient * percent;
    CGFloat translateY = KScaleCoefficient * KAvatarSize * 0.5 * percent;
    self.avatar.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale), CGAffineTransformMakeTranslation(0, translateY));
}

#pragma mark - setters
- (void)setType:(ZHNHomePageType)type {
    _type = type;
    switch (type) {
        case ZHNHomePageTypeMine:
        {
            self.relationShipBtn.hidden = YES;
            self.rsBtnHeight = 0;
        }
            break;
        case ZHNHomePageTypeOther:
        {
            self.relationShipBtn.hidden = NO;
            self.rsBtnHeight = 22;
        }
            break;
    }
}

#pragma mark - setters
- (void)setUserDetail:(ZHNTimelineUser *)userDetail {
    _userDetail = userDetail;
    self.introLabel.text = userDetail.userDescription;
    self.nameLabel.text = userDetail.name;
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:userDetail.profileImageUrl] placeholder:[UIImage imageNamed:@"placeholder_user_man"]];
    self.informationTool.userDetail = userDetail;
    
    // Relationship button
    if (userDetail.following && userDetail.followMe) {
        self.relationShipBtn.relationShip = ZHNUserRelationShipFollowEachOther;
    }else if (userDetail.following) {
        self.relationShipBtn.relationShip = ZHNUserRelationShipFollowing;
    }else if (userDetail.followMe) {
        self.relationShipBtn.relationShip = ZHNUserRelationShipFollowMe;
    }else {
        self.relationShipBtn.relationShip = ZHNUserRelationShipNone;
    }
    [self.relationShipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-5);
        make.width.mas_equalTo(self.relationShipBtn.fitWidth);
        make.height.mas_equalTo(self.rsBtnHeight);
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

#pragma mark - getters
- (CGFloat)curveHeight {
    return self.curvePlaceholder.height;
}

- (CGFloat)switcherHeight {
    return KSwitcherHeight;
}

- (CGFloat)switcherPadding {
    return KNormalPadding;
}

- (CGFloat)avatorStartTransHeight {
    return self.curvePlaceholder.y + KScaleCoefficient * KAvatarSize;
}

- (CGFloat)avatorEndTransHeight {
    return self.nameLabel.y + self.nameLabel.height;
}

- (CGFloat)nameStartTransHeight {
    return self.nameLabel.y;
}

- (CGFloat)nameEndTransHeight {
    return self.nameLabel.y + self.nameLabel.height;
}

- (CGFloat)headerFullHeight {
    CGFloat introHeight = [ZHNStatusHelper caluateTextHeightWithText:self.userDetail.userDescription MaxWidth:K_SCREEN_WIDTH - KIntroPadding * 2  font:KIntroFont];
    switch (self.type) {
        case ZHNHomePageTypeMine:
        {
            return 210 + K_statusBar_height + introHeight;
        }
            break;
        case ZHNHomePageTypeOther:
        {
            return 250 + K_statusBar_height + introHeight;
        }
            break;
    }
}

- (ZHNJellyMagicSwitch *)timelineTypeSwitcher {
    if (_timelineTypeSwitcher == nil) {
        _timelineTypeSwitcher = [ZHNJellyMagicSwitch zhn_normalJellyMagicSwitchWithTitleArray:@[@"全部微博",@"更多微博"] titleFont:[UIFont systemFontOfSize:15] normalTitleColor:[UIColor whiteColor] selectTitleColor:[ZHNThemeManager zhn_getThemeColor] sliderColor:[UIColor whiteColor] backgroundColor:[ZHNThemeManager zhn_getThemeColor]];
        _timelineTypeSwitcher.contentPadding = 2;
        _timelineTypeSwitcher.bounce = YES;
    }
    return _timelineTypeSwitcher;
}

- (UIImageView *)curvePlaceholder {
    if (_curvePlaceholder == nil) {
        _curvePlaceholder = [[UIImageView alloc]init];
    }
    return _curvePlaceholder;
}

- (UIView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIView alloc]init];
        _avatar.layer.cornerRadius = KAvatarSize/2;
        _avatar.layer.masksToBounds = YES;
        _avatar.backgroundColor = [UIColor whiteColor];
    }
    return _avatar;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.cornerRadius = (KAvatarSize - 2)/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (ZHNHomepageRelationshipButton *)relationShipBtn {
    if (_relationShipBtn == nil) {
        _relationShipBtn = [[ZHNHomepageRelationshipButton alloc]init];
        [[_relationShipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [ZHNHudManager showWarning:@"TODO~"];
        }];
    }
    return _relationShipBtn;
}

- (UILabel *)introLabel {
    if (_introLabel == nil) {
        _introLabel = [[UILabel alloc]init];
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.numberOfLines = 0;
        _introLabel.font = [UIFont systemFontOfSize:KIntroFont];
        _introLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    }
    return _introLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:KNameFont];
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    }
    return _nameLabel;
}

- (ZHNHomePageInformationTool *)informationTool {
    if (_informationTool == nil) {
        _informationTool = [ZHNHomePageInformationTool loadView];
    }
    return _informationTool;
}
@end
