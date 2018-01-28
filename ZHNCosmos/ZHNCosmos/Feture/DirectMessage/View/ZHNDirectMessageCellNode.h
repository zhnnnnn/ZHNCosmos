//
//  ZHNDirectMessageCellNode.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/21.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNDirectMessageModel.h"
#import "ZHNSelectColorFitNightVersionCellNode.h"

@interface ZHNDirectMessageCellNode : ZHNSelectColorFitNightVersionCellNode
@property (nonatomic,strong) ZHNDirectMessageModel *messageModel;
@end
