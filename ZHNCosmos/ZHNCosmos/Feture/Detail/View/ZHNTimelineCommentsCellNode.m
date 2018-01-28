//
//  ZHNTimelineCommentsCellNode.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineCommentsCellNode.h"
#import "ZHNYYRouterLabel.h"

@interface ZHNTimelineCommentsCellNode()
@property (nonatomic,strong) ASDisplayNode *moreBackNode;
@property (nonatomic,strong) ASTextNode *moreTextNode;
@end

@implementation ZHNTimelineCommentsCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.moreBackNode];
        [self addSubnode:self.moreTextNode];
        self.headeNode.headType = ZHNDetailHeadTypeComments;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *superLayout = [super layoutSpecThatFits:constrainedSize];

    if (!self.comment.moreInfo) {
        ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 10, 0) child:superLayout];
        return insetLayout;
    }else {
        self.moreTextNode.style.spacingBefore = 10;
        ASStackLayoutSpec *textLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
        textLayout.child = self.moreTextNode;
        textLayout.alignItems = ASStackLayoutAlignItemsCenter;
        
        ASInsetLayoutSpec *insetTextLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 0, 10, 0) child:textLayout];
        
        ASOverlayLayoutSpec *overLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:insetTextLayout overlay:self.moreBackNode];
        
        ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 60, 10, 20) child:overLayout];
        
        ASStackLayoutSpec *vLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
        vLayout.children = @[superLayout,insetLayout];
        
        return vLayout;
    }
}

#pragma mark - setters
- (void)setComment:(ZHNTimelineComment *)comment {
    _comment = comment;
    self.status = comment;
    if (comment.moreText) {
        [(YYLabel *)self.moreTextNode.view setAttributedText:comment.moreText];
        self.moreTextNode.style.preferredSize = comment.moreTextPreSize;
    }
    self.headeNode.likeCount = comment.likeCounts;
}

#pragma mark - getters
- (ASDisplayNode *)moreBackNode {
    if (_moreBackNode == nil) {
        _moreBackNode = [[ASDisplayNode alloc]init];
        _moreBackNode.backgroundColor = ZHNCurrentThemeFitColorForkey(DetailCellMoreViewColor);
        _moreBackNode.layer.cornerRadius = 3;
    }
    return _moreBackNode;
}

- (ASTextNode *)moreTextNode {
    if (_moreTextNode == nil) {
        _moreTextNode = [[ASTextNode alloc]initWithViewBlock:^UIView * _Nonnull{
            ZHNYYRouterLabel *label = [[ZHNYYRouterLabel alloc]init];
            label.displaysAsynchronously = YES;
            label.numberOfLines = 0;
            return label;
        }];
        _moreTextNode.maximumNumberOfLines = 0;
        _moreTextNode.userInteractionEnabled = YES;
    }
    return _moreTextNode;
}
@end
