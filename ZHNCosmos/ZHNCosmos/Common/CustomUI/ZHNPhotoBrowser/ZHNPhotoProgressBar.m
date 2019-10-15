//
//  ZHNPhotoProgressBar.m
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPhotoProgressBar.h"

@interface ZHNPhotoProgressBar()
@property (nonatomic,strong) UIView *bar;
@end

@implementation ZHNPhotoProgressBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bar];
        self.bar.frame = CGRectMake(0, 0, 0, 4);
    }
    return self;
}

#pragma mark - setters
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    self.color = [ZHNThemeManager zhn_getThemeColor];
    if (percent >= 1) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
        self.bar.frame = CGRectMake(0, 0, self.width * percent, 4);
    }
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.bar.backgroundColor = color;
}

#pragma mark - getters
- (UIView *)bar {
    if (_bar == nil) {
        _bar = [[UIView alloc]init];
    }
    return _bar;
}
@end
