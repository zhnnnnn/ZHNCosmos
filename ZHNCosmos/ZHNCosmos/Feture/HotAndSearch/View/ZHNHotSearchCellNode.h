//
//  ZHNHotSearchCellNode.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNHotSearchModel.h"
#import "ZHNSelectColorFitNightVersionCellNode.h"

@interface ZHNHotSearchCellNode : ZHNSelectColorFitNightVersionCellNode
@property (nonatomic,strong) ZHNHotSearchCardGroupModel *cardModel;
@end
