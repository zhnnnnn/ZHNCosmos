//
//  ZHNControlpadSlider.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadSlider.h"
#import "ZHNCosmosConfigManager.h"
static CGFloat KPercentDelta = 200;
@interface ZHNControlpadSlider()
@property (nonatomic,strong) UIImageView *percentView;
@property (nonatomic,strong) UIImageView *indicator;
@property (nonatomic,assign) CGFloat currentPercent;
@property (nonatomic,assign) CGFloat tempPercent;
@end

@implementation ZHNControlpadSlider
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        self.backgroundColor = ZHNHexColor(@"#9b9b9b");
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self addSubview:self.percentView];
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.percentView.frame = self.bounds;
    self.indicator.frame = CGRectMake(0, 0, self.width, 10);
    
    CGFloat hPercent = (self.currentValue - self.minValue) / (self.maxValue - self.minValue);
    self.currentPercent = hPercent;
    [self p_percentViewFrameChangeWithPercent:hPercent];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panSlider:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - target action
- (void)panSlider:(UIPanGestureRecognizer *)panGes {
    
    switch (panGes.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percent;
            CGFloat transY = [panGes translationInView:self].y;
            CGFloat delta = -transY/KPercentDelta;
            percent = self.currentPercent + delta;
            percent = percent > 1 ? 1 : percent;
            percent = percent < 0 ? 0 : percent;
            self.tempPercent = percent;
            [self p_percentViewFrameChangeWithPercent:percent];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (self.valueChangeHandle) {
                self.valueChangeHandle(0);
            }
            
            self.currentPercent = self.tempPercent;
            int value = self.minValue + (self.maxValue - self.minValue) * self.currentPercent;
            [ZHNCosmosConfigManager updateCommonConfigWithDBname:self.cofigDBName value:value];
        }
            break;
        default:
            break;
    }
}

#pragma mark -  getters
- (void)p_percentViewFrameChangeWithPercent:(CGFloat)percent {
    CGFloat y = (1 - percent) * self.height;
    self.percentView.frame = CGRectMake(0, y, self.percentView.width, self.percentView.height);
    self.indicator.frame = CGRectMake(0, y, self.indicator.width, self.indicator.height);
}

#pragma mark - getters
- (UIImageView *)percentView {
    if (_percentView == nil) {
        _percentView = [[UIImageView alloc]init];
        _percentView.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
    }
    return _percentView;
}

- (UIImageView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIImageView alloc]init];
        _indicator.image = [UIImage imageNamed:@"control_pad_slider_indicator"];
        _indicator.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _indicator;
}

@end
