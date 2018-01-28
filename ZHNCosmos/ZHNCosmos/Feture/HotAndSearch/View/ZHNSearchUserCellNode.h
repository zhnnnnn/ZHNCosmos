//
//  ZHNSearchUserCellNode.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNTimelineModel.h"
#import "ZHNSelectColorFitNightVersionCellNode.h"

@interface ZHNSearchUserCellNode : ZHNSelectColorFitNightVersionCellNode
@property (nonatomic,strong) ZHNTimelineUser *user;
@end
