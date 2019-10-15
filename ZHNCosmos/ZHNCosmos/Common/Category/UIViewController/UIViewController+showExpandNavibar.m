//
//  UIViewController+showExpandNavibar.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIViewController+showExpandNavibar.h"
#import "ZHNScrollingNavigationController.h"

@implementation UIViewController (showExpandNavibar)
- (void)zhn_showExpandNavibarIfNeed {
    if ([self.navigationController isKindOfClass:[ZHNScrollingNavigationController class]]) {
        [(ZHNScrollingNavigationController *)self.navigationController showNavbarWithAnimate:YES duration:0.1];
    }
}
@end
