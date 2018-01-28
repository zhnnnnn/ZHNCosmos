//
//  ZHNTimelineTransmitToolNode.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineTransmitToolNode.h"
#import "NSAttributedString+ZHNCreate.h"

@interface ZHNTimelineTransmitToolNode()
@property (nonatomic,strong) ASImageNode *transmitIconNode;
@property (nonatomic,strong) ASImageNode *commentsIconNode;
@property (nonatomic,strong) ASTextNode *transmitTextNode;
@property (nonatomic,strong) ASTextNode *commentsTextNode;
@end

@implementation ZHNTimelineTransmitToolNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.transmitIconNode];
        [self addSubnode:self.transmitTextNode];
        [self addSubnode:self.commentsIconNode];
        [self addSubnode:self.commentsTextNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.transmitIconNode.style.preferredSize = CGSizeMake(13, 13);
    self.commentsIconNode.style.preferredSize = CGSizeMake(13, 13);
    
    ASStackLayoutSpec *transLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    transLayout.children = @[self.transmitIconNode,self.transmitTextNode];
    transLayout.spacing = 5;
    
    ASStackLayoutSpec *commentsLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    commentsLayout.children = @[self.commentsIconNode,self.commentsTextNode];
    commentsLayout.spacing = 5;
    
    ASStackLayoutSpec *containerLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    containerLayout.children = @[transLayout,commentsLayout];
    containerLayout.spacing = 30;
    
    return containerLayout;
}

#pragma mark - setters
- (void)setTransimitCount:(NSInteger)transimitCount {
    _transimitCount = transimitCount;
    self.transmitTextNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:[NSString stringWithFormat:@"%ld",transimitCount] font:[UIFont systemFontOfSize:12] textColor:ZHNHexColor(@"aab8c1")];
}

- (void)setCommentsCount:(NSInteger)commentsCount {
    _commentsCount = commentsCount;
    self.commentsTextNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:[NSString stringWithFormat:@"%ld",commentsCount] font:[UIFont systemFontOfSize:12] textColor:ZHNHexColor(@"aab8c1")];
}

#pragma mark - getter
- (ASImageNode *)transmitIconNode {
    if (_transmitIconNode == nil) {
        _transmitIconNode = [[ASImageNode alloc]init];
        _transmitIconNode.image = [[UIImage imageNamed:@"weibostatus_retweet_2"] imageWithTintColor:ZHNHexColor(@"aab8c1")];
        _transmitIconNode.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _transmitIconNode;
}

- (ASImageNode *)commentsIconNode {
    if (_commentsIconNode == nil) {
        _commentsIconNode = [[ASImageNode alloc]init];
        _commentsIconNode.image = [[UIImage imageNamed:@"weibostatus_comment_2"] imageWithTintColor:ZHNHexColor(@"aab8c1")];
        _commentsIconNode.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _commentsIconNode;
}

- (ASTextNode *)transmitTextNode {
    if (_transmitTextNode == nil) {
        _transmitTextNode = [[ASTextNode alloc]init];
        _transmitTextNode.attributedText = [[NSAttributedString alloc]initWithString:@"12"];
    }
    return _transmitTextNode;
}

- (ASTextNode *)commentsTextNode {
    if (_commentsTextNode == nil) {
        _commentsTextNode = [[ASTextNode alloc]init];
        _commentsTextNode.attributedText = [[NSAttributedString alloc]initWithString:@"22"];
    }
    return _commentsTextNode;
}
@end
