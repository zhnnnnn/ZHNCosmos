//
//  ZHNHotSearchCellNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotSearchCellNode.h"
#import "NSAttributedString+ZHNCreate.h"

static CGFloat const KIconSize = 15;
@interface ZHNHotSearchCellNode()
@property (nonatomic,strong) ASNetworkImageNode *numImageNode;
@property (nonatomic,strong) ASNetworkImageNode *tagImageNode;
@property (nonatomic,strong) ASTextNode *searchWordTextNode;
@property (nonatomic,strong) ASTextNode *descExtrTextNode;
@end

@implementation ZHNHotSearchCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.numImageNode];
        [self addSubnode:self.tagImageNode];
        [self addSubnode:self.searchWordTextNode];
        [self addSubnode:self.descExtrTextNode];
        
        @weakify(self);
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            self.cardModel = self.cardModel;
        };
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.numImageNode.style.preferredSize = CGSizeMake(25, 25);
    self.numImageNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    self.tagImageNode.style.preferredSize = CGSizeMake(KIconSize, KIconSize);
    self.tagImageNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    self.descExtrTextNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    self.searchWordTextNode.style.alignSelf = ASStackLayoutAlignSelfCenter;

    ASStackLayoutSpec *leftContentLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    leftContentLayout.children = @[self.numImageNode,self.searchWordTextNode,self.descExtrTextNode];
    leftContentLayout.spacing = 10;
    leftContentLayout.style.flexGrow = 1;
    leftContentLayout.style.flexShrink = 1;
    self.searchWordTextNode.style.flexShrink = 1;
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    contentLayout.children = @[leftContentLayout,self.tagImageNode];
    contentLayout.spacing = 10;
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:contentLayout];
    return insetLayout;
}

- (void)setCardModel:(ZHNHotSearchCardGroupModel *)cardModel {
    _cardModel = cardModel;
    if (!cardModel) {return;}
    self.searchWordTextNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:cardModel.desc font:[UIFont systemFontOfSize:16] textColor:ZHNCurrentThemeFitColorForkey(OriginalCellMainTextColor)];

    self.descExtrTextNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:cardModel.descExtr font:[UIFont systemFontOfSize:13] textColor:ZHNCurrentThemeFitColorForkey(OriginalCellMinorTextColor)];
    
    self.numImageNode.URL = [NSURL URLWithString:cardModel.pic];
    self.tagImageNode.URL = [NSURL URLWithString:cardModel.icon];
}

#pragma mark - getters
- (ASNetworkImageNode *)numImageNode {
    if (_numImageNode == nil) {
        _numImageNode = [[ASNetworkImageNode alloc]init];
        _numImageNode.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _numImageNode;
}

- (ASNetworkImageNode *)tagImageNode {
    if (_tagImageNode == nil) {
        _tagImageNode = [[ASNetworkImageNode alloc]init];
        _tagImageNode.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tagImageNode;
}

- (ASTextNode *)searchWordTextNode {
    if (_searchWordTextNode == nil) {
        _searchWordTextNode = [[ASTextNode alloc]init];
        _searchWordTextNode.maximumNumberOfLines = 1;
    }
    return _searchWordTextNode;
}

- (ASTextNode *)descExtrTextNode {
    if (_descExtrTextNode == nil) {
        _descExtrTextNode = [[ASTextNode alloc]init];
        _descExtrTextNode.maximumNumberOfLines = 1;
    }
    return _descExtrTextNode;
}
@end
