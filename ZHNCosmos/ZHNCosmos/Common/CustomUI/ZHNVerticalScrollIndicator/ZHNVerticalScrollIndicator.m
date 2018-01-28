//
//  ZHNVerticalScrollIndicator.m
//  wjGovernment
//
//  Created by zhn on 2017/12/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVerticalScrollIndicator.h"

@interface ZHNVerticalScrollIndicator()
@property (nonatomic,strong) UILabel *label;
@end

@implementation ZHNVerticalScrollIndicator
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    [self addSubview:self.label];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.label.text = [NSString stringWithFormat:@"%ld",index + 1];
    [self.label sizeToFit];
    CGFloat height = 16;
    CGFloat width = self.label.frame.size.width + height + 3;
    self.bounds = CGRectMake(0, 0, width, height);
    self.label.center = CGPointMake(self.frame.size.width/2 - 5, self.frame.size.height/2);
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:10];
    }
    return _label;
}
@end
