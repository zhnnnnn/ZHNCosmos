//
//  ZHNCosmosTabbarController.h
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNCosmosTabbar.h"
@interface ZHNCosmosTabbarController : UIViewController
/** tabbar */
@property (nonatomic,strong) ZHNCosmosTabbar *tabbar;
/** selected controller */
@property (nonatomic,strong,readonly) UIViewController *selectedController;
@end
