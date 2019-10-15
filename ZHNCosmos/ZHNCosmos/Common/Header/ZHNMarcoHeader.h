//
//  ZHNMarcoHeader.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#ifndef ZHNMarcoHeader_h
#define ZHNMarcoHeader_h

// screen width height
#define K_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
// color
#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBCOLORALPHA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RandomColor     [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// weakself strongself
#define COSWEAKSELF  __weak __typeof__(self) weakSelf = self;
#define COSSTRONGSELF __strong __typeof(self) strongSelf = weakSelf;
// auto scale num
#define KAUTOSCALE(num) ((K_SCREEN_WIDTH/375)*num)
// hex string to uicolor
#define ZHNHexColor(color) [UIColor colorWithHexString:color]
// thmem color image
#define ZHNThemeColorImage(imageName) [[UIImage imageNamed:imageName] imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]]

#define ZHNCurrentThemeFitColorForkey(key) (DKColorPickerWithKey(key)([[DKNightVersionManager sharedManager] themeVersion]))
#define ZHNColorPickerWithColors(color1,color2) DKColorPickerWithColors(color1,color2)([[DKNightVersionManager sharedManager] themeVersion])
// 
#define IS_IPHONE_4_OR_LESS (K_SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5_5S_5C (K_SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6_7_8 (K_SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P_7P_8P (K_SCREEN_HEIGHT == 736.0)
#define IS_IPHONEX (K_SCREEN_HEIGHT == 812)
#endif
