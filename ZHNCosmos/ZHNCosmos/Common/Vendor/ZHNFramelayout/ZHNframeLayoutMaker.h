//
//  ZHNframeLayoutMaker.h
//  ZHNframeLayout
//
//  Created by zhn on 16/4/22.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHNframeLayoutMaker : NSObject
//判断上下左右
- (ZHNframeLayoutMaker *)left;
- (ZHNframeLayoutMaker *)right;
- (ZHNframeLayoutMaker *)top;
- (ZHNframeLayoutMaker *)bottom;
- (ZHNframeLayoutMaker *)height;
- (ZHNframeLayoutMaker *)width;
- (ZHNframeLayoutMaker *)center;
- (ZHNframeLayoutMaker *)centerX;
- (ZHNframeLayoutMaker *)centerY;

// 设置left之类的需要拿到父控件 高度之类不需要父控件的用zhn_eaqualTo
- (ZHNframeLayoutMaker *(^)(CGFloat))eaqualTo;
- (void(^)(CGFloat))zhn_eaqualTo;

//实例化方法
- (instancetype)initWithSupView:(UIView *)view;

// 设置offset
- (void(^)(CGFloat))withOffset;

// 返回一个frame
- (CGRect)getViewFrame;
@end
