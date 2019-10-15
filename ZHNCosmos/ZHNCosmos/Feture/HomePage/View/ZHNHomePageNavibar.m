//
//  ZHNHomePageNavibar.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/2.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomePageNavibar.h"
#import "UIView+ZHNSnapchot.h"
#import "ZHNHomePageHeadPlaceHolder.h"
static CGFloat const KNameFont = 17;
static CGFloat const KNameLabelMaxWidth = 120;
static CGFloat const KAvatarSize = 25;
static CGFloat const KContentSpacing = 10;
#define KAvatarMaxTransX (self.width/2 - self.avatar.center.x)
#define KAvatarMaxRota (M_PI/4)
@interface ZHNHomePageNavibar()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeTopConstraints;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UIImageView *placeholder;
@end

@implementation ZHNHomePageNavibar
- (void)awakeFromNib {
    [super awakeFromNib];
    self.safeTopConstraints.constant = K_statusBar_height;
    self.backButton.zhn_expandTouchInset = UIEdgeInsetsMake(-5, -5, -5, -5);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clipsToBounds = YES;
    [self insertSubview:self.placeholder atIndex:0];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.avatar];
    self.placeholder.frame = self.bounds;
}

+ (instancetype)loadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)zhn_observePlaceholder:(ZHNHomePageHeadPlaceHolder *)placeholder {
    @weakify(self);
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage *image = [placeholder zhn_viewSnapchot];
            self.placeholder.image = image;
            self.placeholder.frame = placeholder.frame;
        });
    };
    
    [[RACObserve(placeholder, blurType)
     distinctUntilChanged]
     subscribeNext:^(id value) {
         @strongify(self);
        ZHNPlaceholderBlur blurType = [value integerValue];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             switch (blurType) {
                 case ZHNPlaceholderBlurFull:
                 {
                     self.placeholder.hidden = NO;
                     UIImage *image = [placeholder zhn_viewSnapchot];
                     self.placeholder.image = image;
                     self.placeholder.frame = placeholder.frame;
                 }
                     break;
                 case ZHNPlaceholderBlurChanging:
                 {
                     self.placeholder.hidden = YES;
                 }
                     break;
                 case ZHNPlaceholderBlurTypeChange:
                 {
                     UIImage *image = [placeholder zhn_viewSnapchot];
                     self.placeholder.image = image;
                     self.placeholder.frame = placeholder.frame;
                 }
                     break;
             }
         });
    }];
}

- (void)zhn_avatarMagicTransWithPercent:(CGFloat)percent {
    self.avatar.alpha = percent;
    self.avatar.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(KAvatarMaxRota * (1 - percent)), CGAffineTransformMakeTranslation(KAvatarMaxTransX * (1 - percent), 0));
}

- (void)zhn_nameLabelMagicTransWithPercent:(CGFloat)percent {
    self.nameLabel.alpha = percent;
    CGFloat nameMaxtrans = (self.nameLabel.center.x - self.width/2)/3;
    self.nameLabel.transform = CGAffineTransformMakeTranslation(nameMaxtrans * (percent - 1), 0);
}

#pragma mark - action
- (IBAction)backAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(ZHNHomepageNavibarClickPopController)]) {
        [self.delegate ZHNHomepageNavibarClickPopController];
    }
}

- (IBAction)searchAction:(id)sender {
    [ZHNHudManager showWarning:@"TODO"];
}

- (IBAction)showMenuAction:(id)sender {
    [ZHNHudManager showWarning:@"TODO"];
}

#pragma mark - setters
- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    CGSize strSize = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:KNameFont]}];
    CGFloat strWidth = strSize.width > KNameLabelMaxWidth ? KNameLabelMaxWidth : strSize.width;
    CGFloat contentWidth = strWidth + KAvatarSize + KContentSpacing;
    CGFloat referenceW = contentWidth/2;
    // namelabel
    CGFloat nameOffsetX = strWidth - referenceW;
    CGFloat nameCenterX = strWidth/2 - nameOffsetX + self.containerView.width/2;
    CGFloat nameCenterY = K_navigationBar_content_height/2;
    self.nameLabel.center = CGPointMake(nameCenterX, nameCenterY);
    self.nameLabel.bounds = CGRectMake(0, 0, strWidth, strSize.height);
    // avatar
    CGFloat avatarOffsetX = referenceW - KAvatarSize/2;
    CGFloat avatarCenterX = self.containerView.width/2 - avatarOffsetX;
    CGFloat avatarCenterY = K_navigationBar_content_height/2;
    self.avatar.center = CGPointMake(avatarCenterX, avatarCenterY);
    self.avatar.bounds = CGRectMake(0, 0, KAvatarSize, KAvatarSize);
    
    // Transform init
    [self zhn_avatarMagicTransWithPercent:0];
    [self zhn_nameLabelMagicTransWithPercent:0];
}

- (void)setAvatarURLStr:(NSString *)avatarURLStr {
    _avatarURLStr = avatarURLStr;
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:avatarURLStr] options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)setHomepageType:(ZHNHomePageType)homepageType {
    _homepageType = homepageType;
    self.backButton.hidden = homepageType == ZHNHomePageTypeMine ? YES : NO;
}

#pragma mark - getters
- (UIImageView *)placeholder {
    if (_placeholder == nil) {
        _placeholder = [[UIImageView alloc]init];
        _placeholder.hidden = YES;
    }
    return _placeholder;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:KNameFont];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
        _avatar.image = [UIImage imageNamed:@"placeholder_user_man"];
        _avatar.layer.cornerRadius = KAvatarSize/2;
        _avatar.clipsToBounds = YES;
    }
    return _avatar;
}
@end
