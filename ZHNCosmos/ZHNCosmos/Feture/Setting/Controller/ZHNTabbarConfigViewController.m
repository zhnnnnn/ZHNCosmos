//
//  ZHNCosmosTabbarConfigViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTabbarConfigViewController.h"
#import "ZHNCosmosConfigTabbarItemModel.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNTabbarConfigViewController ()

@end

@implementation ZHNTabbarConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.activeModelArray = [[ZHNCosmosConfigTabbarItemModel activeConfigTabbarItemModelArray] mutableCopy];
    self.nactiveModelArray = [[ZHNCosmosConfigTabbarItemModel nactiveConfigTabbarItemModelArry] mutableCopy];
    self.headerTitleArray = @[@"",@"更多栏目"];
    self.footerTitleArray = @[@"",@"请选择四个常驻底栏,剩下未选择的栏目会自动出现在快捷菜单中"];
}

- (void)zhn_tabviewCell:(UITableViewCell *)cell statusIntitalWithindexPath:(NSIndexPath *)indexPath {
    ZHNCosmosConfigTabbarItemModel *model;
    if (indexPath.section == 0) {
        model = self.activeModelArray[indexPath.row];
    }else {
        model = self.nactiveModelArray[indexPath.row];
    }
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text = model.itemName;
    cell.imageView.image = ZHNThemeColorImage(model.imageName);
}

- (BOOL)zhn_clickSaveExtraHandleIfSuccessEndEditing {
    if (self.activeModelArray.count != 4) {
        [ZHNHudManager showWarning:@"请选择4个栏目"];
        return NO;
    }else {
        [self.activeModelArray enumerateObjectsUsingBlock:^(ZHNCosmosConfigTabbarItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.isActive = YES;
            model.orderIndex = idx;
            [model updateToDB];
        }];
        [self.nactiveModelArray enumerateObjectsUsingBlock:^(ZHNCosmosConfigTabbarItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.isActive = NO;
            model.orderIndex = idx + 4;
            [model updateToDB];
        }];
        [[ZHNCosmosConfigManager shareinstance].reloadQuickMenuTabbarItemConfigSubject sendNext:@(ZHNConfigReloadTypeTabbar)];
        return YES;
    }
}

@end
