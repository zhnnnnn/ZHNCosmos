//
//  ZHNSearchUserCellNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNSearchUserCellNode.h"
#import "NSAttributedString+ZHNCreate.h"
#import "NSString+ZHNCountSwitch.h"
#import "UIImage+gender.h"

static CGFloat const KAvatarSize = 50;
@interface ZHNSearchUserCellNode()
@property (nonatomic,strong) ASNetworkImageNode *avatarImageNode;
@property (nonatomic,strong) ASTextNode *nameNode;
@property (nonatomic,strong) ASTextNode *descNode;
@property (nonatomic,strong) ASTextNode *fansNode;
@property (nonatomic,strong) ASImageNode *vipNode;
@property (nonatomic,strong) ASImageNode *sexNode;
@end

@implementation ZHNSearchUserCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.avatarImageNode];
        [self addSubnode:self.descNode];
        [self addSubnode:self.fansNode];
        [self addSubnode:self.nameNode];
        [self addSubnode:self.vipNode];
        [self addSubnode:self.sexNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.avatarImageNode.style.preferredSize = CGSizeMake(KAvatarSize, KAvatarSize);
    
    ASStackLayoutSpec *textLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    textLayout.children = @[self.nameNode,self.descNode,self.fansNode];
    textLayout.style.flexGrow = 1;
    textLayout.style.flexShrink = 1;
    textLayout.spacing = 3;
    
    ASStackLayoutSpec *contentLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentLayout.children = @[self.avatarImageNode,textLayout];
    contentLayout.spacing = 10;
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 10, 5, 10) child:contentLayout];
    
    return insetLayout;
}

#pragma mark - setters
- (void)setUser:(ZHNTimelineUser *)user {
    _user = user;
    if (!user) {return;}
    
    UIImage *placeholder = [UIImage zhn_userAvatarPlaceholderImageForGender:user.gender];
    [(UIImageView *)self.avatarImageNode.view sd_setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholderImage:placeholder];
    
    UIColor *nameColor = ZHNColorPickerWithColors(ZHNHexColor(@"000000"), ZHNHexColor(@"d8d8d8"));
    self.nameNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:user.name font:[UIFont systemFontOfSize:18] textColor:nameColor];
    
    UIColor *descColor = ZHNColorPickerWithColors(ZHNHexColor(@"b8b8b8"), ZHNHexColor(@"d8d8d8"));
    self.descNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:user.userDescription font:[UIFont systemFontOfSize:12] textColor:descColor];
    
    NSString *fansCount = [NSString stringWithFormat:@"粉丝：%@",[NSString zhn_fitFansCount:user.followersCount]];
    self.fansNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:fansCount font:[UIFont systemFontOfSize:12] textColor:descColor];
}

#pragma mark - getters
- (ASNetworkImageNode *)avatarImageNode {
    if (_avatarImageNode == nil) {
        _avatarImageNode = [[ASNetworkImageNode alloc]initWithViewBlock:^UIView * _Nonnull{
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
            imageView.layer.borderWidth = 2;
            imageView.layer.cornerRadius = KAvatarSize/2;
            return imageView;
        }];
    }
    return _avatarImageNode;
}

- (ASTextNode *)nameNode {
    if (_nameNode == nil) {
        _nameNode = [[ASTextNode alloc]init];
        _nameNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:@"混合" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    }
    return _nameNode;
}

- (ASTextNode *)descNode {
    if (_descNode == nil) {
        _descNode = [[ASTextNode alloc]init];
        _descNode.maximumNumberOfLines = 1;
        _descNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:@"111313131313131" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
    }
    return _descNode;
}

- (ASTextNode *)fansNode {
    if (_fansNode == nil) {
        _fansNode = [[ASTextNode alloc]init];
        _fansNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:@"dddad" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
    }
    return _fansNode;
}

- (ASImageNode *)vipNode {
    if (_vipNode == nil) {
        _vipNode = [[ASImageNode alloc]init];
    }
    return _vipNode;
}

- (ASImageNode *)sexNode {
    if (_sexNode == nil) {
        _sexNode = [[ASImageNode alloc]init];
    }
    return _sexNode;
}
@end
