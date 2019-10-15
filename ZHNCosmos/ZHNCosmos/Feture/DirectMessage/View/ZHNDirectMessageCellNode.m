//
//  ZHNDirectMessageCellNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/21.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDirectMessageCellNode.h"
#import "NSAttributedString+ZHNCreate.h"
#import "NSDate+ZHNAdd.h"

static CGFloat const KDirectAvatarSize = 50;
static CGFloat const KDirectVipIocnSize = 10;
static CGFloat const KDirectUnreadTagSize = 20;
@interface ZHNDirectMessageCellNode()
@property (nonatomic,strong) ASDisplayNode *avatarNode;
@property (nonatomic,strong) ASTextNode *nameNode;
@property (nonatomic,strong) ASTextNode *timeNode;
@property (nonatomic,strong) ASImageNode *vipIconNode;
@property (nonatomic,strong) ASTextNode *textNode;
@property (nonatomic,strong) ASDisplayNode *unreadTag;
@end

@implementation ZHNDirectMessageCellNode
- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.avatarNode];
        [self addSubnode:self.nameNode];
        [self addSubnode:self.timeNode];
        [self addSubnode:self.vipIconNode];
        [self addSubnode:self.textNode];
        [self addSubnode:self.unreadTag];
        @weakify(self);
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            self.messageModel = self.messageModel;
        };
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.avatarNode.style.preferredSize = CGSizeMake(KDirectAvatarSize, KDirectAvatarSize);
    self.vipIconNode.style.preferredSize = CGSizeMake(KDirectVipIocnSize, KDirectVipIocnSize);
    self.unreadTag.style.preferredSize = CGSizeMake(KDirectUnreadTagSize, KDirectUnreadTagSize);
    
    ASStackLayoutSpec *nameTimeLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    nameTimeLayout.children = @[self.nameNode,self.timeNode];
    nameTimeLayout.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    
    self.textNode.style.spacingBefore = 10;
    ASStackLayoutSpec *leftContentLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    leftContentLayout.children = @[nameTimeLayout,self.textNode];
    leftContentLayout.style.flexShrink = 1;
    leftContentLayout.style.flexGrow = 1;
    
    ASRelativeLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionMinimumSize child:self.unreadTag];
    ASInsetLayoutSpec *avatarInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 0, 0, 5) child:self.avatarNode];
    ASOverlayLayoutSpec *overAvatarLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:avatarInsetLayout overlay:relativeLayout];
    
    ASStackLayoutSpec *fullLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    fullLayout.children = @[overAvatarLayout,leftContentLayout];
    fullLayout.spacing = 5;
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:fullLayout];
    
    return insetLayout;
}

#pragma mark - setters
- (void)setMessageModel:(ZHNDirectMessageModel *)messageModel {
    _messageModel = messageModel;
    if (!messageModel) {return;}
    UIColor *timeColor = DKColorPickerWithColors(ZHNHexColor(@"969696"),ZHNHexColor(@"b4b4b4"))([[DKNightVersionManager sharedManager] themeVersion]);
    NSString *timeString = [messageModel.directMessage.createdAt displayDateString];
    self.timeNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:timeString font:[UIFont systemFontOfSize:13] textColor:timeColor];
    
    self.nameNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:messageModel.user.name font:[UIFont systemFontOfSize:17] textColor:ZHNCurrentThemeFitColorForkey(OriginalCellMainTextColor)];

    self.textNode.attributedText = [NSAttributedString zhn_attributeStringWithStr:messageModel.directMessage.text font:[UIFont systemFontOfSize:15] textColor:ZHNCurrentThemeFitColorForkey(OriginalCellMinorTextColor)];
    
    [(UIImageView *)self.avatarNode.view sd_setImageWithURL:[NSURL URLWithString:messageModel.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_user_man"]];
    
    if (messageModel.unreadCount > 0) {
        self.unreadTag.hidden = NO;
        [(UILabel *)self.unreadTag.view setText:[NSString stringWithFormat:@"%ld",messageModel.unreadCount]];
    }else {
        self.unreadTag.hidden = YES;
    }
}

#pragma mark - getters
- (ASDisplayNode *)avatarNode {
    if (_avatarNode == nil) {
        _avatarNode = [[ASDisplayNode alloc]initWithViewBlock:^UIView * _Nonnull{
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.layer.cornerRadius = KDirectAvatarSize/2;
            imageView.clipsToBounds = YES;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.layer.borderWidth = 1;
            return imageView;
        }];
    }
    return _avatarNode;
}

- (ASTextNode *)nameNode {
    if (_nameNode == nil) {
        _nameNode = [[ASTextNode alloc]init];
    }
    return _nameNode;
}

- (ASTextNode *)timeNode {
    if (_timeNode == nil) {
        _timeNode = [[ASTextNode alloc]init];
    }
    return _timeNode;
}

- (ASImageNode *)vipIconNode {
    if (_vipIconNode == nil) {
        _vipIconNode = [[ASImageNode alloc]init];
        _vipIconNode.backgroundColor = [UIColor redColor];
    }
    return _vipIconNode;
}

- (ASTextNode *)textNode {
    if (_textNode == nil) {
        _textNode = [[ASTextNode alloc]init];
        _textNode.maximumNumberOfLines = 1;
    }
    return _textNode;
}

- (ASDisplayNode *)unreadTag {
    if (_unreadTag == nil) {
        _unreadTag = [[ASDisplayNode alloc]initWithViewBlock:^UIView * _Nonnull{
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor redColor];
            label.layer.cornerRadius = KDirectUnreadTagSize/2;
            label.clipsToBounds = YES;
            label.font = [UIFont systemFontOfSize:14];
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            return label;
        }];
    }
    return _unreadTag;
}
@end
