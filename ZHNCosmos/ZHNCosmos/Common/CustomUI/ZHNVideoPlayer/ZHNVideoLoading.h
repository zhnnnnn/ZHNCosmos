//
//  ZHNVideoLoading.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNVideoLoading : UIView
+ (instancetype)zhn_createLoadForColor:(UIColor *)color;
- (void)zhn_loading;
- (void)zhn_endLoading;
@end
