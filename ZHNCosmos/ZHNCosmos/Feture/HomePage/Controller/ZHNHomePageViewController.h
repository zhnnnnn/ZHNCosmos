//
//  ZHNHomePageViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineBaseViewController.h"

@interface ZHNHomePageViewController : ZHNMagicTransitionBaseViewController
@property (nonatomic,copy) NSString *userScreenName;
@property (nonatomic,strong) ZHNTimelineUser *homepageUser;
@end
