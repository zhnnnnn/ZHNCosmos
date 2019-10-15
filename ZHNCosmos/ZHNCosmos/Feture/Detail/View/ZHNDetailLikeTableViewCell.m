//
//  ZHNDetailLikeTableViewCell.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/10.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDetailLikeTableViewCell.h"

@interface ZHNDetailLikeTableViewCell()
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *separator;
@end

@implementation ZHNDetailLikeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.avatar];
        [self addSubview:self.nameLabel];
        [self addSubview:self.separator];
        self.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.avatar.mas_right).offset(10);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

+ (ZHNDetailLikeTableViewCell *)zhn_detailLikeCellWithTableView:(UITableView *)tableView {
    ZHNDetailLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell"];
    if (!cell) {
        cell = [[ZHNDetailLikeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"likeCell"];
    }
    return cell;
}

#pragma mark - setters
- (void)setUser:(ZHNTimelineUser *)user {
    _user = user;
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholder:nil];
    self.nameLabel.text = user.name;
}

#pragma mark - getters
- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
        _avatar.layer.cornerRadius = 15;
        _avatar.clipsToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    }
    return _nameLabel;
}

- (UIImageView *)separator {
    if (_separator == nil) {
        _separator = [[UIImageView alloc]init];
        _separator.dk_backgroundColorPicker = DKColorPickerWithKey(DetailCellSeparatorColor);
    }
    return _separator;
}
@end
