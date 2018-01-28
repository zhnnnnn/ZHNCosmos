//
//  ZHNCosmosTabbarItemModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosTabbarItemModel.h"

@implementation ZHNCosmosTabbarItemModel
+ (instancetype)zhn_tabbarItemModelWithImageName:(NSString *)imageName itemName:(NSString *)itemname itemType:(ZHNTabbarItemType)itemType controllerClass:(Class)ctrClass reloadAction:(ZHNTabbarItemSelectedTypeClickBlcok)reloadAction {
    ZHNCosmosTabbarItemModel *model = [[ZHNCosmosTabbarItemModel alloc]init];
    model.imageName = imageName;
    model.itemName = itemname;
    model.itemType = itemType;
    model.controllerCls = ctrClass;
    model.reloadAction = reloadAction;
    return model;
}

+ (instancetype)zhn_tabbarItemModelWithImageName:(NSString *)imageName itemName:(NSString *)itemname itemType:(ZHNTabbarItemType)itemType corona3dMenuActivityArray:(NSArray<ZHN3DMenuActivity *> *)activityArray tapAction:(ZHNTabbarItemSelectedTypeClickBlcok)tapAction {
    ZHNCosmosTabbarItemModel *model = [[ZHNCosmosTabbarItemModel alloc]init];
    model.imageName = imageName;
    model.itemName = itemname;
    model.itemType = itemType;
    model.tapAction = tapAction;
    model.activityArray = activityArray;
    return model;
}

@end
