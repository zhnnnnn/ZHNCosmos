//
//  ZHNLoginLoading.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/18.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNLoginLoading : UIView
- (instancetype)initWithCycleSize:(CGFloat)size cycleColor:(UIColor *)Color;
- (void)startAnimate;
@end
