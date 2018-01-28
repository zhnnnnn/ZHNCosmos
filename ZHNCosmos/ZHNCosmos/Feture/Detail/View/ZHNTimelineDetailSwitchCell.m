//
//  ZHNTimelineDetailSwitchCell.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailSwitchCell.h"

@implementation ZHNTimelineDetailSwitchCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self).multipliedBy(0.5);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setContentColor:(UIColor *)contentColor {
    [super setContentColor:contentColor];
    self.nameLabel.textColor = contentColor;
    self.detailLabel.textColor = contentColor;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:8];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.text = @"0";
    }
    return _detailLabel;
}
@end
