//
//  ZHNScrollingNavigationController.m
//  ZHNScroll
//
//  Created by zhn on 2017/12/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNScrollingNavigationController.h"
#import "ZHNScrollingNavigationController+Sizes.h"
typedef void(^ScrollBlock)(void);
@interface ZHNScrollingNavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UILabel *fakeNaviBarTitleLabel;
@property (nonatomic,strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic,strong) UITabBar *sourceTabBar;

@property (nonatomic,assign) CGFloat delayDistance;
@property (nonatomic,assign) CGFloat maxDelay;
@property (nonatomic,assign) CGFloat lastContentOffset;
@property (nonatomic,assign) CGFloat scrollSpeedFactor;
@property (nonatomic,assign) NavigationBarState previousState;
@end

@implementation ZHNScrollingNavigationController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationBar addSubview:self.fakeNaviBarTitleLabel];
    self.fakeNaviBarTitleLabel.frame = [self _naviTitleLabel].frame;
    self.fakeNaviBarTitleLabel.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fakeNaviBarTitleLabel.hidden = YES;
}

- (instancetype)init {
    if (self = [super init]) {
        self.shouldScrollWhenContentFits = NO;
        self.expandOnActive = YES;
        self.scrollingEnabled = YES;
        
        self.delayDistance = 10;
        self.maxDelay = 0;
        self.lastContentOffset = 0;
        self.scrollSpeedFactor = 1;
        self.previousState = NavigationBarStateExpend;
        self.ignoreRefreshPulling = NO;
    }
    return self;
}

- (void)followScrollViewWithScrollableView:(UIView *)scrollableView naviBarScrollingType:(ZHNNavibarScrollingType)scrollingType delay:(CGFloat)delay scrollSpeedFactor:(CGFloat)scrollSpeedFactor followers:(NSArray<UIView *> *)followers {
    [self stopFollowingScrollView:YES];
    
    self.scrollableView = scrollableView;
    
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    self.gestureRecognizer.maximumNumberOfTouches = 1;
    self.gestureRecognizer.delegate = self;
    [self.scrollableView addGestureRecognizer:self.gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.navibarScrollingType = scrollingType;
    self.maxDelay = delay;
    self.delayDistance = delay;
    self.scrollingEnabled = YES;
    
    self.followers = followers;
    self.scrollSpeedFactor = scrollSpeedFactor;
}

- (void)hideNavbarWithAnimate:(BOOL)animate duration:(NSTimeInterval)duration {
    if (!self.scrollableView || !self.visibleViewController) {return;}
    
    if (self.state == NavigationBarStateExpend) {
        self.state = NavigationBarStateScrolling;
        
        duration = duration ? duration : 0.1;
        [UIView animateWithDuration:duration animations:^{
            [self scrollWithDelta:self.fullNavbarHeight ignoreDelay:NO];
            [self.visibleViewController.view setNeedsLayout];
            if (self.navigationBar.isTranslucent) {
                self.scrollView.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + self.navbarHeight);
            }
        } completion:^(BOOL finished) {
            self.state = NavigationBarStateCollapsed;
        }];
    } else {
        [self updateNavbarAlpha];
    }
}

- (void)showNavbarWithAnimate:(BOOL)animate duration:(NSTimeInterval)duration {
    if (!self.scrollableView || !self.visibleViewController) {return;}
    
    if (self.state == NavigationBarStateCollapsed) {
        self.gestureRecognizer.enabled = NO;
        
        ScrollBlock animations = ^{
            self.lastContentOffset = 0;
            [self scrollWithDelta:-self.fullNavbarHeight ignoreDelay:YES];
            [self.visibleViewController.view setNeedsLayout];
            if (self.navigationBar.isTranslucent) {
                // If want scrollview content`s distance to navibar always same
//                self.scrollView.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - self.navbarHeight);
            }
        };
        
        if (animate) {
            self.state = NavigationBarStateScrolling;
            [UIView animateWithDuration:duration animations:^{
                animations();
            } completion:^(BOOL finished) {
                self.state = NavigationBarStateExpend;
                self.gestureRecognizer.enabled = YES;
            }];
        }else {
            animations();
            self.state = NavigationBarStateExpend;
            self.gestureRecognizer.enabled = YES;
        }
    }else {
        if (!self.transitioning) {
            [self updateNavbarAlpha];
        }
    }
}

- (void)stopFollowingScrollView:(BOOL)showingNavbar {
    if (showingNavbar) {
        [self showNavbarWithAnimate:YES duration:0.1];
    }
    
    [self.scrollableView removeGestureRecognizer:self.gestureRecognizer];
    self.scrollableView = nil;
    self.gestureRecognizer = nil;
    self.scrollingNavbarDelegate = nil;
    self.scrollingEnabled = NO;
    self.lastContentOffset = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateFailed) {
        if (self.ignoreRefreshPulling) {            
            if (self.scrollView.contentOffset.y < -self.scrollView.contentInset.top) {
                return;
            }
        }
        
        CGPoint translation = [gesture translationInView:self.scrollableView.superview];
        CGFloat delta = (self.lastContentOffset - translation.y) / self.scrollSpeedFactor;
        self.lastContentOffset = translation.y;
        if ([self shouldScrollWithDelta:delta]) {
            [self scrollWithDelta:delta ignoreDelay:NO];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        [self checkForPartialScroll];
        self.lastContentOffset = 0;
    }
}

- (void)willResignActive {
    self.previousState = self.state;
}

- (void)didBecomeActive {
    if (self.expandOnActive) {
        [self showNavbarWithAnimate:NO duration:0.1];
    }else {
        if (self.previousState == NavigationBarStateCollapsed) {
            [self hiddenSystemNavibarTitleLabel:NO];
        }
    }
}

- (void)didRotate {
    [self showNavbarWithAnimate:YES duration:0.1];
}

- (void)restoreContentOffset:(CGFloat)delta {
    if (self.navigationBar.isTranslucent || delta == 0) {
        return;
    }
    
    // Hold the scroll steady until the navbar appears/disappears
    [self.scrollView setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - delta) animated:NO];
}

- (void)checkForPartialScroll {
    CGRect frame = self.navigationBar.frame;
    NSTimeInterval duration = 0;
    CGFloat delta = 0;
    
    CGFloat threshold = self.statusBarHeight - (frame.size.height/2);
    if (self.navigationBar.frame.origin.y >= threshold) {
        delta = frame.origin.y - self.statusBarHeight;
        CGFloat distance = delta / (frame.size.height/2);
        duration = fabs(distance * 0.2);
        self.state = NavigationBarStateExpend;
    } else {
        delta = frame.origin.y + self.deltaLimit;
        CGFloat distance = delta / (frame.size.height / 2);
        duration = fabs(distance * 0.2);
        self.state = NavigationBarStateCollapsed;
    }
    
    self.delayDistance = self.maxDelay;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self updateSizing:delta];
        [self updateFollowers:delta];
        [self updateNavbarAlpha];
        [self _transitionFakeNavibar];
    } completion:nil];
}

- (void)updateSizing:(CGFloat)delta {
    if (!self.topViewController) {return;}

    CGRect frame = self.navigationBar.frame;
    
    // Move the navigation bar
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y - delta);
    self.navigationBar.frame = frame;

    // Resize the view if the navigation bar is not translucent
    if (!self.navigationBar.isTranslucent) {
        CGFloat navBarY = self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height;
        frame = self.topViewController.view.frame;
        frame.origin = CGPointMake(frame.origin.x, navBarY);
        frame.size = CGSizeMake(frame.size.width, self.view.frame.size.height - navBarY - self.tabBarOffset);
        self.topViewController.view.frame = frame;
    }
}

- (void)updateFollowers:(CGFloat)delta {
    [self.followers enumerateObjectsUsingBlock:^(UIView  *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![view isKindOfClass:[UITabBar class]]) {
            view.transform = CGAffineTransformMakeTranslation(0, -delta);
            return;
        }
        
        UITabBar *tabbar = (UITabBar *)view;
        tabbar.translucent = YES;
        tabbar.frame = CGRectMake(tabbar.frame.origin.x, tabbar.frame.origin.y + (delta * 1.5), tabbar.frame.size.width, tabbar.frame.size.height);
 
        if (self.sourceTabBar && self.sourceTabBar.frame.origin.y == tabbar.frame.origin.y) {
            tabbar.translucent = self.sourceTabBar.isTranslucent;
        }
    }];
}

- (void)updateNavbarAlpha {
    if (!self.topViewController.navigationItem) {return;}
    
    CGRect frame = self.navigationBar.frame;
    
    // Change the alpha channel of every item on the navbr
    CGFloat alpha = (frame.origin.y + self.deltaLimit) / (frame.size.height - self.residueHeight);
    
    // Hide all the possible titles
    self.navigationItem.titleView.alpha = alpha;
    
    // Hide all possible button items and navigation items
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self shouldHideView:view]) {
            [self setAlphaOfSubviews:view alpha:alpha];
        }
    }];
    
    // Hide the left items
    self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.customView.alpha = alpha;
    }];
    
    // Hide the right items
    self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.customView.alpha = alpha;
    }];
}

- (void)_updateNavibarTitleLabelWithState:(NavigationBarState)state {
    switch (state) {
        case NavigationBarStateCollapsed:
            [self hiddenSystemNavibarTitleLabel:YES];
            break;
        case NavigationBarStateExpend:
            [self hiddenSystemNavibarTitleLabel:NO];
            break;
        case NavigationBarStateScrolling:
            [self hiddenSystemNavibarTitleLabel:YES];
            break;
    }
}

- (void)hiddenSystemNavibarTitleLabel:(BOOL)hidden {
    UILabel *systemLabel = [self _naviTitleLabel];
    systemLabel.hidden = hidden;
    self.fakeNaviBarTitleLabel.hidden = !systemLabel.hidden;
    self.fakeNaviBarTitleLabel.text = systemLabel.text;
}

- (void)reloadFakeNavibarTitleLabelFrame {
    self.fakeNaviBarTitleLabel.frame = [self _naviTitleLabel].frame;
    self.fakeNaviBarTitleLabel.textColor = [self _naviTitleLabel].textColor;
}

- (void)reloadFakeNavibarTitleLabelTextColor {
    self.fakeNaviBarTitleLabel.textColor = [self _naviTitleLabel].textColor;
}

- (void)_transitionFakeNavibar {
    CGRect frame = self.navigationBar.frame;
    CGFloat percent = (frame.origin.y + self.deltaLimit) / (frame.size.height - self.residueHeight);
    CGFloat transMin = 0.4;
    CGFloat positive = [UIScreen mainScreen].bounds.size.height == 812 ? -1 : 1;
    if (percent > transMin) {
        self.fakeNaviBarTitleLabel.transform = CGAffineTransformMakeTranslation(0, positive * (1 - percent) * self.deltaLimit);
    }else {
        CGFloat scale = ((1 - transMin) + percent);
        self.fakeNaviBarTitleLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale) , CGAffineTransformMakeTranslation(0, positive * (1 - percent) * self.deltaLimit));
    }
}

- (BOOL)shouldHideView:(UIView *)view {
    NSString *className = [[[view classForCoder] description] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSMutableArray *viewNames = [@[@"UINavigationButton", @"UINavigationItemView", @"UIImageView", @"UISegmentedControl"] mutableCopy];
    if (@available(iOS 11.0, *)) {
        NSString *contentName = self.navigationBar.prefersLargeTitles ? @"UINavigationBarLargeTitleView" : @"UINavigationBarContentView";
        [viewNames addObject:contentName];
    } else {
        [viewNames addObject:@"UINavigationBarContentView"];
    }
    return [viewNames containsObject:className];
}

- (void)setAlphaOfSubviews:(UIView *)view alpha:(CGFloat)alpha {
    view.alpha = alpha;
    for (UIView *subView in view.subviews) {
        [self setAlphaOfSubviews:subView alpha:alpha];
    }
}

- (BOOL)shouldScrollWithDelta:(CGFloat)delta {
    if (delta < 0) {
        if (self.scrollableView && self.contentOffset.y + self.scrollableView.frame.size.height > self.contentSize.height && self.scrollableView.frame.size.height < self.contentSize.height) {
            return NO;
        }
    }
    return YES;
}

- (void)scrollWithDelta:(CGFloat)delta ignoreDelay:(BOOL)ignoreDelay {
    CGFloat scrollDelta = delta;
    CGRect frame = self.navigationBar.frame;
    
    // View scrolling up, hide the navbar
    if (scrollDelta > 0) {
        // Update the delay
        if (!ignoreDelay) {
            self.delayDistance -= scrollDelta;
            
            // Skip if the delay is not over yet
            if (self.delayDistance > 0) {
                return;
            }
        }
        
        // No need to scroll if the content fits
        if (!self.shouldScrollWhenContentFits && self.state != NavigationBarStateCollapsed && self.scrollableView.frame.size.height >= self.contentSize.height) {
            return;
        }
        
        // Compute the bar position
        if ((frame.origin.y - scrollDelta) < -self.deltaLimit) {
            scrollDelta = frame.origin.y + self. deltaLimit;
        }
        
        // Detect when the bar is completely collapsed
        if (frame.origin.y <= -self.deltaLimit) {
            self.state = NavigationBarStateCollapsed;
            self.delayDistance = self.maxDelay;
        } else {
            self.state = NavigationBarStateScrolling;
        }
    }
    
    if (scrollDelta < 0) {
        // Update the delay
        if (!ignoreDelay) {
            self.delayDistance += scrollDelta;
            
            // Skip if the delay is not over yet
            if (self.delayDistance > 0 && self.maxDelay < self.contentOffset.y) {
                return;
            }
        }
        
        // Compute the bar position
        if ((frame.origin.y - scrollDelta) > self.statusBarHeight) {
            scrollDelta = frame.origin.y - self.statusBarHeight;
        }
        
        // Detect when the bar is completely expanded
        if (frame.origin.y >= self.statusBarHeight) {
            self.state = NavigationBarStateExpend;
            self.delayDistance = self.maxDelay;
        } else {
            self.state = NavigationBarStateScrolling;
        }
    }

    [self updateSizing:scrollDelta];
    [self updateNavbarAlpha];
    [self restoreContentOffset:scrollDelta];
    [self updateFollowers:scrollDelta];
    [self _transitionFakeNavibar];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {return NO;}
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [pan velocityInView:gestureRecognizer.view];
    return fabs(velocity.y) > fabs(velocity.x);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.scrollingEnabled;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - pravite methods
- (UILabel *)_naviTitleLabel {
    for (UIView *navibarSub in self.navigationBar.subviews) {
        if ([NSStringFromClass([navibarSub class]) isEqualToString:@"_UINavigationBarContentView"]) {
            for (UIView *barContentSub in navibarSub.subviews) {
                if ([barContentSub isKindOfClass:[UILabel class]]) {
                    return (UILabel *)barContentSub;
                }
            }
        }
    }
    return nil;
}

#pragma mark - setters
- (void)setState:(NavigationBarState)state {
    [self.scrollingNavbarDelegate scrollingNavigationController:self willChangeState:state];
    _state = state;
    [self.scrollingNavbarDelegate scrollingNavigationController:self didChangeState:state];
    [self _updateNavibarTitleLabelWithState:state];
}

- (UILabel *)fakeNaviBarTitleLabel {
    if (_fakeNaviBarTitleLabel == nil) {
        UILabel *systemTitleLabel = [self _naviTitleLabel];
        _fakeNaviBarTitleLabel = [[UILabel alloc]init];
        _fakeNaviBarTitleLabel.text = systemTitleLabel.text;
        _fakeNaviBarTitleLabel.textColor = systemTitleLabel.textColor;
        _fakeNaviBarTitleLabel.frame = systemTitleLabel.frame;
        _fakeNaviBarTitleLabel.font = systemTitleLabel.font;
        _fakeNaviBarTitleLabel.hidden = YES;
    }
    return _fakeNaviBarTitleLabel;
}

@end
