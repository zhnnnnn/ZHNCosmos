//
//  ZHNTimelineDetailViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNMagicTransitionBaseViewController.h"
#import "ZHNTimelineLayoutModel.h"
typedef NS_ENUM(NSInteger,ZHNDefaultShowType) {
    ZHNDefaultShowTypeTransmit = 0,
    ZHNDefaultShowTypeDetail = 1,
    ZHNDefaultShowTypeComments = 2
};
@interface ZHNTimelineDetailContainViewController : ZHNMagicTransitionBaseViewController
@property (nonatomic,strong) ZHNTimelineStatus *status;
@property (nonatomic,assign) ZHNDefaultShowType defaultType;
@end
