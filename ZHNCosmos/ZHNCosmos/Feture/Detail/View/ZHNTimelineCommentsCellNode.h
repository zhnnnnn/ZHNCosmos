//
//  ZHNTimelineCommentsCellNode.h
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailBaseCellNode.h"
#import "ZHNTimelineComment.h"

@interface ZHNTimelineCommentsCellNode : ZHNTimelineDetailBaseCellNode
@property (nonatomic,strong) ZHNTimelineComment *comment;
@end
