//
//  ZHNUniversalSettingMenu.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNAwesome3DMenu.h"

@interface ZHNUniversalSettingMenu : UIView
/** item status array */
@property (nonatomic,copy) NSArray <ZHN3DMenuActivity *> *menuActivityArray;

/**
 corona menu
 */
@property (nonatomic,strong) ZHNAwesome3DMenu *coronaMenu;

/**
 show menu

 @param menuActivityArray item status array
 */
+ (ZHNUniversalSettingMenu *)zhn_universalSettingMenuWithMenuActivityArray:(NSArray<ZHN3DMenuActivity *> *)menuActivityArray centerIocnName:(NSString *)iconName;

/**
 show menu
 */
- (void)show;

/**
 dismiss menu
 */
- (void)disMiss;
@end
