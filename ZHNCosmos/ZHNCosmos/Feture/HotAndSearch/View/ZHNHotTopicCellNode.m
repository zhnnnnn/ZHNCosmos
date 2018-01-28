//
//  ZHNHotTopicCellNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotTopicCellNode.h"
#import "NSAttributedString+ZHNCreate.h"

@interface ZHNHotTopicCellNode()
@property (nonatomic,strong) ASNetworkImageNode *imageNode;
@property (nonatomic,strong) ASTextNode *titleNode;
@property (nonatomic,strong) ASTextNode *descNode;
@property (nonatomic,strong) ASTextNode *dataNode;
@property (nonatomic,strong) ASTextNode *tagNode;
@end

@implementation ZHNHotTopicCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.imageNode];
        [self addSubnode:self.titleNode];
        [self addSubnode:self.descNode];
        [self addSubnode:self.dataNode];
        [self addSubnode:self.tagNode];
        
        @weakify(self);
        self.extraThemeColorChangeHandle = ^{
            @strongify(self);
            self.tagNode.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
        };
        
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            self.topicModel = self.topicModel;
        };
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.imageNode.style.preferredSize = CGSizeMake(70, 70);
    
    ASStackLayoutSpec *textLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    textLayout.spacing = 5;
    textLayout.children = @[self.titleNode,self.descNode,self.dataNode];
    textLayout.style.flexShrink = 1;
    textLayout.style.flexGrow = 1;

    self.tagNode.style.preferredSize = CGSizeMake(20, 15);
    self.tagNode.style.layoutPosition = CGPointMake(3, 3);
    ASAbsoluteLayoutSpec *abLayout = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.tagNode]];
    ASOverlayLayoutSpec *overLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.imageNode overlay:abLayout];
    
    ASStackLayoutSpec *horLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    horLayout.spacing = 10;
    horLayout.children = @[overLayout,textLayout];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:horLayout];
    return insetLayout;
}

#pragma mark - setters
- (void)setTopicModel:(ZHNHotTopicModel *)topicModel {
    _topicModel = topicModel;
    if (!topicModel) {return;}
    UIColor *titleColor = DKColorPickerWithColors(ZHNHexColor(@"000000"),ZHNHexColor(@"d8d8d8"))([[DKNightVersionManager sharedManager] themeVersion]);
    self.titleNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:topicModel.titleSub font:[UIFont systemFontOfSize:17] textColor:titleColor];
    
    UIColor *descColor = DKColorPickerWithColors(ZHNHexColor(@"6d6d6d"),ZHNHexColor(@"686868"))([[DKNightVersionManager sharedManager] themeVersion]);
    self.descNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:topicModel.desc1 font:[UIFont systemFontOfSize:13] textColor:descColor];
    
    UIColor *dataColor = DKColorPickerWithColors(ZHNHexColor(@"bcbcbc"),ZHNHexColor(@"d8d8d8"))([[DKNightVersionManager sharedManager] themeVersion]);
    self.dataNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:topicModel.desc2 font:[UIFont systemFontOfSize:15] textColor:dataColor];
    
    self.imageNode.URL = [NSURL URLWithString:topicModel.pic];
}

- (void)setTagIndex:(NSInteger)tagIndex {
    _tagIndex = tagIndex;
    [(UILabel *)self.tagNode.view setText:[NSString stringWithFormat:@"%ld",tagIndex + 1]];
}

#pragma mark - getters
- (ASNetworkImageNode *)imageNode {
    if (_imageNode == nil) {
        _imageNode = [[ASNetworkImageNode alloc]init];
        _imageNode.cornerRadius = 5;
    }
    return _imageNode;
}

- (ASTextNode *)titleNode {
    if (_titleNode == nil) {
        _titleNode = [[ASTextNode alloc]init];
        _titleNode.maximumNumberOfLines = 1;
    }
    return _titleNode;
}

- (ASTextNode *)descNode {
    if (_descNode == nil) {
        _descNode = [[ASTextNode alloc]init];
        _descNode.maximumNumberOfLines = 1;
    }
    return _descNode;
}

- (ASTextNode *)dataNode {
    if (_dataNode == nil) {
        _dataNode = [[ASTextNode alloc]init];
        _dataNode.maximumNumberOfLines = 1;
    }
    return _dataNode;
}

- (ASTextNode *)tagNode {
    if (_tagNode == nil) {
        _tagNode = [[ASTextNode alloc]initWithViewBlock:^UIView * _Nonnull{
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"1";
            label.font = [UIFont systemFontOfSize:12];
            label.layer.cornerRadius = 3;
            label.clipsToBounds = YES;
            return label;
        }];
    }
    return _tagNode;
}
@end
