//
//  ZHNCosmosConfigQuickMenuItemModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ZHNCfgQuickMenuType) {
    ZHNCfgQuickMenuTypeChangeNightVersion,
    ZHNCfgQuickMenuTypeSetting,
    ZHNCfgQuickMenuTypeWebViewReadingPattern,
    ZHNCfgQuickMenuTypeOnOffSound,
    ZHNCfgQuickMenuTypeChangeFont,
    ZHNCfgQuickMenuTypeShowHidePic,
    ZHNCfgQuickMenuTypeChangeCardType,
    ZHNCfgQuickMenuTypeChangeThemeColor
};

@interface ZHNCosmosConfigQuickMenuItemModel : NSObject
/**
 qucik menu item name
 */
@property (nonatomic,copy) NSString *itemName;

/**
 quick menu item icon image name
 */
@property (nonatomic,copy) NSString *imageName;

/**
 if `yes` will added in quick menu
 */
@property (nonatomic,assign) BOOL isActive;

/**
 quick menu item type
 */
@property (nonatomic,assign) ZHNCfgQuickMenuType type;

/**
 for order
 */
@property(nonatomic, assign) NSInteger orderIndex;

/** intital method */
+ (ZHNCosmosConfigQuickMenuItemModel *)modelWithItemName:(NSString *)itemName
                                               imageName:(NSString *)imageName
                                                isActive:(BOOL)isActive
                                                itemType:(ZHNCfgQuickMenuType)itemType;

/**
 set normal status if need
 */
+ (void)configIfNeed;

/**
 show item array

 @return item array
 */
+ (NSArray <ZHNCosmosConfigQuickMenuItemModel *> *)activeQuickMenuItemModelArray;

/**
 not show item array

 @return item array
 */
+ (NSArray <ZHNCosmosConfigQuickMenuItemModel *> *)nactiveQuickMenuItemModelArray;

/**
 if select item s action

 @param type item type
 */
+ (void)actionForQuickMenuType:(ZHNCfgQuickMenuType)type;
@end
