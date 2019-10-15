//
//  ZHNFrameManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZHNFloat(frame,type) [ZHNFrameManager zhn_floatFromRect:frame forType:type]
typedef NS_ENUM(NSInteger,ZHNFrame) {
    ZHNFrame_left,
    ZHNFrame_right,
    ZHNFrame_top,
    ZHNFrame_bottom,
    ZHNFrame_centerx,
    ZHNFrame_centery,
};
@interface ZHNFrameManager : NSObject
+ (CGFloat)zhn_floatFromRect:(CGRect)rect forType:(ZHNFrame)type;
@end
