//
//  UITableView+ZHNVerticalScrollIndicator.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZHNVerticalScrollIndicator)
- (void)zhn_showCustomScrollIndicatorWithoriginalDelegate:(id)originalDelegate indicatorColor:(UIColor *)color;
@end
