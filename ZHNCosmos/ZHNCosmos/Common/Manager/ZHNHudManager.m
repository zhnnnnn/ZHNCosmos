//
//  ZHNHudManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNHudManager.h"
#import "ZHNTopHud.h"
#import "ZHNCosmosConfigManager.h"

@implementation ZHNHudManager
+ (void)showWarning:(NSString *)warning {
    [ZHNHudManager p_autoSettingHudMask];
    [ZHNHudManager p_autoSettingBackgroundColorTextColor];
    [ZHNTopHud showWarning:warning];
}

+ (void)showError:(NSString *)error {
    [ZHNHudManager p_autoSettingHudMask];
    [ZHNHudManager p_autoSettingBackgroundColorTextColor];
    [ZHNTopHud showError:error];
}

+ (void)showSuccess:(NSString *)success {
    [ZHNHudManager p_autoSettingHudMask];
    [ZHNHudManager p_autoSettingBackgroundColorTextColor];
    [ZHNTopHud showSuccess:success];
}

+ (void)p_autoSettingHudMask {
    [ZHNThemeManager zhn_extraNightHandle:^{
        [ZHNTopHud setDefaultMaskType:ZHNTopHudMaskTypeDark];
    } dayHandle:^{
        [ZHNTopHud setDefaultMaskType:ZHNTopHudMaskTypeLight];
    }];
}

+ (void)p_autoSettingBackgroundColorTextColor {
    ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
    [ZHNThemeManager zhn_extraNightHandle:^{
        [ZHNTopHud setHUDTintColor:[UIColor clearColor] isNeedBlur:YES];
        [ZHNTopHud setTextColor:ZHNHexColor(@"969696")];
    } dayHandle:^{
        if (common.navigationbarFitThemeColor) {
            [ZHNTopHud setHUDTintColor:[ZHNThemeManager zhn_getThemeColor] isNeedBlur:NO];
            [ZHNTopHud setTextColor:[UIColor whiteColor]];
        }else {
            [ZHNTopHud setHUDTintColor:[UIColor clearColor] isNeedBlur:YES];
            [ZHNTopHud setTextColor:[UIColor blackColor]];
        }
    }];
}

@end
