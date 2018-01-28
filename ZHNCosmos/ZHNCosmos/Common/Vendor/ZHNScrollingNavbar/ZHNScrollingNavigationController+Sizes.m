//
//  ZHNScrollingNavigationController+Sizes.m
//  ZHNScroll
//
//  Created by zhn on 2017/12/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNScrollingNavigationController+Sizes.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation ZHNScrollingNavigationController (Sizes)
#pragma mark - getters
- (CGFloat)fullNavbarHeight {
    return self.navbarHeight + self.statusBarHeight;
}

- (CGFloat)navbarHeight {
    return self.navigationBar.frame.size.height;
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height - self.extendedStatusBarDifference;
}

- (CGFloat)extendedStatusBarDifference {
    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
    if (!screenHeight) {
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return fabs(self.view.bounds.size.height - screenHeight);
}

- (CGFloat)tabBarOffset {
    return self.tabBarController.tabBar.isTranslucent ? 0 : self.tabBarController.tabBar.frame.size.height;
}

- (CGPoint)contentOffset {
    return self.scrollView.contentOffset;
}

- (CGSize)contentSize {
    if (!self.scrollView) {
        return CGSizeZero;
    }
    CGFloat verticalInset = self.scrollView.contentInset.top + self.scrollView.contentInset.bottom;
    return CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + verticalInset);
}

- (CGFloat)deltaLimit {
    return self.navbarHeight - self.statusBarHeight - self.residueHeight;
}

- (CGFloat)residueHeight {
    switch (self.navibarScrollingType) {
        case ZHNNavibarScrollingTypeScrollingLikeSafari:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}

- (UIScrollView *)scrollView {
    if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
        return [(UIWebView *)self.scrollableView scrollView];
    }else if ([self.scrollableView isKindOfClass:[WKWebView class]]) {
        return [(WKWebView *)self.scrollableView scrollView];
    }else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.scrollableView;
    }else {
        return nil;
    }
}

- (void)setNavibarScrollingType:(ZHNNavibarScrollingType)navibarScrollingType {
    objc_setAssociatedObject(self, @selector(navibarScrollingType), @(navibarScrollingType), OBJC_ASSOCIATION_ASSIGN);
}

- (ZHNNavibarScrollingType)navibarScrollingType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
@end
#pragma clang diagnostic pop
