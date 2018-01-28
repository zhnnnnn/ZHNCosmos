//
//  ZHNDetailLikeSectionHeader.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/10.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDetailLikeSectionHeader.h"

@interface ZHNDetailLikeSectionHeader()
@property (nonatomic,strong) UILabel *likeLabel;
@end

@implementation ZHNDetailLikeSectionHeader
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.likeLabel];
        self.dk_backgroundColorPicker = DKColorPickerWithKey(CellSectionHeaderBG);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}

- (void)setLikeNumStr:(NSString *)likeNumStr {
    _likeNumStr = likeNumStr;
    if (!likeNumStr) {return;}
    self.likeLabel.text = [NSString stringWithFormat:@"赞 %@",likeNumStr];
}

- (UILabel *)likeLabel {
    if (_likeLabel == nil) {
        _likeLabel = [[UILabel alloc]init];
        _likeLabel.text = @"赞 0";
        _likeLabel.font = [UIFont systemFontOfSize:17];
        _likeLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    }
    return _likeLabel;
}
@end
