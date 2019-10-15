//
//  ZHNTimelineCommentsCell.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailBaseCellNode.h"
#import "ZHNYYRouterLabel.h"

@interface ZHNTimelineDetailBaseCellNode()
@property (nonatomic,strong) ASTextNode *contentTextNode;
@end

@implementation ZHNTimelineDetailBaseCellNode
- (instancetype)init {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
        [self addSubnode:self.headeNode];
        [self addSubnode:self.contentTextNode];
        self.backgroundColor = ZHNCurrentThemeFitColorForkey(CellBG);
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec *contentInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 60, 0, 20) child:self.contentTextNode];
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    contentLayout.children = @[self.headeNode,contentInsetLayout];

    return contentLayout;
}

#pragma mark - setters
- (void)setStatus:(ZHNTimelineStatus *)status {
    _status = status;
    YYLabel *contentLabel = (YYLabel *)self.contentTextNode.view;
    contentLabel.attributedText = [NSAttributedString yy_unarchiveFromData:status.richTextData];
    self.contentTextNode.style.preferredSize = status.richTextPreferredSize;
    self.headeNode.status = status;
}

#pragma mark - getters
- (ZHNTimelineDetailHeadNode *)headeNode {
    if (_headeNode == nil) {
        _headeNode = [[ZHNTimelineDetailHeadNode alloc]init];
    }
    return _headeNode;
}

- (ASTextNode *)contentTextNode {
    if (_contentTextNode == nil) {
        _contentTextNode = [[ASTextNode alloc]initWithViewBlock:^UIView * _Nonnull{
            ZHNYYRouterLabel *label = [[ZHNYYRouterLabel alloc]init];
            return label;
        }];
        _contentTextNode.maximumNumberOfLines = 0;
        _contentTextNode.userInteractionEnabled = YES;
    }
    return _contentTextNode;
}
@end
