//
//  ZHNCosmosConfigTabbarItemModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ZHNCosmosTabbarItemType) {
    ZHNCosmosTabbarItemTypeTimeline,
    ZHNCosmosTabbarItemTypeMessage,
    ZHNCosmosTabbarItemTypeDirect,
    ZHNCosmosTabbarItemTypePersonalCenter,
    ZHNCosmosTabbarItemTypecollection,
    ZHNCosmosTabbarItemTypeHotAndSearch,
};

@interface ZHNCosmosConfigTabbarItemModel : NSObject
/**
 if `yes` will show
 */
@property (nonatomic,assign) BOOL isActive;

/**
 tabbar item name
 */
@property (nonatomic,copy) NSString *itemName;

/**
 tabbar item icon image name
 */
@property (nonatomic,copy) NSString *imageName;

/**
 tabbar item corresponding controller
 */
@property (nonatomic,copy) NSString *controllerClassName;

/**
 tabbar item type
 */
@property (nonatomic,assign) ZHNCosmosTabbarItemType type;

/**
 for order
 */
@property (nonatomic,assign) NSInteger orderIndex;

/**
 init method
 */
+ (ZHNCosmosConfigTabbarItemModel *)modelWithItemName:(NSString *)itemName
                                            imageName:(NSString *)imageName
                                             itemType:(ZHNCosmosTabbarItemType)itemType
                                             isActive:(BOOL)isActive
                                         ctrClassName:(NSString *)ctrClassName;

/**
 set normal status if need
 */
+ (void)configIfNeed;

/**
 show item array

 @return item array
 */
+ (NSArray <ZHNCosmosConfigTabbarItemModel *> *)activeConfigTabbarItemModelArray;

/**
 not show item arry

 @return item array
 */
+ (NSArray <ZHNCosmosConfigTabbarItemModel *> *)nactiveConfigTabbarItemModelArry;

/**
 select item action

 @param itemModel model
 */
+ (void)actionForTabbarItemModel:(ZHNCosmosConfigTabbarItemModel *)itemModel;
@end
