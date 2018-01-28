//
//  ZHNThemeManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const ZHNCosmosThemeColorChangingNotification;
@interface ZHNThemeManager : NSObject
/**
 create singleton instance

 @return singleton
 */
+ (instancetype)shareinstance;

/**
 change nightVersion
 */
+ (void)zhn_changeNightVersion;

/**
 reload theme color
 */
+ (void)zhn_reloadColorTheme;

/**
 Reload richText config `font` `padding`
 */
+ (void)zhn_reloadRichTextConfig;
+ (void)zhn_observeToReloadRichTextConfigWithObserver:(NSObject *)observer
                                               handle:(void(^)())handle;

/**
 reload status

 @param nightHandle if night
 @param dayHandle if day
 */
+ (void)zhn_extraNightHandle:(void(^)())nightHandle
                   dayHandle:(void(^)())dayHandle;

/**
 cache theme color

 @param color color
 */
+ (void)zhn_cacheThemeColor:(UIColor *)color;

/**
 get theme color

 @return color
 */
+ (UIColor *)zhn_getThemeColor;

/**
 get theme hex color string

 @return hex color string
 */
+ (NSString *)zhn_themeColorHexString;

/**
 initialize theme color recommend color array if need
 */
+ (void)zhn_initializeThemeColorAndRecommendColorArrayIfNeed;
@end
