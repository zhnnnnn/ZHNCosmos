//
//  ZHNCosmosLoginView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosLoginView.h"
#import "ZHNCosmosUserManager.h"
#import "ZHNLoginLoading.h"

#define KEYWindow [UIApplication sharedApplication].keyWindow
@interface ZHNCosmosLoginView()
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (nonatomic,strong) UIView *maskView;

@property (weak, nonatomic) IBOutlet UILabel *accountDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation ZHNCosmosLoginView
+ (instancetype)zhn_loadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    self.passwordLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    [ZHNThemeManager zhn_extraNightHandle:^{
        self.backgroundColor = [UIColor clearColor];
        self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [self.dismissBtn setTitleColor:ZHNHexColor(@"313131") forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:ZHNHexColor(@"313131") forState:UIControlStateNormal];
    } dayHandle:^{
        self.backgroundColor = ZHNHexColor(@"#E6E6E6");
        self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        [self.dismissBtn setTitleColor:ZHNHexColor(@"fafafa") forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:ZHNHexColor(@"fafafa") forState:UIControlStateNormal];
    }];
    self.accountDescLabel.textColor = ZHNColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
    self.passwordDescLabel.textColor = ZHNColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
}

+ (void)zhn_showLoginView {
    UIView *maskView = [[UIView alloc]init];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [KEYWindow addSubview:maskView];
    maskView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    maskView.alpha = 0;
    
    CGFloat height = IS_IPHONEX ? 300 : 270;
    ZHNCosmosLoginView *loginView = [ZHNCosmosLoginView zhn_loadView];
    loginView.maskView = maskView;
    [KEYWindow addSubview:loginView];
    loginView.frame = CGRectMake(0, -K_statusBar_height - height, K_SCREEN_WIDTH, height);
    [loginView.accountLabel becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        loginView.frame = CGRectMake(0, -K_statusBar_height, K_SCREEN_WIDTH, height);
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)dismissAction:(id)sender {
    [self p_dismiss];
}
- (IBAction)confirmAction:(id)sender {
    [self p_dismiss];
    UIVisualEffectView *maskEffectView = [[UIVisualEffectView alloc]init];
    [ZHNThemeManager zhn_extraNightHandle:^{
        maskEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    } dayHandle:^{
        maskEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }];
    [KEYWindow addSubview:maskEffectView];
    maskEffectView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    
    ZHNLoginLoading *loading = [[ZHNLoginLoading alloc]initWithCycleSize:20 cycleColor:[ZHNThemeManager zhn_getThemeColor]];
    [KEYWindow addSubview:loading];
    loading.center = CGPointMake(K_SCREEN_WIDTH/2, K_SCREEN_HEIGHT/2);
    loading.bounds = CGRectMake(0, 0, 60, 20);
    [loading startAnimate];
    [ZHNCosmosUserManager zhn_addUserWithUserName:self.accountLabel.text password:self.passwordLabel.text success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZHNHudManager showSuccess:@"添加账号成功~"];
            [[NSNotificationCenter defaultCenter]postNotificationName:KUserAddSuccessNotification object:nil];
            [loading removeFromSuperview];
            [maskEffectView removeFromSuperview];
        });
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZHNHudManager showError:@"添加账号失败~"];
            [loading removeFromSuperview];
            [maskEffectView removeFromSuperview];
        });
    }];
}

- (void)p_dismiss {
    [self.accountLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
    CGFloat height = IS_IPHONEX ? 300 : 270;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.frame = CGRectMake(0, -K_statusBar_height - height, K_SCREEN_WIDTH, height);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
