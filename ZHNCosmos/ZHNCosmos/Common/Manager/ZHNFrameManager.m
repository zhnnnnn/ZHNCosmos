//
//  ZHNFrameManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNFrameManager.h"

@implementation ZHNFrameManager
+ (CGFloat)zhn_floatFromRect:(CGRect)rect forType:(ZHNFrame)type {
    switch (type) {
        case ZHNFrame_left:
        {
            return rect.origin.x;
        }
            break;
        case ZHNFrame_right:
        {
            return CGRectGetMaxX(rect);
        }
            break;
        case ZHNFrame_top:
        {
            return rect.origin.y;
        }
            break;
        case ZHNFrame_bottom:
        {
            return CGRectGetMaxY(rect);
        }
            break;
        case ZHNFrame_centerx:
        {
            return CGRectGetMidX(rect);
        }
            break;
        case ZHNFrame_centery:
        {
            return CGRectGetMidY(rect);
        }
            break;
    }
}
@end
