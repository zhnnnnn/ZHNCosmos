//
//  UIScrollView+ZHNTransitionManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIScrollView+ZHNTransitionManager.h"
#import <objc/runtime.h>
static CGFloat const KHeaderHeight = 50;

@implementation UIScrollView (ZHNTransitionManager)
- (void)zhn_needTransitionManagerWithDirection:(ZHNScrollDirection)direction pointerMarging:(CGFloat)marging transitonHanldle:(void (^)())handle{
    ZHNTransitionManager *header = [[ZHNTransitionManager alloc]init];
    header.direction = direction;
    header.scrollView = self;
    header.handle = handle;
    header.pointerMarging = marging;
    [self addSubview:header];
    switch (direction) {
        case ZHNScrollDirectionTop:
            header.frame = CGRectMake(0, -KHeaderHeight, K_SCREEN_WIDTH, KHeaderHeight);
            break;
        case ZHNScrollDirectionBottom:
            header.frame = CGRectMake(0, self.contentSize.height, K_SCREEN_WIDTH, KHeaderHeight);
            break;
        case ZHNScrollDirectionRight:
            header.frame = CGRectMake(-KHeaderHeight, 0, KHeaderHeight, K_SCREEN_HEIGHT);
            break;
        case ZHNScrollDirectionLeft:
            header.frame = CGRectMake(self.contentSize.width, 0, KHeaderHeight, K_SCREEN_HEIGHT);
            break;
    }
}
@end
