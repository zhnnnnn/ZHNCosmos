//
//  ZHNStripedBarManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNStripedBarManager : NSObject
+ (void)zhn_animateShowStripedBarToProgress:(CGFloat)progress;
+ (void)zhn_animateFinish;
+ (void)zhn_setProgress:(CGFloat)progress animate:(BOOL)animate;
@end
