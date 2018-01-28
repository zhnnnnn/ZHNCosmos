//
//  ZHNTransitionHeader.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTransitionManager.h"
static CGFloat const KlineWidth = 20;
static CGFloat const KlineHeight = 6;
static CGFloat const KTransitionMinNum = 60;
static CGFloat const KMaxAngle = M_PI / 8;

typedef NS_ENUM(NSInteger,ZHNTransitionState) {
    ZHNTransitionStateCommon,
    ZHNTransitionStateWillTransitioning,
    ZHNTransitionStateTransitioning,
};

@interface ZHNTransitionManager()
@property (nonatomic,strong) UIImageView *upLeftLine;
@property (nonatomic,strong) UIImageView *lowerRightLine;
@property (nonatomic,strong) UIColor *themeColor;
@property (nonatomic,assign) BOOL isTransitioning;
@property (nonatomic,assign) ZHNTransitionState state;
@end

@implementation ZHNTransitionManager
#pragma mark - lif cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.upLeftLine];
        [self addSubview:self.lowerRightLine];
        @weakify(self);
        self.extraThemeColorChangeHandle = ^{
            @strongify(self);
            self.themeColor = [ZHNThemeManager zhn_getThemeColor];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.direction) {
        case ZHNScrollDirectionBottom:
        {
            self.upLeftLine.bounds = CGRectMake(0, 0, KlineWidth, KlineHeight);
            self.lowerRightLine.bounds = CGRectMake(0, 0, KlineWidth, KlineHeight);
            self.upLeftLine.layer.anchorPoint = CGPointMake(1, 0.5);
            self.lowerRightLine.layer.anchorPoint = CGPointMake(0, 0.5);
            self.upLeftLine.center = CGPointMake(self.frame.size.width/2 + KlineHeight/2, KlineHeight/2 + self.pointerMarging);
            self.lowerRightLine.center = CGPointMake(self.frame.size.width/2 - KlineHeight/2, KlineHeight/2 + self.pointerMarging);;
        }
            break;
        case ZHNScrollDirectionTop:
        {
            self.upLeftLine.bounds = CGRectMake(0, 0, KlineWidth, KlineHeight);
            self.lowerRightLine.bounds = CGRectMake(0, 0, KlineWidth, KlineHeight);
            self.upLeftLine.layer.anchorPoint = CGPointMake(1, 0.5);
            self.lowerRightLine.layer.anchorPoint = CGPointMake(0, 0.5);
            self.upLeftLine.center = CGPointMake(self.frame.size.width/2 + KlineHeight/2, self.frame.size.height - KlineHeight/2 - self.pointerMarging);
            self.lowerRightLine.center = CGPointMake(self.frame.size.width/2 - KlineHeight/2, self.frame.size.height - KlineHeight/2 - self.pointerMarging);;
        }
            break;
        case ZHNScrollDirectionLeft:
        {
            
        }
            break;
        case ZHNScrollDirectionRight:
        {
            
        }
            break;
    }
}

#pragma mark - setters
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    @weakify(self);
    [[RACObserve(self, self.scrollView.contentOffset) skip:1] subscribeNext:^(id point) {
        @strongify(self);
        CGPoint offset = [point CGPointValue];
        CGFloat angle = 0;
        switch (self.direction) {
            case ZHNScrollDirectionTop:
            {
                CGFloat extra = scrollView.contentInset.top;
                CGFloat delta = -(extra + offset.y);
                angle = delta / KTransitionMinNum * KMaxAngle;
                angle = angle < 0 ? 0 : angle;
            }
                break;
            case ZHNScrollDirectionBottom:
            {
                CGFloat delta = offset.y - (scrollView.contentSize.height - K_SCREEN_HEIGHT);
                angle = delta / KTransitionMinNum * KMaxAngle;
            }
                break;
            default:
                break;
        }
        
        if (!self.scrollView.dragging) {
            if (self.state == ZHNTransitionStateWillTransitioning) {
                self.state = ZHNTransitionStateTransitioning;
                if (self.handle) {
                    self.handle();
                }
            }
        }else {
            if (angle > KMaxAngle) {
                angle = KMaxAngle;
                self.lowerRightLine.backgroundColor = self.themeColor;
                self.upLeftLine.backgroundColor = self.themeColor;
                self.state = ZHNTransitionStateWillTransitioning;
            }else {
                self.lowerRightLine.backgroundColor = ZHNHexColor(@"#aaaaaa");
                self.upLeftLine.backgroundColor = ZHNHexColor(@"#aaaaaa");
                self.state = ZHNTransitionStateCommon;
            }
            CGAffineTransform trans = CGAffineTransformIdentity;
            
            switch (self.direction) {
                case ZHNScrollDirectionTop:
                    break;
                case ZHNScrollDirectionBottom:
                    angle = -angle;
                    break;
                case ZHNScrollDirectionLeft:
                    
                    break;
                case ZHNScrollDirectionRight:
                    
                    break;
            }
            self.upLeftLine.transform = CGAffineTransformRotate(trans, angle);
            self.lowerRightLine.transform = CGAffineTransformRotate(trans, -angle);
        }
    }];
}

#pragma mark - getters
- (UIImageView *)upLeftLine {
    if (_upLeftLine == nil) {
        _upLeftLine = [[UIImageView alloc]init];
        _upLeftLine.layer.cornerRadius = KlineHeight/2;
        _upLeftLine.backgroundColor = ZHNHexColor(@"#aaaaaa");
    }
    return _upLeftLine;
}

- (UIImageView *)lowerRightLine {
    if (_lowerRightLine == nil) {
        _lowerRightLine = [[UIImageView alloc]init];
        _lowerRightLine.layer.cornerRadius = KlineHeight/2;
        _lowerRightLine.backgroundColor = ZHNHexColor(@"#aaaaaa");
    }
    return _lowerRightLine;
}

@end
