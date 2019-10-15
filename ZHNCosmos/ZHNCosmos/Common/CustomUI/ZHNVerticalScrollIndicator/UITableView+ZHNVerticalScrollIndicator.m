//
//  UITableView+ZHNVerticalScrollIndicator.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UITableView+ZHNVerticalScrollIndicator.h"
#import "ZHNVerticalScrollIndicator.h"
#import <objc/runtime.h>
#import "ZHNDelegateSplitter.h"
#import "ZHNTimer.h"
static CGFloat const KIndicatorPadding = 10;
@interface UITableView()<UITableViewDelegate>
@property (nonatomic,assign) BOOL showCustomScrollIndicator;
@property (nonatomic,strong) ZHNVerticalScrollIndicator *customScrollIndicator;
@property (nonatomic,strong) ZHNDelegateSplitter *delegateSplitter;
@property (nonatomic,strong) ZHNTimer *dismissTimer;
@property (nonatomic,strong) UIColor *indicatorColor;
@end

@implementation UITableView (ZHNVerticalScrollIndicator)
- (void)zhn_showCustomScrollIndicatorWithoriginalDelegate:(id)originalDelegate indicatorColor:(UIColor *)color{
    self.delegate = originalDelegate;
    self.showCustomScrollIndicator = YES;
    self.indicatorColor = color;
    self.customScrollIndicator.backgroundColor = color;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self p_translateIndicator];
}

#pragma mark - delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate isEqual:self]) {return;}
    [self.dismissTimer invalidate];
    if (self.customScrollIndicator) {
        [self p_showIndicator];
    }else {
        ZHNVerticalScrollIndicator *customScrollIndicator = [[ZHNVerticalScrollIndicator alloc]init];
        self.customScrollIndicator = customScrollIndicator;
        self.customScrollIndicator.index = 0;
        CGFloat customCenterX = self.frame.size.width - (customScrollIndicator.frame.size.width - customScrollIndicator.frame.size.height)/2;
        customScrollIndicator.center = CGPointMake(customCenterX, 0);
        [self addSubview:customScrollIndicator];
        customScrollIndicator.transform = CGAffineTransformMakeTranslation(customScrollIndicator.frame.size.width, 0);
        customScrollIndicator.backgroundColor = self.indicatorColor;
        [self p_showIndicator];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self p_translateIndicator];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self p_reloadTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self p_reloadTimer];
    }
}

- (void)p_reloadTimer {
    [self.dismissTimer invalidate];
    @weakify(self);
    self.dismissTimer = [ZHNTimer zhn_timerWIthTimeInterval:2.5 repeats:NO handler:^{
        @strongify(self);
        [self p_dismissIndicator];
    }];
    [self.dismissTimer fire];
}

- (void)p_showIndicator {
    [UIView animateWithDuration:0.5 animations:^{
        self.customScrollIndicator.transform = CGAffineTransformIdentity;
    }];
}

- (void)p_dismissIndicator {
    [UIView animateWithDuration:0.5 animations:^{
        self.customScrollIndicator.transform = CGAffineTransformMakeTranslation(self.customScrollIndicator.frame.size.width, 0);
    }];
}

- (void)p_translateIndicator {
    CGFloat translateY = self.contentOffset.y + self.contentInset.top;
    CGFloat maxOffsetY = self.contentSize.height + self.contentInset.bottom + self.contentInset.top  - self.frame.size.height;
    CGFloat percent = translateY/maxOffsetY;
    CGFloat translate = percent * (self.frame.size.height - (self.contentInset.top + self.contentInset.bottom + KIndicatorPadding));
    self.customScrollIndicator.center = CGPointMake(self.customScrollIndicator.center.x, translate + translateY + KIndicatorPadding);
    // Show index in indicator
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:self.customScrollIndicator.center];
    if (self.frame.size.height + self.contentOffset.y > self.contentSize.height && indexPath.row == 0) {return;}
    self.customScrollIndicator.index = indexPath.row;
}

#pragma mark - property
- (void)setCustomScrollIndicator:(ZHNVerticalScrollIndicator *)customScrollIndicator {
    objc_setAssociatedObject(self, @selector(customScrollIndicator), customScrollIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHNVerticalScrollIndicator *)customScrollIndicator {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setShowCustomScrollIndicator:(BOOL)showCustomScrollIndicator {
    if (showCustomScrollIndicator) {
        id originalDelegate = self.delegate;
        self.delegateSplitter = [ZHNDelegateSplitter zhn_delegateSplitterWithDelegateOne:originalDelegate delegateTwo:self];
        self.delegate = (id)self.delegateSplitter;
    }
    objc_setAssociatedObject(self, @selector(showCustomScrollIndicator), @(showCustomScrollIndicator), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)showCustomScrollIndicator {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDelegateSplitter:(ZHNDelegateSplitter *)delegateSplitter {
    objc_setAssociatedObject(self, @selector(delegateSplitter), delegateSplitter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHNDelegateSplitter *)delegateSplitter {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDismissTimer:(ZHNTimer *)dismissTimer {
    objc_setAssociatedObject(self, @selector(dismissTimer), dismissTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHNTimer *)dismissTimer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    objc_setAssociatedObject(self, @selector(indicatorColor), indicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)indicatorColor {
    return objc_getAssociatedObject(self, _cmd);
}
@end

