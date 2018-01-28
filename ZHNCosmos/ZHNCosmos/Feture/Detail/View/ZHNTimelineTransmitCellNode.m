//
//  ZHNTimelineTransmitCellNode.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineTransmitCellNode.h"
#import "ZHNTimelineTransmitToolNode.h"

@interface ZHNTimelineTransmitCellNode()
@property (nonatomic,strong) ZHNTimelineTransmitToolNode *toolNode;
@end

@implementation ZHNTimelineTransmitCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.toolNode];
        self.headeNode.headType = ZHNDetailHeadTypeTransmit;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *superLayout = [super layoutSpecThatFits:constrainedSize];

    ASStackLayoutSpec *toolLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    toolLayout.justifyContent = ASStackLayoutJustifyContentEnd;
    toolLayout.child = self.toolNode;
    
    ASInsetLayoutSpec *toolInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 10, 20) child:toolLayout];
    
    ASStackLayoutSpec *vLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    vLayout.children = @[superLayout,toolInsetLayout];
    return vLayout;
}

- (void)setStatus:(ZHNTimelineStatus *)status {
    [super setStatus:status];
    self.toolNode.transimitCount = status.repostsCount;
    self.toolNode.commentsCount = status.commentsCount;
}

- (ZHNTimelineTransmitToolNode *)toolNode {
    if (_toolNode == nil) {
        _toolNode = [[ZHNTimelineTransmitToolNode alloc]init];
    }
    return _toolNode;
}
@end

