//
//  UIView+ZHNFirework.h
//  ZHNFireworks
//
//  Created by zhn on 2017/9/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHNFirework)<CAAnimationDelegate>
- (void)fireInTheHole;
@end

///////////////////////////////////////////////////// pravite
@interface ZHNFireView : UIView
- (void)zhn_animateIsDirectionLeft:(BOOL)isDirectionLeft;
@end
