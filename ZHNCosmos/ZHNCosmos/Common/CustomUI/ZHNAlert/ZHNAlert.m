//
//  ZHNAlert.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/17.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNAlert.h"
static CGFloat KAlertAnimateDuration = 0.7;
static CGFloat KAlertAnimateDamping = 0.7;
static CGFloat KAlertAnimateSpring = 1;
@implementation ZHNAlert
+ (void)zhn_showAlertWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(ZHNAlertClickAction)confirmAction {
    [ZHNAlert zhn_showAlertWithMessage:message CancleTitle:nil cancleAction:nil confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (void)zhn_showAlertWithMessage:(NSString *)message CancleTitle:(NSString *)cancleTitle cancleAction:(ZHNAlertClickAction)cancleAction confirmTitle:(NSString *)confirmTitle confirmAction:(ZHNAlertClickAction)confirmAction {
    NSAssert(confirmTitle, @"ZHNAlert 必须要设置ConfirmTitle");
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // Blur
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [keyWindow addSubview:blurView];
    blurView.frame = keyWindow.bounds;
    blurView.alpha = 0;
    
    // Alert
    ZHNALertMenuView *alert = [ZHNALertMenuView zhn_menuWithMessage:message cancleTitle:cancleTitle confirmTitle:confirmTitle cancleAction:cancleAction confirmAction:confirmAction blurView:blurView];
    [keyWindow addSubview:alert];
    alert.alertColor = [ZHNThemeManager zhn_getThemeColor];
    alert.center = CGPointMake(K_SCREEN_WIDTH/2, K_SCREEN_HEIGHT/2);
    CGSize size = [alert alertFitSize];
    alert.bounds = CGRectMake(0, 0, size.width, size.height);
    alert.transform =  CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height), CGAffineTransformMakeScale(1.5, 1.5));
    
    // Animate
    [UIView animateWithDuration:KAlertAnimateDuration delay:0 usingSpringWithDamping:KAlertAnimateDamping initialSpringVelocity:KAlertAnimateSpring options:UIViewAnimationOptionCurveEaseIn animations:^{
        alert.transform = CGAffineTransformIdentity;
        blurView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

@end

////////////////////////////////////////////////////////
static CGFloat const KMessagePadding = 20;
static CGFloat const KAlertMinHeight = 150;
static CGFloat const KAlertWidth = 280;
static CGFloat const KAlertBtnHeight = 50;
static CGFloat const KAlertMessageFont = 20;
static CGFloat const KAlertNoticeImageSize = 80;
@interface ZHNALertMenuView()
// View
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *btnContainerView;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIImageView *noticeImageView;
// Data
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *cancleTitle;
@property (nonatomic,copy) NSString *confirmTitle;
@property (nonatomic,copy) ZHNAlertClickAction cancleAction;
@property (nonatomic,copy) ZHNAlertClickAction confrimAction;
@property (nonatomic,strong) UIVisualEffectView *blurView;
@end

@implementation ZHNALertMenuView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.btnContainerView];
        [self.backgroundView addSubview:self.cancleBtn];
        [self.backgroundView addSubview:self.confirmBtn];
        [self.backgroundView addSubview:self.messageLabel];
        [self addSubview:self.noticeImageView];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat viewHeight = self.frame.size.height;
    CGFloat viewWidth = self.frame.size.width;
    self.backgroundView.frame = self.bounds;
    self.noticeImageView.frame = CGRectMake(10, -KAlertNoticeImageSize/2, KAlertNoticeImageSize, KAlertNoticeImageSize);
    
    self.btnContainerView.frame = CGRectMake(0, viewHeight - KAlertBtnHeight, viewWidth, KAlertBtnHeight);
    
    self.messageLabel.center = CGPointMake(viewWidth/2, viewHeight/2);
    CGSize messageSize = [self messageSize];
    self.messageLabel.bounds = CGRectMake(0, 0, messageSize.width, messageSize.height);
    
    if (self.cancleTitle) {
        self.cancleBtn.frame = CGRectMake(0, self.btnContainerView.frame.origin.y, viewWidth/2, KAlertBtnHeight);
        self.confirmBtn.frame = CGRectMake(viewWidth/2, self.btnContainerView.frame.origin.y, viewWidth/2, KAlertBtnHeight);
    }else {
        self.confirmBtn.frame = self.btnContainerView.frame;
    }
}

+ (ZHNALertMenuView *)zhn_menuWithMessage:(NSString *)message cancleTitle:(NSString *)cancleTitle confirmTitle:(NSString *)confrimTitle cancleAction:(ZHNAlertClickAction)cancleAction confirmAction:(ZHNAlertClickAction)confrimAction blurView:(UIVisualEffectView *)blurView{
    ZHNALertMenuView *menuView = [[ZHNALertMenuView alloc]init];
    menuView.message = message;
    menuView.cancleTitle = cancleTitle;
    menuView.confirmTitle = confrimTitle;
    menuView.cancleAction = cancleAction;
    menuView.confrimAction = confrimAction;
    menuView.blurView = blurView;
    return menuView;
}

- (CGSize)alertFitSize {
    CGFloat width = KAlertWidth;
    CGFloat height = [self messageSize].height + KAlertMinHeight;
    return CGSizeMake(width, height);
}

- (CGSize)messageSize {
    CGRect stringRect = [self.message boundingRectWithSize:CGSizeMake(KAlertWidth - 2 * KMessagePadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KAlertMessageFont]} context:nil];
    return stringRect.size;
}

#pragma mark - action
- (void)cancleHandle {
    [self p_animateToDismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KAlertAnimateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.cancleAction) {
            self.cancleAction();
        }
    });
}

- (void)confirmHandle {
    [self p_animateToDismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KAlertAnimateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.confrimAction) {
            self.confrimAction();
        }
    });
}

#pragma mark - pravite methods
- (void)p_animateToDismiss {
    [UIView animateWithDuration:KAlertAnimateDuration delay:0 usingSpringWithDamping:KAlertAnimateDamping initialSpringVelocity:KAlertAnimateSpring options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height);
        self.blurView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - setters
- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
}

- (void)setCancleTitle:(NSString *)cancleTitle {
    _cancleTitle = cancleTitle;
    [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
}

- (void)setConfirmTitle:(NSString *)confirmTitle {
    _confirmTitle = confirmTitle;
    [self.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
}

- (void)setAlertColor:(UIColor *)alertColor {
    _alertColor = alertColor;
    self.backgroundView.backgroundColor = alertColor;
}

#pragma mark - getters
- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:KAlertMessageFont];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)cancleBtn {
    if (_cancleBtn == nil) {
        _cancleBtn = [[UIButton alloc]init];
        [_cancleBtn addTarget:self action:@selector(cancleHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)confirmBtn {
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc]init];
        [_confirmBtn addTarget:self action:@selector(confirmHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)btnContainerView {
    if (_btnContainerView == nil) {
        _btnContainerView = [[UIView alloc]init];
        _btnContainerView.backgroundColor = [UIColor blackColor];
        _btnContainerView.alpha = 0.1;
    }
    return _btnContainerView;
}

- (UIImageView *)noticeImageView {
    if (_noticeImageView == nil) {
        _noticeImageView = [[UIImageView alloc]init];
        _noticeImageView.image = [UIImage imageNamed:@"alert_top_image"];
    }
    return _noticeImageView;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.layer.cornerRadius = 10;
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}
@end
