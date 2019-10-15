//
//  ZHNGooeyMenu.m
//  ZHNGooeyMenu
//
//  Created by zhn on 2017/10/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNGooeyMenu.h"
#import "ZHNGooeyMenuItem.h"

#define K_Gooey_Screen_Height [UIScreen mainScreen].bounds.size.height
#define K_Goory_Screen_Width [UIScreen mainScreen].bounds.size.width
#define KMenu_blank_height 100
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define K_Goory_Is_IphoneX (K_Gooey_Screen_Height == 812)
#define K_Bottom_extra_Height (K_Goory_Is_IphoneX ? 34 : 0)

@interface ZHNGooeyMenu()
@property (nonatomic,strong) NSMutableArray <ZHNGooeyMenuItem *> *itemArray;
@property (nonatomic,strong) UIImageView *matteView;
@property (nonatomic,strong) UIImageView *assistSideView;
@property (nonatomic,strong) UIImageView *assistCenterView;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,strong) UIColor *menuColor;
@property (nonatomic,assign) CGFloat diff;
@property (nonatomic,assign) int animateTag;
@property (nonatomic,assign) BOOL isNeedShowSelected;
@end

@implementation ZHNGooeyMenu
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, KMenu_blank_height)];
    [path addQuadCurveToPoint:CGPointMake(K_Goory_Screen_Width, KMenu_blank_height) controlPoint:CGPointMake(K_Goory_Screen_Width/2,  KMenu_blank_height + self.diff)];
    [path addLineToPoint:CGPointMake(K_Goory_Screen_Width, KMenu_blank_height)];
    [path addLineToPoint:CGPointMake(K_Goory_Screen_Width, self.frame.size.height)];
    [path closePath];
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [self.menuColor set];
    CGContextFillPath(context);
}

#pragma mark - public method
- (ZHNGooeyMenu *)initWithTitleArray:(NSArray<NSString *> *)titleArray itemHeight:(CGFloat)Height menuColor:(UIColor *)color {
    return [self initWithTitleArray:titleArray itemHeight:Height menuColor:color selectIndex:0 isNeedShowSelectedItem:NO];
}

- (ZHNGooeyMenu *)initWithTitleArray:(NSArray<NSString *> *)titleArray itemHeight:(CGFloat)Height menuColor:(UIColor *)color selectIndex:(NSInteger)index {
    return [self initWithTitleArray:titleArray itemHeight:Height menuColor:color selectIndex:index isNeedShowSelectedItem:YES];
}

- (ZHNGooeyMenu *)initWithTitleArray:(NSArray<NSString *> *)titleArray itemHeight:(CGFloat)Height menuColor:(UIColor *)color selectIndex:(NSInteger)index isNeedShowSelectedItem:(BOOL)isNeed {
    if (self = [super init]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        self.menuColor = color;
        self.matteView.frame = CGRectMake(0, 0, K_Goory_Screen_Width, K_Gooey_Screen_Height);
        
        CGFloat menuHeight = titleArray.count * Height;
        CGFloat entireHeight = menuHeight + KMenu_blank_height + K_Bottom_extra_Height;
        self.frame = CGRectMake(0, K_Gooey_Screen_Height, K_Goory_Screen_Width, entireHeight);
        
        self.assistSideView.frame = CGRectMake(0, entireHeight - 20, 40, 40);
        [self addSubview:self.assistSideView];
        
        self.assistCenterView.frame = CGRectMake(K_Goory_Screen_Width/2, entireHeight - 20, 40, 40);
        [self addSubview:self.assistCenterView];
        
        __weak __typeof__(self) weakSelf = self;
        [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong __typeof(self) strongSelf = weakSelf;
            ZHNGooeyMenuItem *item = [[ZHNGooeyMenuItem alloc]initWithTitle:obj];
            [strongSelf addSubview:item];
            CGFloat itemY = Height * idx + KMenu_blank_height;
            item.frame = CGRectMake(0, itemY, K_Goory_Screen_Width, Height);
            item.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
            item.tag = idx;
            [strongSelf.itemArray addObject:item];
            item.seletAction = ^(NSInteger seletIndex) {
                if (strongSelf.clickHandle) {
                   strongSelf.clickHandle(seletIndex, titleArray[seletIndex]);
                }
            };
            
            if (idx == index) {
                if (strongSelf.isNeedShowSelected) {
                    [item hightlight];
                }
            }
        }];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMenu)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMenu)];
        [self addGestureRecognizer:tap1];
        [self.matteView addGestureRecognizer:tap2];
    }
    return self;
}

- (void)showMenu {
    [KEYWINDOW addSubview:self];
    [KEYWINDOW insertSubview:self.matteView belowSubview:self];

    CGFloat menuHeight = self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, K_Gooey_Screen_Height - menuHeight, K_Goory_Screen_Width, menuHeight);
    }];
    
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha = 1;
        self.matteView.alpha = 1;
    }];
    
    [self p_beforeAnimate];
    [UIView animateWithDuration:0.6 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.assistSideView.frame = CGRectMake(0, -20, 40, 40);
    } completion:^(BOOL finished) {
        [self p_finishAnimate];
    }];
    
    [self p_beforeAnimate];
    [UIView animateWithDuration:0.6 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.assistCenterView.frame = CGRectMake(K_Goory_Screen_Width/2, -20, 40, 40);
    } completion:^(BOOL finished) {
        [self p_finishAnimate];
    }];
    
    [self p_itemAnimate];
}

- (void)dismissMenu {
    CGFloat menuHeight = self.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
         self.frame = CGRectMake(0, K_Gooey_Screen_Height, K_Goory_Screen_Width, menuHeight);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.matteView.alpha = 0;
    }];
    
    [self p_beforeAnimate];
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.assistSideView.frame = CGRectMake(0, menuHeight - 20, 40, 40);
    } completion:^(BOOL finished) {
        [self p_finishAnimate];
    }];
    
    [self p_beforeAnimate];
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.assistCenterView.frame = CGRectMake(K_Goory_Screen_Width/2, menuHeight - 20, 40, 40);
    } completion:^(BOOL finished) {
        [self p_finishAnimate];
    }];
    
    [self p_clearItemStatus];
}

- (void)reloadMenuWitSelectIndex:(NSInteger)index {
    NSAssert(self.isNeedShowSelected, @"menu need init with ‘- (ZHNGooeyMenu *)initWithTitleArray:(NSArray<NSString *> *)titleArray itemHeight:(CGFloat)Height menuColor:(UIColor *)color selectIndex:(NSInteger)index;’ method");
    [self.itemArray enumerateObjectsUsingBlock:^(ZHNGooeyMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            [obj hightlight];
        }
    }];
}

#pragma mark - pravite methods
- (void)p_beforeAnimate {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(p_displayMenu:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animateTag++;
}

- (void)p_finishAnimate {
    self.animateTag--;
    if (self.animateTag == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)p_displayMenu:(CADisplayLink *)link {
    CGRect sideRect = [[[self.assistSideView.layer presentationLayer] valueForKey:@"frame"] CGRectValue];
    CGRect centerRect = [[[self.assistCenterView.layer presentationLayer] valueForKey:@"frame"] CGRectValue];
    self.diff = sideRect.origin.y - centerRect.origin.y;
    [self setNeedsDisplay];
}

- (void)p_itemAnimate {
    [self.itemArray enumerateObjectsUsingBlock:^(ZHNGooeyMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.6 delay:0.05 * idx usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            obj.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)p_clearItemStatus {
    [self.itemArray enumerateObjectsUsingBlock:^(ZHNGooeyMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        [obj normal];
    }];
}

#pragma mark - getters
- (UIImageView *)matteView {
    if (_matteView == nil) {
        _matteView = [[UIImageView alloc]init];
        _matteView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _matteView.alpha = 0;
        _matteView.userInteractionEnabled = YES;
    }
    return _matteView;
}

- (UIImageView *)assistSideView {
    if (_assistSideView == nil) {
        _assistSideView = [[UIImageView alloc]init];
        _assistSideView.backgroundColor = [UIColor clearColor];
    }
    return _assistSideView;
}

- (UIImageView *)assistCenterView {
    if (_assistCenterView == nil) {
        _assistCenterView = [[UIImageView alloc]init];
        _assistCenterView.backgroundColor = [UIColor clearColor];
    }
    return _assistCenterView;
}

- (NSMutableArray *)itemArray {
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end
