//
//  ZHNTimelineDetailHeadNode.h
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNTimelineModel.h"

typedef NS_ENUM(NSInteger,ZHNDetailHeadType) {
    ZHNDetailHeadTypeTransmit,
    ZHNDetailHeadTypeComments
};
@interface ZHNTimelineDetailHeadNode : ASDisplayNode
@property (nonatomic,strong) ZHNTimelineStatus *status;
@property (nonatomic,assign) ZHNDetailHeadType headType;
@property (nonatomic,copy) NSString *likeCount;
@end
