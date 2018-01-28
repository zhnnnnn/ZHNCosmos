//
//  ZHNThemeManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNThemeManager.h"
#import "ZHNRecommendColorModel.h"

NSString * const ZHNCosmosThemeColorChangingNotification = @"ZHNCosmosThemeColorChangingNotification";
NSString * const ZHNCosmosRichTextConfigReloadNotification = @"ZHNCosmosRichTextConfigReloadNotification";
@implementation ZHNThemeManager
+ (instancetype)shareinstance {
    static ZHNThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNThemeManager alloc]init];
    });
    return manager;
}

+ (void)zhn_changeNightVersion {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[ZHNThemeManager shareinstance].dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
            [[ZHNThemeManager shareinstance].dk_manager nightFalling];
        }else {
            [[ZHNThemeManager shareinstance].dk_manager dawnComing];
        }
    });
}

+ (void)zhn_reloadColorTheme {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZHNCosmosThemeColorChangingNotification object:nil];
}

+ (void)zhn_reloadRichTextConfig {
//    [self zhn_reloadColorTheme];
    [[NSNotificationCenter defaultCenter]postNotificationName:ZHNCosmosRichTextConfigReloadNotification object:nil];
}

+ (void)zhn_observeToReloadRichTextConfigWithObserver:(NSObject *)observer handle:(void (^)())handle {
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:ZHNCosmosRichTextConfigReloadNotification object:nil] takeUntil:observer.rac_willDeallocSignal] subscribeNext:^(id x) {
        if (handle) {
            handle();
        }
    }];
}

+ (void)zhn_extraNightHandle:(void (^)())nightHandle dayHandle:(void (^)())dayHandle {
    if ([[ZHNThemeManager shareinstance].dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        dayHandle();
    }else {
        nightHandle();
    }
}

+ (void)zhn_cacheThemeColor:(UIColor *)color {
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
}

+ (UIColor *)zhn_getThemeColor {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    return color;
}

+ (NSString *)zhn_themeColorHexString {
    return [[ZHNThemeManager zhn_getThemeColor] hexString];
}

+ (void)zhn_initializeThemeColorAndRecommendColorArrayIfNeed {
    UIColor *themeColor = [ZHNThemeManager zhn_getThemeColor];
    if (!themeColor) {
        [ZHNRecommendColorModel initializeRecommendThemeColorIfNeed];
        [ZHNThemeManager zhn_cacheThemeColor:ZHNHexColor(KDefaultThemeColorHexString)];
    }
}
@end
