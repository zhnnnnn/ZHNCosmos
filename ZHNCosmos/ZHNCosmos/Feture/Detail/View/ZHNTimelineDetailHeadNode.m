//
//  ZHNTimelineDetailHeadNode.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailHeadNode.h"
#import "NSAttributedString+ZHNCreate.h"

#define KLikeLabelTextColorDict @{NSForegroundColorAttributeName:ZHNHexColor(@"aab8c1")}
static CGFloat const KAvatarSize = 40;
@interface ZHNTimelineDetailHeadNode()
@property (nonatomic,strong) ASDisplayNode *avatarNode;
@property (nonatomic,strong) ASTextNode *nameNode;
@property (nonatomic,strong) ASTextNode *timeAndSourceNode;
@property (nonatomic,strong) ASTextNode *likeNode;
@property (nonatomic,strong) ASImageNode *likeIconNode;
@end

@implementation ZHNTimelineDetailHeadNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.avatarNode];
        [self addSubnode:self.nameNode];
        [self addSubnode:self.timeAndSourceNode];
        [self addSubnode:self.likeIconNode];
        [self addSubnode:self.likeNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    self.avatarNode.style.preferredSize = CGSizeMake(40, 40);
    self.likeIconNode.style.preferredSize = CGSizeMake(15, 15);
    
    ASStackLayoutSpec *textLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    textLayout.justifyContent = ASStackLayoutJustifyContentStart;
    textLayout.alignItems = ASStackLayoutAlignItemsStart;
    textLayout.children = @[self.nameNode,self.timeAndSourceNode];
    textLayout.spacing = 5;
    textLayout.style.spacingBefore = 10;
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentLayout.justifyContent = ASStackLayoutJustifyContentStart;
    contentLayout.alignItems = ASStackLayoutAlignItemsStart;
    contentLayout.children = @[self.avatarNode,textLayout];
    
    ASStackLayoutSpec *likeLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    likeLayout.justifyContent = ASStackLayoutJustifyContentStart;
    likeLayout.children = @[self.likeIconNode,self.likeNode];
    likeLayout.spacing = 5;
    
    ASStackLayoutSpec *containerLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    containerLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    containerLayout.children = @[contentLayout,likeLayout];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 0, 10) child:containerLayout];
    return insetLayout;
}

#pragma mark - events


#pragma mark - setters
- (void)setStatus:(ZHNTimelineStatus *)status {
    _status = status;
    self.nameNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:status.user.name font:[UIFont systemFontOfSize:17] textColor:[ZHNThemeManager zhn_getThemeColor]];
    self.timeAndSourceNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:status.dateAndSourceStr font:[UIFont systemFontOfSize:14] textColor:[UIColor lightGrayColor]];
    [(UIImageView *)self.avatarNode.view yy_setImageWithURL:[NSURL URLWithString:status.user.profileImageUrl] placeholder:nil];
    
}

- (void)setLikeCount:(NSString *)likeCount {
    _likeCount = likeCount;
    if (!likeCount) {return;}
    self.likeNode.attributedText = [[NSAttributedString alloc]initWithString:likeCount attributes:KLikeLabelTextColorDict];
}

- (void)setHeadType:(ZHNDetailHeadType)headType {
    _headType = headType;
    BOOL nodeHidden = YES;
    switch (headType) {
        case ZHNDetailHeadTypeTransmit:
            nodeHidden = YES;
            break;
        case ZHNDetailHeadTypeComments:
            nodeHidden = NO;
            break;
    }
    self.likeNode.hidden = nodeHidden;
    self.likeIconNode.hidden = nodeHidden;
}

#pragma mark - getters
- (ASDisplayNode *)avatarNode {
    if (_avatarNode == nil) {
        @weakify(self);
        _avatarNode = [[ASDisplayNode alloc]initWithViewBlock:^UIView * _Nonnull{
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.layer.cornerRadius = KAvatarSize/2;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                @strongify(self);
                [imageView zhn_routerEventWithName:KCellTapAvatarOrUsernameAction userInfo:@{KCellTapAvatarOrUsernameUserModelKey:self.status.user}];
            }];
            [imageView addGestureRecognizer:tap];
            return imageView;
        }];
        _avatarNode.layer.cornerRadius = KAvatarSize/2;
        _avatarNode.backgroundColor = [UIColor whiteColor];
        _avatarNode.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatarNode.layer.borderWidth = 1;
    }
    return _avatarNode;
}

- (ASTextNode *)nameNode {
    if (_nameNode == nil) {
        _nameNode = [[ASTextNode alloc]init];
    }
    return _nameNode;
}

- (ASTextNode *)timeAndSourceNode {
    if (_timeAndSourceNode == nil) {
        _timeAndSourceNode = [[ASTextNode alloc]init];
    }
    return _timeAndSourceNode;
}

- (ASTextNode *)likeNode {
    if (_likeNode == nil) {
        _likeNode = [[ASTextNode alloc]init];
        _likeNode.attributedText = [[NSAttributedString alloc]initWithString:@"0" attributes:KLikeLabelTextColorDict];
    }
    return _likeNode;
}

- (ASImageNode *)likeIconNode {
    if (_likeIconNode == nil) {
        _likeIconNode = [[ASImageNode alloc]init];
        _likeIconNode.image = [[UIImage imageNamed:@"weibo_status_attitude"] imageWithTintColor:ZHNHexColor(@"aab8c1")];
        _likeIconNode.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _likeIconNode;
}
@end
