//
//  ZHNCosmosTabbarController.m
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosTabbarController.h"
#import "ZHNCosmosTabbar.h"
#import "ZHNUniversalSettingMenu.h"
#import "ZHNMainControllerColorPickerTrasitionHelper.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNControlpadTransitionHelper.h"
#import "ZHNNavigationViewController.h"
#import "ZHNTabbarItemNotificationManager.h"

@interface ZHNCosmosTabbarController ()
@property (nonatomic,copy) NSArray <ZHNCosmosConfigTabbarItemModel *> *tabbarItemConfigArray;
@end

@implementation ZHNCosmosTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.isCustomThemeColor = YES;
    [self p_initializeTabbar];
    
    // Reload
    @weakify(self)
    [[ZHNCosmosConfigManager shareinstance].reloadQuickMenuTabbarItemConfigSubject subscribeNext:^(id type) {
        @strongify(self)
        if ([type integerValue] == ZHNConfigReloadTypeQuickMenu) {
           [self.tabbar reloadQuickMenuCofigWithModelArray:[self p_corActivityArray]];
        }
        if ([type integerValue] == ZHNConfigReloadTypeTabbar) {
            [self.tabbar reloadTabbarControllerConfigWithNewModelArray:[self p_getTabbarItemModelArray]];
        }
    }];
}

#pragma mark - pravite methods
- (void)p_initializeTabbar {
    [self.view addSubview:self.tabbar];
    CGFloat tabbarHeight = K_tabbar_height + K_tabbar_safeArea_height;
    self.tabbar.frame = CGRectMake(0, K_SCREEN_HEIGHT - tabbarHeight, K_SCREEN_WIDTH, tabbarHeight);
    self.tabbar.superController = self;
    self.tabbar.itemModelArray = [self p_getTabbarItemModelArray];
    [self.view bringSubviewToFront:self.tabbar];
}

- (NSMutableArray <ZHNCosmosTabbarItemModel *> *)p_getTabbarItemModelArray {
    NSMutableArray *tabbarItemModelArray = [NSMutableArray array];
    NSArray *tabbarConfigModelArray = [ZHNCosmosConfigTabbarItemModel activeConfigTabbarItemModelArray];
    self.tabbarItemConfigArray = tabbarConfigModelArray;
    for (int index = 0; index < tabbarConfigModelArray.count; index++) {
        // normal
        ZHNCosmosConfigTabbarItemModel *cfgModel = tabbarConfigModelArray[index];
        ZHNCosmosTabbarItemModel *itemModel;
        itemModel = [ZHNCosmosTabbarItemModel
                     zhn_tabbarItemModelWithImageName:cfgModel.imageName
                     itemName:cfgModel.itemName
                     itemType:ZHNTabbarItemTypeShineBtn
                     controllerClass:NSClassFromString(cfgModel.controllerClassName)
                     reloadAction:^{
                         [ZHNTabbarItemNotificationManager tabbarClickToReloadStatuesWithControllerClass:NSClassFromString(cfgModel.controllerClassName)];
                     }];
        [tabbarItemModelArray addObject:itemModel];
        
        // longpress
        if (index == 1) {
            // qucik menu item (6 tabbar item select 4 + more menu item +the residue tabbar add to quick menu)
            NSMutableArray *corActivityArray = [self p_corActivityArray];
            ZHNCosmosTabbarItemModel *longPressModel;
            longPressModel = [ZHNCosmosTabbarItemModel
                              zhn_tabbarItemModelWithImageName:@"tabbar_icon_post"
                              itemName:nil
                              itemType:ZHNTabbarItemTypeLongPressBtn
                              corona3dMenuActivityArray:corActivityArray
                              tapAction:^{
                                  [ZHNHudManager showWarning:@"发微博TODO~"];
                              }];
            [tabbarItemModelArray addObject:longPressModel];
        }
    }
    return tabbarItemModelArray;
}

- (NSMutableArray *)p_corActivityArray {
    NSMutableArray *corActivityArray = [NSMutableArray array];
    // quick menu
    [[ZHNCosmosConfigQuickMenuItemModel activeQuickMenuItemModelArray] enumerateObjectsUsingBlock:^(ZHNCosmosConfigQuickMenuItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHNCosmosConfigQuickMenuItemModel *configModel = (ZHNCosmosConfigQuickMenuItemModel *)obj;
        ZHN3DMenuActivity *activity = [ZHN3DMenuActivity
                                       zhn_activityWithTitle:configModel.itemName
                                       tintColor:KTabbarMenuNormalColor
                                       imageName:configModel.imageName
                                       normalColor:KTabbarMenuNormalColor
                                       highLoghtColor:[UIColor whiteColor]
                                       selectionAction:^{
                                           [ZHNCosmosConfigQuickMenuItemModel actionForQuickMenuType:configModel.type];
                                       }];
        [corActivityArray addObject:activity];
    }];
    
    // Show control pad.
    ZHN3DMenuActivity *moreOptionActivity = [ZHN3DMenuActivity
                                             zhn_activityWithTitle:@"更多选项"
                                             tintColor:KTabbarMenuNormalColor
                                             imageName:@"floating_menu_more_control"
                                             normalColor:KTabbarMenuNormalColor
                                             highLoghtColor:[UIColor whiteColor]
                                             selectionAction:^{
                                                 [ZHNNavigationViewController zhn_showWholeNavibarIfNeed];
                                                 [ZHNControlpadTransitionHelper showControlpad];
                                             }];
    [corActivityArray addObject:moreOptionActivity];
    
    // tabbar item
    [[ZHNCosmosConfigTabbarItemModel nactiveConfigTabbarItemModelArry] enumerateObjectsUsingBlock:^(ZHNCosmosConfigTabbarItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHNCosmosConfigTabbarItemModel *configModel = (ZHNCosmosConfigTabbarItemModel *)obj;
        ZHN3DMenuActivity *activity = [ZHN3DMenuActivity
                                       zhn_activityWithTitle:configModel.itemName
                                       tintColor:KTabbarMenuNormalColor
                                       imageName:configModel.imageName
                                       normalColor:KTabbarMenuNormalColor
                                       highLoghtColor:[UIColor whiteColor]
                                       selectionAction:^{
                                           [ZHNCosmosConfigTabbarItemModel actionForTabbarItemModel:configModel];
                                       }];
        [corActivityArray addObject:activity];
    }];
    return corActivityArray;
}

#pragma mark - getters
- (UIViewController *)selectedController {
    return self.tabbar.selectedController;
}

- (ZHNCosmosTabbar *)tabbar {
    if (_tabbar == nil) {
        _tabbar = [[ZHNCosmosTabbar alloc]init];
    }
    return _tabbar;
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
