//
//  ZHNTransitionHeader.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ZHNScrollDirection) {
    ZHNScrollDirectionTop,
    ZHNScrollDirectionBottom,
    ZHNScrollDirectionLeft,
    ZHNScrollDirectionRight
};
typedef void(^transitionHandle)();
@interface ZHNTransitionManager : UIView
@property (nonatomic,assign) ZHNScrollDirection direction;
@property (nonatomic,assign) CGFloat pointerMarging;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) transitionHandle handle;
@end
