//
//  ZHNTabbarAnimateManager.h
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHNTabbarAnimateManager : NSObject
/**
 hide tabbar with animate
 */
+ (void)hideAnimate;

/**
 show tabbar with animate
 */
+ (void)showAnimate;

/**
 translate tabbar with percent

 @param percent percent
 */
+ (void)translateWithPercent:(CGFloat)percent;
@end
