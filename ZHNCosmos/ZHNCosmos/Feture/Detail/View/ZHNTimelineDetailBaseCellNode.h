//
//  ZHNTimelineCommentsCell.h
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNTimelineModel.h"
#import "ZHNTimelineDetailHeadNode.h"

@interface ZHNTimelineDetailBaseCellNode : ASCellNode
@property (nonatomic,strong) ZHNTimelineStatus *status;
@property (nonatomic,strong) ZHNTimelineDetailHeadNode *headeNode;
@end
