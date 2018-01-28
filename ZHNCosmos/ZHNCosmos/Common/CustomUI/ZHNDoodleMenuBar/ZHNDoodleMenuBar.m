//
//  ZHNDoodleMenuBar.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDoodleMenuBar.h"
#import "ZHNShineButton.h"

#define KToolBarWidth ([UIScreen mainScreen].bounds.size.width - 60)
static CGFloat const KFootCircleSize = 10;
static CGFloat const KSemiCircleSize = 18;
static CGFloat const KToolBarHeight = 44;
static CGFloat const KToolBarItemSize = 30;
static CGFloat const KBackMaskMaxAlpha = 0.6;
@interface ZHNDoodleMenuBar()
@property (nonatomic,strong) UIView *backMaskView;
@property (nonatomic,strong) NSArray *menuItemArray;
@property (nonatomic,strong) UIImageView *footCircle;
@property (nonatomic,strong) UIImageView *semicircle;
@property (nonatomic,strong) UIImageView *toolBar;
@property (nonatomic,strong) NSMutableArray *menuBarButtonItemArray;
@end

@implementation ZHNDoodleMenuBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backMaskView];
        [self addSubview:self.footCircle];
        [self addSubview:self.toolBar];
        [self addSubview:self.semicircle];
    }
    return self;
}

- (void)zhn_animateShowDoodleMenuBarWithAnchroPoint:(CGPoint)anchroPoint {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.frame = keyWindow.bounds;
    // Back mask
    self.backMaskView.frame = self.bounds;
    // Foot circle frame
    self.footCircle.center = CGPointMake(anchroPoint.x, anchroPoint.y - 10);
    self.footCircle.bounds = CGRectMake(0, 0, KFootCircleSize, KFootCircleSize);
    self.footCircle.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    // Semi circle frame
    self.semicircle.center = CGPointMake(anchroPoint.x - KSemiCircleSize/2, anchroPoint.y - 25);
    self.semicircle.bounds = CGRectMake(0, 0, KSemiCircleSize, KSemiCircleSize);
    self.semicircle.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    // Bar animate start frame
    CGFloat toolBarStartW = KToolBarHeight;
    CGFloat toolBarStartCenterX = (anchroPoint.x + KToolBarHeight/2) - toolBarStartW/2;
    CGPoint toolBarStartCenter = CGPointMake(toolBarStartCenterX, self.semicircle.center.y - KToolBarHeight/2);
    CGRect toolBarStartBounds = CGRectMake(0, 0, KToolBarHeight, KToolBarHeight);
    CGRect toolBarStartFrame = [self p_getFrameWithCenter:toolBarStartCenter bounds:toolBarStartBounds];
    
    // Bar animate end frame
    CGFloat toolBarEndW = KToolBarWidth;
    CGFloat toolBarEndCenterX = (anchroPoint.x + KToolBarHeight/2) - toolBarEndW/2;
    CGPoint toolBarEndCenter = CGPointMake(toolBarEndCenterX, self.semicircle.center.y - KToolBarHeight/2);
    CGRect toolBarEndBounds = CGRectMake(0, 0, toolBarEndW, KToolBarHeight);
    CGRect toolBarEndFrame = [self p_getFrameWithCenter:toolBarEndCenter bounds:toolBarEndBounds];
    
    // Bar
    self.toolBar.frame = toolBarStartFrame;
    self.toolBar.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_animateToDismissMenuBar)];
    [self addGestureRecognizer:tap];
    
    // Bar item button frame
    @weakify(self);
    CGFloat barItemPadding = (toolBarEndW - self.menuItemArray.count * KToolBarItemSize)/(self.menuItemArray.count + 1);
    [self.menuItemArray enumerateObjectsUsingBlock:^(ZHNDoodleMenuButtonItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImage *normalImage = [[UIImage imageNamed:item.imageName] imageWithTintColor:item.normalColor];
        UIImage *selectImage = [[UIImage imageNamed:item.imageName] imageWithTintColor:item.selectColor];
        ZHNShineButton *btn = [ZHNShineButton zhn_shineButtonWithTintColor:item.selectColor normalImage:normalImage hightLightImage:selectImage normalTypeTapAction:^{
            [self.delegate ZHNDoodleMenuBarClickIndex:idx barItemIsSelectAfter:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self p_animateToDismissMenuBar];
            });
        } hightLightTypeTapAction:^{
            [self.delegate ZHNDoodleMenuBarClickIndex:idx barItemIsSelectAfter:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self p_animateToDismissMenuBar];
            });
        }];
        btn.isCycleResponse = YES;
        
        [self addSubview:btn];
        [self.menuBarButtonItemArray addObject:btn];
        
        CGFloat btnCenterX = toolBarEndFrame.origin.x + (barItemPadding + KToolBarItemSize/2) * (idx + 1) + idx * KToolBarItemSize/2;
        CGPoint center = CGPointMake(btnCenterX, toolBarStartCenter.y);
        btn.center = center;
        btn.bounds = CGRectMake(0, 0, KToolBarItemSize, KToolBarItemSize);
        btn.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeTranslation(-20, KToolBarHeight/2));
    }];
    
    // Mask animate
    [UIView animateWithDuration:0.3 animations:^{
        self.backMaskView.alpha = KBackMaskMaxAlpha;
    }];
    
    // Normal view animate
    [UIView animateWithDuration:0.1 animations:^{
        self.footCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.toolBar.transform = CGAffineTransformIdentity;
            self.semicircle.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                self.toolBar.frame = toolBarEndFrame;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
    
    // Bar Item animate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block CGFloat afterTime = 0;
        [self.menuBarButtonItemArray enumerateObjectsUsingBlock:^(UIView  *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveLinear animations:^{
                    btn.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
            });
            afterTime += 0.05;
        }];
    });
}

#pragma mark - public methods
+ (instancetype)zhn_doodleMenuBarWithMenuButtonItemArray:(NSArray <ZHNDoodleMenuButtonItem *>*)menuItemArray {
    ZHNDoodleMenuBar *bar = [[ZHNDoodleMenuBar alloc]init];
    bar.menuItemArray = menuItemArray;
    return bar;
}

- (CGRect)p_getFrameWithCenter:(CGPoint)center bounds:(CGRect)bounds {
    return CGRectMake(center.x - bounds.size.width/2, center.y - bounds.size.height/2, bounds.size.width, bounds.size.height);
}

#pragma mark - target action
- (void)p_animateToDismissMenuBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - setters
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.footCircle.backgroundColor = tintColor;
    self.semicircle.backgroundColor = tintColor;
    self.toolBar.backgroundColor = tintColor;
}

#pragma mark - getters
- (UIImageView *)footCircle {
    if (_footCircle == nil) {
        _footCircle = [[UIImageView alloc]init];
        _footCircle.layer.cornerRadius = KFootCircleSize/2;
    }
    return _footCircle;
}

- (UIImageView *)semicircle {
    if (_semicircle == nil) {
        _semicircle = [[UIImageView alloc]init];
        _semicircle.layer.cornerRadius = KSemiCircleSize/2;
    }
    return _semicircle;
}

- (UIImageView *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIImageView alloc]init];
        _toolBar.layer.cornerRadius = KToolBarHeight/2;
        _toolBar.layer.shadowColor = self.tintColor.CGColor;
        _toolBar.layer.shadowOpacity = 0.5;
        _toolBar.layer.shadowOffset = CGSizeMake(0, 0);
        _toolBar.layer.shadowRadius = 10;
    }
    return _toolBar;
}

- (UIView *)backMaskView {
    if (_backMaskView == nil) {
        _backMaskView = [[UIView alloc]init];
        _backMaskView.backgroundColor = [UIColor blackColor];
        _backMaskView.alpha = 0;
    }
    return _backMaskView;
}

- (NSMutableArray *)menuBarButtonItemArray {
    if (_menuBarButtonItemArray == nil) {
        _menuBarButtonItemArray = [NSMutableArray array];
    }
    return _menuBarButtonItemArray;
}
@end

////////////////////////////////////////////////////////
@implementation ZHNDoodleMenuButtonItem
+ (instancetype)zhn_doodleMenuButtonItemWithImageName:(NSString *)imageName imageNormalColor:(UIColor *)normalColor imageSelectColor:(UIColor *)selectColor isSelectd:(BOOL)selected {
    ZHNDoodleMenuButtonItem *item = [[ZHNDoodleMenuButtonItem alloc]init];
    item.imageName = imageName;
    item.normalColor = normalColor;
    item.selectColor = selectColor;
    item.selected = selected;
    return item;
}
@end

