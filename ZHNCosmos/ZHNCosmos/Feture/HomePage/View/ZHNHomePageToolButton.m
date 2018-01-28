//
//  ZHNHomePageToolButton.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomePageToolButton.h"

@implementation ZHNHomePageToolButton
- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        __block NSString *colorStr;
        [ZHNThemeManager zhn_extraNightHandle:^{
            colorStr = @"#969696";
        } dayHandle:^{
            colorStr = @"#000000";
        }];
        [self setTitleColor:ZHNHexColor(colorStr) forState:UIControlStateNormal];
    };
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}


@end
