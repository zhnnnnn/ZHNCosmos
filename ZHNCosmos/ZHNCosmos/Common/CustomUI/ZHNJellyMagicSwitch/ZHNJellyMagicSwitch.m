//
//  ZHNJellyMagicSwitch.m
//  zhnSegmentSwitch
//
//  Created by zhn on 2017/12/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNJellyMagicSwitch.h"
#import "UIView+ZHNJellyMagicSwitch.h"
#define KSliderMaxX (((((CGFloat)[self.dataSource numberOfItems]) - 1)/((CGFloat)[self.dataSource numberOfItems])) * self.contentContainerView.zhn_jmsWidth)
@interface ZHNJellyMagicSwitch()<ZHNJellyMagicSwitchDataSource>
@property (nonatomic,strong) UIView *slider;
@property (nonatomic,strong) UIView *contentContainerView;
@property (nonatomic,strong) UIView *selectItemContainer;
@property (nonatomic,strong) NSMutableArray *normalItemArray;
@property (nonatomic,strong) NSMutableArray *selectItemArray;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) NSMutableArray *sliderXArray;
@property (nonatomic,assign) BOOL switherAnimating;

// For normal type Switch. If want custom switch implementation `dataSource`.
@property (nonatomic,strong) NSArray <NSString *>*normalTitles;
@property (nonatomic,strong) UIFont *normalFont;

// For Pan slider calculate
@property (nonatomic,assign) CGFloat sliderPanStartX;
@end

@implementation ZHNJellyMagicSwitch
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentPadding = 5;
        self.backgroundColor = [UIColor blueColor];
        self.slider.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panSlider:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Content container view
    [self addSubview:self.contentContainerView];
    self.contentContainerView.frame = CGRectMake(self.contentPadding, self.contentPadding, self.zhn_jmsWidth - 2 * self.contentPadding, self.zhn_jmsHeight - 2 * self.contentPadding);
    self.contentContainerView.layer.cornerRadius = self.contentContainerView.zhn_jmsHeight/2;
    self.contentContainerView.clipsToBounds = YES;
    
    // Add items
    if (self.normalItemArray.count > 0) {return;}
    NSInteger itemCount = [self.dataSource numberOfItems];
    for (int index = 0; index < itemCount; index++) {
        // Normal
        ZHNJellyMagicSwitchCell *normalCell = [[[self.dataSource jellyMagicSwitchCellClass] alloc]init];
        normalCell.tag = index;
        [self.contentContainerView addSubview:normalCell];
        [self.normalItemArray addObject:normalCell];
        normalCell.contentColor = self.normalColor;
        [self.dataSource displayJellyMagicSwitchCell:normalCell ForIndex:index];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItemAction:)];
        [normalCell addGestureRecognizer:tap];
        
        // select
        ZHNJellyMagicSwitchCell *selectCell = [[[self.dataSource jellyMagicSwitchCellClass] alloc]init];
        [self.selectItemContainer addSubview:selectCell];
        [self.selectItemArray addObject:selectCell];
        selectCell.contentColor = self.selectColor;
        [self.dataSource displayJellyMagicSwitchCell:selectCell ForIndex:index];
    }
    [self.slider addSubview:self.selectItemContainer];
    
    // Item frame
    self.layer.cornerRadius = self.frame.size.height/2;
    CGFloat w = self.contentContainerView.zhn_jmsWidth/[self.dataSource numberOfItems];
    CGFloat h = self.contentContainerView.zhn_jmsHeight;
    [self.normalItemArray enumerateObjectsUsingBlock:^(ZHNJellyMagicSwitchCell *norCell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = w * idx;
        CGFloat y = 0;
        norCell.frame = CGRectMake(x, y, w, h);
        
        ZHNJellyMagicSwitchCell *selectCell = _selectItemArray[idx];
        selectCell.frame = norCell.frame;
    }];
    
    // Slider frame
    self.slider.clipsToBounds = YES;
    CGFloat sx = w * self.currentSelectIndex;
    CGFloat sy = 0;
    CGFloat sw = w;
    CGFloat sh = h;
    self.slider.frame = CGRectMake(sx, sy, sw, sh);
    self.slider.layer.cornerRadius = sh/2;
    [self.contentContainerView addSubview:self.slider];
    
    // Select item container frame
    self.selectItemContainer.frame = CGRectMake(0, 0, self.contentContainerView.zhn_jmsWidth, self.contentContainerView.zhn_jmsHeight);
    
    // Init percent
    NSInteger count = [self.dataSource numberOfItems];
    if (count == 0) {return;}
    CGFloat percent = (CGFloat)self.currentSelectIndex / (CGFloat)(count - 1);
    self.switchPercent = percent;
    
    // Cache page slider x
    for (int index = 0; index < count; index++) {
       CGFloat pagePercent = (CGFloat)index / (CGFloat)(count - 1);
        [self.sliderXArray addObject:@(pagePercent)];
    }
}

- (void)panSlider:(UIPanGestureRecognizer *)panGes {
    if (!self.scrollEnable) {return;}
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.sliderPanStartX = self.slider.zhn_jmsX;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat transx = [panGes translationInView:self].x;
            CGFloat sliderCurrentX = self.sliderPanStartX + transx;
            CGFloat percent = sliderCurrentX / KSliderMaxX;
            self.switchPercent = percent;
            if ([self.delegate respondsToSelector:@selector(jellyMagicSwitch:switchToPercent:)]) {
                [self.delegate jellyMagicSwitch:self switchToPercent:percent];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.pageEnable) {
                // Get closest percent
                CGFloat percent = self.slider.zhn_jmsX / KSliderMaxX;
                CGFloat delta = 1;
                CGFloat closestPercent = 0;
                for (int index = 0; index < self.sliderXArray.count; index++) {
                    CGFloat pagePercent = [self.sliderXArray[index] floatValue];
                    CGFloat currentDelta = fabs(percent - pagePercent);
                    if (delta < currentDelta) {
                        [self p_animateToPercent:closestPercent];
                        if ([self.delegate respondsToSelector:@selector(jellyMagicSwitch:selectIndex:)]) {
                            [self.delegate jellyMagicSwitch:self selectIndex:index];
                        }
                        return;
                    }else {
                        closestPercent = pagePercent;
                        delta = currentDelta;
                    }
                }
                [self p_animateToPercent:1];
                if ([self.delegate respondsToSelector:@selector(jellyMagicSwitch:selectIndex:)]) {
                    [self.delegate jellyMagicSwitch:self selectIndex:self.sliderXArray.count - 1];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)selectItemAction:(UITapGestureRecognizer *)tapGes {
    NSInteger index = tapGes.view.tag;
    NSInteger count = [self.dataSource numberOfItems];
    if (count == 0) {return;}
    CGFloat percent = (CGFloat)index / (CGFloat)(count - 1);
    [self p_animateToPercent:percent];
    
    if ([self.delegate respondsToSelector:@selector(jellyMagicSwitch:selectIndex:)]) {
        [self.delegate jellyMagicSwitch:self selectIndex:index];
    }
}

- (void)setSwitchPercent:(CGFloat)switchPercent {
    _switchPercent = switchPercent;
    if (self.switherAnimating) {return;}
    if (switchPercent >= 0 && switchPercent <= 1) {
        [self p_magicTranslateForPercent:switchPercent];
    }else if (switchPercent < 0) {
        CGFloat fitPercent = self.bounce ? switchPercent : 0;
        [self p_magicTranslateForPercent:fitPercent];
    }else if (switchPercent > 1) {
        CGFloat fitPercent = self.bounce ? switchPercent : 1;
        [self p_magicTranslateForPercent:fitPercent];
    }
}

- (void)p_magicTranslateForPercent:(CGFloat)percent {
    CGFloat sliderOffsetx =  percent * KSliderMaxX;
    self.slider.zhn_jmsX = sliderOffsetx;
    self.selectItemContainer.zhn_jmsX = -sliderOffsetx;
}

- (void)p_animateToPercent:(CGFloat)percent {
    self.switherAnimating = YES;
    [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.switchPercent = percent;
    } completion:^(BOOL finished) {
        self.switherAnimating = NO;
    }];
}

- (void)reloadData {
    for (int index = 0; index < self.normalItemArray.count; index++) {
        ZHNJellyMagicSwitchCell *normalCell = self.normalItemArray[index];
        ZHNJellyMagicSwitchCell *selectCell = self.selectItemArray[index];
        [self.dataSource displayJellyMagicSwitchCell:normalCell ForIndex:index];
        [self.dataSource displayJellyMagicSwitchCell:selectCell ForIndex:index];
    }
}

- (void)reloadNormalSwitchThemeColor:(UIColor *)color {
    self.backgroundColor = color;
    for (int index = 0; index < self.normalItemArray.count; index++) {
        ZHNJellyMagicSwitchCell *selectCell = self.selectItemArray[index];
        selectCell.label.textColor = color;
    }
}

- (void)reloadSwitcherAppearanceWithBackgroundColor:(UIColor *)backgroundColor sliderColor:(UIColor *)sliderColor normalTitleColor:(UIColor *)normalTitleColor selectTitleColor:(UIColor *)selectTitleColor {
    self.normalColor = normalTitleColor;
    self.selectColor = selectTitleColor;
    self.backgroundColor = backgroundColor;
    self.slider.backgroundColor = sliderColor;
    for (int index = 0; index < self.normalItemArray.count; index++) {
        ZHNJellyMagicSwitchCell *selectCell = self.selectItemArray[index];
        ZHNJellyMagicSwitchCell *normalCell = self.normalItemArray[index];
        selectCell.label.textColor = selectTitleColor;
        normalCell.label.textColor = normalTitleColor;
    }
}

+ (instancetype)zhn_jellyMagicSwitchWithBackgroundColor:(UIColor *)backgroundColor sliderColor:(UIColor *)sliderColor cellContentNormalColor:(UIColor *)normalColor cellContentSelectColor:(UIColor *)selectColor contentpadding:(CGFloat)contentPadding {
    ZHNJellyMagicSwitch *magicSwitch = [[ZHNJellyMagicSwitch alloc]init];
    magicSwitch.contentPadding = contentPadding;
    magicSwitch.normalColor = normalColor;
    magicSwitch.selectColor = selectColor;
    magicSwitch.backgroundColor = backgroundColor;
    magicSwitch.slider.backgroundColor = sliderColor;
    return magicSwitch;
}

+ (instancetype)zhn_normalJellyMagicSwitchWithTitleArray:(NSArray<NSString *> *)titles titleFont:(UIFont *)titleFont normalTitleColor:(UIColor *)normalTitleColor selectTitleColor:(UIColor *)selectTitleColor sliderColor:(UIColor *)sliderColor backgroundColor:(UIColor *)backgroundColor{
    ZHNJellyMagicSwitch *jellySwitch = [ZHNJellyMagicSwitch zhn_jellyMagicSwitchWithBackgroundColor:backgroundColor sliderColor:sliderColor cellContentNormalColor:normalTitleColor cellContentSelectColor:selectTitleColor contentpadding:5];
    jellySwitch.normalTitles = titles;
    jellySwitch.dataSource = jellySwitch;
    jellySwitch.normalFont = titleFont;
    return jellySwitch;
}

#pragma mark - normalSwtich dataSource
- (NSInteger)numberOfItems {
    return self.normalTitles.count;
}

- (Class)jellyMagicSwitchCellClass {
    return [ZHNJellyMagicSwitchCell class];
}

- (void)displayJellyMagicSwitchCell:(ZHNJellyMagicSwitchCell *)cell ForIndex:(NSInteger)index {
    cell.label.text = self.normalTitles[index];
    cell.label.font = self.normalFont;
}

#pragma mark - getters
- (NSMutableArray *)normalItemArray {
    if (_normalItemArray == nil) {
        _normalItemArray = [NSMutableArray array];
    }
    return _normalItemArray;
}

- (NSMutableArray *)selectItemArray {
    if (_selectItemArray == nil) {
        _selectItemArray = [NSMutableArray array];
    }
    return _selectItemArray;
}

- (UIView *)slider {
    if (_slider == nil) {
        _slider = [[UIView alloc]init];
        _slider.backgroundColor = [UIColor whiteColor];
    }
    return _slider;
}

- (UIView *)selectItemContainer {
    if (_selectItemContainer == nil) {
        _selectItemContainer = [[UIView alloc]init];
    }
    return _selectItemContainer;
}

- (UIView *)contentContainerView {
    if (_contentContainerView == nil) {
        _contentContainerView = [[UIView alloc]init];
        _contentContainerView.backgroundColor = [UIColor clearColor];
    }
    return _contentContainerView;
}

- (NSMutableArray *)sliderXArray {
    if (_sliderXArray == nil) {
        _sliderXArray = [NSMutableArray array];
    }
    return _sliderXArray;
}
@end

/////////////////////////////////////////////////////
@implementation ZHNJellyMagicSwitchCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    self.label.textColor = contentColor;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end


