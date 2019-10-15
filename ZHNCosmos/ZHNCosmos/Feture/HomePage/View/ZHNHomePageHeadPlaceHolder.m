//
//  ZHNHomePageHeadImageView.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/4.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomePageHeadPlaceHolder.h"

@interface ZHNHomePageHeadPlaceHolder()
@property (nonatomic,strong) UIVisualEffectView *blurView;
@end

@implementation ZHNHomePageHeadPlaceHolder
- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self addSubview:self.imageView];
        [self addSubview:self.blurView];
        @weakify(self);
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            [ZHNThemeManager zhn_extraNightHandle:^{
                self.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            } dayHandle:^{
                self.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            }];
            self.blurType = ZHNPlaceholderBlurTypeChange;
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.blurView.frame = self.bounds;
}

- (void)zhn_fantasyChangeWithOffsetY:(CGFloat)offsetY imageOriginalHeight:(CGFloat)originalHeight imageBlurPercent:(CGFloat)blurPercent{
    CGPoint originalCenter = CGPointMake(K_SCREEN_WIDTH/2, originalHeight/2);
    self.blurView.alpha = blurPercent;
    
    if (blurPercent >= 1) {
        self.blurType = ZHNPlaceholderBlurFull;
    }else {
        self.blurType = ZHNPlaceholderBlurChanging;
    }
    
    if (offsetY < 0) {
        self.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, originalHeight);
        self.height = originalHeight - offsetY;
        self.imageView.frame = self.bounds;
    }else {
        CGFloat scale = 1 + 1.7 * blurPercent;
        self.imageView.center = originalCenter;
        self.imageView.bounds = CGRectMake(0, 0, K_SCREEN_WIDTH * scale, originalHeight * scale);
    }
}

#pragma mark - getters
- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        _blurView = [[UIVisualEffectView alloc]init];
        _blurView.alpha = 0;
    }
    return _blurView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end
