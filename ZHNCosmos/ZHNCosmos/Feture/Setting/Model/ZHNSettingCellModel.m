//
//  ZHNSettingCellModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingCellModel.h"

@implementation ZHNSettingCellModel
+ (ZHNSettingCellModel *)normalModelWtiTitle:(NSString *)title detail:(NSString *)detail cellType:(UITableViewCellAccessoryType)cellType selectAction:(ZHNSettingSelctBlock)selectAction {
    ZHNSettingCellModel *cellModel = [[ZHNSettingCellModel alloc]init];
    cellModel.title = title;
    cellModel.detail = detail;
    cellModel.type = cellType;
    cellModel.selectBlock = selectAction;
    return cellModel;
}

+ (ZHNSettingCellModel *)checkMarkModelWithTitle:(NSString *)title ifSelctConfigValue:(int)ifSelctConfigValue {
    ZHNSettingCellModel *cellModel = [[ZHNSettingCellModel alloc]init];
    cellModel.title = title;
    cellModel.ifSelectConfigValue = ifSelctConfigValue;
    return cellModel;
}
@end
