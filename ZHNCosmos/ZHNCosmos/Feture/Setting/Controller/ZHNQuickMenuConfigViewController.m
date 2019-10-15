//
//  ZHNCosmosQuickMenuConfigViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNQuickMenuConfigViewController.h"
#import "ZHNCosmosConfigQuickMenuItemModel.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNQuickMenuConfigViewController ()

@end

@implementation ZHNQuickMenuConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.activeModelArray = [[ZHNCosmosConfigQuickMenuItemModel activeQuickMenuItemModelArray] mutableCopy];
    self.nactiveModelArray = [[ZHNCosmosConfigQuickMenuItemModel nactiveQuickMenuItemModelArray] mutableCopy];
    self.headerTitleArray = @[@"",@"更多快捷方式"];
    self.footerTitleArray = @[@"",@"建议：为避免快捷菜单选项数目过多，请选择常用的1~2个作为快捷操作"];
}

- (void)zhn_tabviewCell:(UITableViewCell *)cell statusIntitalWithindexPath:(NSIndexPath *)indexPath {
    ZHNCosmosConfigQuickMenuItemModel *model;
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
    [self.activeModelArray enumerateObjectsUsingBlock:^(ZHNCosmosConfigQuickMenuItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isActive = YES;
        model.orderIndex = idx;
        [model updateToDB];
    }];
    [self.nactiveModelArray enumerateObjectsUsingBlock:^(ZHNCosmosConfigQuickMenuItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isActive = NO;
        model.orderIndex = idx + 4;
        [model updateToDB];
    }];
    // reload
    [[ZHNCosmosConfigManager shareinstance].reloadQuickMenuTabbarItemConfigSubject sendNext:@(ZHNConfigReloadTypeQuickMenu)];
    return YES;
}

@end
