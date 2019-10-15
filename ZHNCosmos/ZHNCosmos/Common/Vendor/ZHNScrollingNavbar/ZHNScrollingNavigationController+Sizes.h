//
//  ZHNScrollingNavigationController+Sizes.h
//  ZHNScroll
//
//  Created by zhn on 2017/12/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNScrollingNavigationController.h"
#import "ZHNScrollingNavigationController.h"

@interface ZHNScrollingNavigationController (Sizes)
// Config
@property (nonatomic,assign) CGFloat fullNavbarHeight;
@property (nonatomic,assign) CGFloat navbarHeight;
@property (nonatomic,assign) CGFloat statusBarHeight;
@property (nonatomic,assign) CGFloat extendedStatusBarDifference;
@property (nonatomic,assign) CGFloat tabBarOffset;
@property (nonatomic,assign) CGPoint contentOffset;
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,assign) CGFloat deltaLimit;
@property (nonatomic,assign) CGFloat residueHeight;
- (UIScrollView *)scrollView;
// Hide type
@property (nonatomic,assign) ZHNNavibarScrollingType navibarScrollingType;
@end
