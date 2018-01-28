//
//  ZHNGooeyMenuItem.m
//  ZHNGooeyMenu
//
//  Created by zhn on 2017/10/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNGooeyMenuItem.h"

static const CGFloat KLinePadding = 10;
@interface ZHNGooeyMenuItem()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *bline;
@property (nonatomic,strong) UIImageView *selectMaskView;
@property (nonatomic,assign) BOOL isPointInside;
@end

@implementation ZHNGooeyMenuItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        [self addSubview:self.bline];
        [self addSubview:self.selectMaskView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
    self.bline.frame = CGRectMake(KLinePadding, self.frame.size.height - 0.5, self.frame.size.width - 2 * KLinePadding, 0.5);
    self.selectMaskView.frame = self.bounds;
}

- (instancetype)initWithTitle:(NSString *)title {
    ZHNGooeyMenuItem *item = [[ZHNGooeyMenuItem alloc]init];
    item.label.text = title;
    return item;
}

- (void)hightlight {
    self.selectMaskView.hidden = NO;
}

- (void)normal {
    self.selectMaskView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hightlight];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        self.isPointInside = YES;
    }else {
        self.isPointInside = NO;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isPointInside) {
        self.seletAction(self.tag);
    }else {
        [self normal];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isPointInside) {
        self.seletAction(self.tag);
    }else {
        [self normal];
    }
}
#pragma mark - getteres
- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:17];
    }
    return _label;
}

- (UIImageView *)bline {
    if (_bline == nil) {
        _bline = [[UIImageView alloc]init];
        _bline.backgroundColor = [UIColor whiteColor];
        _bline.alpha = 0.5;
    }
    return _bline;
}

- (UIImageView *)selectMaskView {
    if (_selectMaskView == nil) {
        _selectMaskView = [[UIImageView alloc]init];
        _selectMaskView.userInteractionEnabled = YES;
        _selectMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _selectMaskView.hidden = YES;
    }
    return _selectMaskView;
}
@end
