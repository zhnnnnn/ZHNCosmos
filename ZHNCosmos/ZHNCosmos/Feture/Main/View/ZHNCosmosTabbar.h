//
//  ZHNCosmosTabbar.h
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNAwesome3DMenu.h"
#import "ZHNCosmosTabbarItem.h"
#import "ZHNCosmosTabbarItemModel.h"
@class ZHNCosmosTabbarController;
@interface ZHNCosmosTabbar : UIView
/** sub controller dict `key` is the itemmodel`s itemname, `value` is controller */
@property (nonatomic,strong) NSMutableDictionary *subControllerDict;
/** Current selected controller */
@property (nonatomic,strong) UIViewController *selectedController;
/** super controller */
@property (nonatomic,weak) ZHNCosmosTabbarController *superController;
/** item array */
@property (nonatomic,copy) NSArray <ZHNCosmosTabbarItemModel *> *itemModelArray;
/**
 reload tabbar config to change ui

 @param newItemModelArray tabbar config model array
 */
- (void)reloadTabbarControllerConfigWithNewModelArray:(NSArray <ZHNCosmosTabbarItemModel *> *)newItemModelArray;

/**
 reload quick menu config to change ui

 @param menuActivityArray quick menu config model array
 */
- (void)reloadQuickMenuCofigWithModelArray:(NSArray <ZHN3DMenuActivity *> *)menuActivityArray;
@end
