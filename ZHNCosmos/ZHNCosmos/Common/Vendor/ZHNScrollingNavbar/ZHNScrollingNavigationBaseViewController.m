//
//  ZHNScrollingNavigationBaseViewController.m
//  ZHNScroll
//
//  Created by zhn on 2017/12/15.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNScrollingNavigationBaseViewController.h"
#import "ZHNScrollingNavigationController.h"

@interface ZHNScrollingNavigationBaseViewController ()<UINavigationControllerDelegate,UIScrollViewDelegate>

@end

@implementation ZHNScrollingNavigationBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        ZHNScrollingNavigationController *naviController = (ZHNScrollingNavigationController *)self.navigationController;
        [naviController showNavbarWithAnimate:YES duration:0.1];
        [naviController hiddenSystemNavibarTitleLabel:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        ZHNScrollingNavigationController *naviController = (ZHNScrollingNavigationController *)self.navigationController;
        [naviController reloadFakeNavibarTitleLabelFrame];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        ZHNScrollingNavigationController *naviController = (ZHNScrollingNavigationController *)self.navigationController;
        naviController.transitioning = YES;
        [naviController stopFollowingScrollView:YES];
        [naviController hiddenSystemNavibarTitleLabel:NO];
        [naviController reloadFakeNavibarTitleLabelFrame];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        ZHNScrollingNavigationController *naviController = (ZHNScrollingNavigationController *)self.navigationController;
        naviController.transitioning = NO;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        ZHNScrollingNavigationController *naviController = (ZHNScrollingNavigationController *)self.navigationController;
        [naviController showNavbarWithAnimate:YES duration:0.1];
    }
    return YES;
}

@end
