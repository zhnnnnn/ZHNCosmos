//
//  UIViewController+ZHNCosmosNavibarAlpha.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZHNCosmosNavibarAlpha)
@property (nonatomic,assign) CGFloat zhn_navibarAlpha;
@end

/////////////////////////////////////////////////////
typedef void(^ZHNNavibarAlphaDeallocHandle)();
@interface ZHNNavibarAlphaDeallocer : NSObject
@property (nonatomic,copy) ZHNNavibarAlphaDeallocHandle handle;
+ (instancetype)zhn_deallocerWithHandle:(ZHNNavibarAlphaDeallocHandle)handle;
@end
