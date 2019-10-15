//
//  ZHNControlpad.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpad.h"
#import "ZHNControlpadCheckmark.h"
#import "ZHNControlpadBaseBtn.h"
#import "ZHNControlpadNormalBtn.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNControlpadSwitch.h"
#import "ZHNControlpadSlider.h"
#import "ZHNMainControllerColorPickerTrasitionHelper.h"
#import "ZHNControlpadTransitionHelper.h"
#import "ZHNNightVersionChangeTransitionManager.h"
#import "ZHNSettingViewController.h"
#import "ZHNControllerPushManager.h"

@interface ZHNControlpad()
@property (weak, nonatomic) IBOutlet ZHNControlpadCheckmark *onSoundBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadNormalBtn *changeColorThemeBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadNormalBtn *showTimelinePicBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadNormalBtn *webReadingModeBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadNormalBtn *changeFontBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadCheckmark *changeNightVersionBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadNormalBtn *settingBtn;
@property (weak, nonatomic) IBOutlet ZHNControlpadSwitch *cardTypeSwitch;
@property (weak, nonatomic) IBOutlet ZHNControlpadSlider *fontSlider;
@property (weak, nonatomic) IBOutlet ZHNControlpadSlider *paddingSlider;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backEffectView;
@property (weak, nonatomic) IBOutlet UILabel *paddingLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontLabel;
@end

@implementation ZHNControlpad
+ (ZHNControlpad *)loadView {
    ZHNControlpad *ctrPad = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    return ctrPad;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_initActions];
    [self p_initUI];
    ZHNCosmosConfigCommonModel *configModel = [ZHNCosmosConfigManager commonConfigModel];
    self.fontSlider.currentValue = configModel.font;
    self.paddingSlider.currentValue = configModel.padding;
}

- (void)p_initActions {
    self.onSoundBtn.checkMarkHandle = ^(BOOL value) {
        NSLog(@"%d",value);
    };
    
    self.fontSlider.valueChangeHandle = ^(CGFloat value) {
        [ZHNThemeManager zhn_reloadRichTextConfig];
    };
    
    self.paddingSlider.valueChangeHandle = ^(CGFloat value) {
        [ZHNThemeManager zhn_reloadRichTextConfig];
    };
    
    self.changeColorThemeBtn.normalHandle = ^{
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNMainControllerColorPickerTrasitionHelper showColorPicker];
        }];
    };
    
    self.changeNightVersionBtn.checkMarkHandle = ^(BOOL value) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNNightVersionChangeTransitionManager zhn_transition];
        }];
    };
    
    self.changeFontBtn.normalHandle = ^{
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNHudManager showWarning:@"TODO~"];
        }];
    };
    
    self.onSoundBtn.checkMarkHandle = ^(BOOL value) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNHudManager showWarning:@"TODO~"];
        }];
    };
    
    self.showTimelinePicBtn.checkMarkHandle = ^(BOOL value) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNHudManager showWarning:@"TODO~"];
        }];
    };
    
    self.webReadingModeBtn.checkMarkHandle = ^(BOOL value) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNHudManager showSuccess:@"切换网页阅读模式成功"];
        }];
    };
    
    self.cardTypeSwitch.valueChangeHandle = ^(BOOL dbValue) {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNHudManager showWarning:@"TODO~"];
        }];
    };
    
    self.settingBtn.normalHandle = ^{
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNControllerPushManager zhn_pushViewControllerWithClass:[ZHNSettingViewController class]];
        }];
    };
}

- (void)p_initUI {
    if ([DKNightVersionManager sharedManager].themeVersion == DKThemeVersionNight) {
        self.backEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }else {
        self.backEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    self.fontLabel.dk_textColorPicker = DKColorPickerWithRGB(0x00000, 0xb4b4b4);
    self.paddingLabel.dk_textColorPicker = DKColorPickerWithRGB(0x00000, 0xb4b4b4);
    self.changeNightVersionBtn.isHightlight = [[DKNightVersionManager sharedManager] themeVersion] == DKThemeVersionNormal;
}

@end
