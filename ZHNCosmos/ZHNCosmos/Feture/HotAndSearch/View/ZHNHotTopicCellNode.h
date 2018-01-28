//
//  ZHNHotTopicCellNode.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNHotTopicModel.h"
#import "ZHNSelectColorFitNightVersionCellNode.h"

@interface ZHNHotTopicCellNode : ZHNSelectColorFitNightVersionCellNode
@property (nonatomic,strong) ZHNHotTopicModel *topicModel;
@property (nonatomic,assign) NSInteger tagIndex;
@end
