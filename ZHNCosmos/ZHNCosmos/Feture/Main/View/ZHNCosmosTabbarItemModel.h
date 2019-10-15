//
//  ZHNCosmosTabbarItemModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNCosmosTabbarItem.h"
#import "ZHNAwesome3DMenu.h"

typedef NS_ENUM(NSInteger,ZHNTabbarItemType) {
    ZHNTabbarItemTypeShineBtn,
    ZHNTabbarItemTypeLongPressBtn
};
@interface ZHNCosmosTabbarItemModel : NSObject
// normal
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,assign) ZHNTabbarItemType itemType;
// normal item
@property (nonatomic,strong) Class controllerCls;
@property (nonatomic,copy) ZHNTabbarItemSelectedTypeClickBlcok reloadAction;
// longpress
@property (nonatomic,copy) ZHNTabbarItemSelectedTypeClickBlcok tapAction;
@property (nonatomic,copy) NSArray <ZHN3DMenuActivity *> *activityArray;

// shine btn item model
+ (instancetype)zhn_tabbarItemModelWithImageName:(NSString *)imageName
                                        itemName:(NSString *)itemname
                                        itemType:(ZHNTabbarItemType)itemType
                                 controllerClass:(Class)ctrClass
                                    reloadAction:(ZHNTabbarItemSelectedTypeClickBlcok)reloadAction;
// longpress btn item model
+ (instancetype)zhn_tabbarItemModelWithImageName:(NSString *)imageName
                                        itemName:(NSString *)itemname
                                        itemType:(ZHNTabbarItemType)itemType
                       corona3dMenuActivityArray:(NSArray <ZHN3DMenuActivity *> *)activityArray
                                       tapAction:(ZHNTabbarItemSelectedTypeClickBlcok)tapAction;
@end
