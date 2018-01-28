//
//  UIScrollView+ZHNTransitionManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTransitionManager.h"

@interface UIScrollView (ZHNTransitionManager)
- (void)zhn_needTransitionManagerWithDirection:(ZHNScrollDirection)direction
                                pointerMarging:(CGFloat)marging
                              transitonHanldle:(void(^)())handle;
@end
