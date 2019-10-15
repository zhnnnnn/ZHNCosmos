//
//  ZHNCosmosConfigQuickMenuItemModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosConfigQuickMenuItemModel.h"
#import "ZHNSettingViewController.h"
#import "ZHNNavigationViewController.h"
#import "ZHNThemeManager.h"
#import "ZHNMainControllerColorPickerTrasitionHelper.h"
#import "ZHNQuickMenuConfigViewController.h"
#import "ZHNControllerPushManager.h"
#import "ZHNControlpadTransitionHelper.h"
#import "ZHNNightVersionChangeTransitionManager.h"

@implementation ZHNCosmosConfigQuickMenuItemModel
+ (ZHNCosmosConfigQuickMenuItemModel *)modelWithItemName:(NSString *)itemName imageName:(NSString *)imageName isActive:(BOOL)isActive itemType:(ZHNCfgQuickMenuType)itemType {
    ZHNCosmosConfigQuickMenuItemModel *model = [[ZHNCosmosConfigQuickMenuItemModel alloc]init];
    model.itemName = itemName;
    model.imageName = imageName;
    model.isActive = isActive;
    model.type = itemType;
    return model;
}

+ (void)configIfNeed {
    if ([ZHNCosmosConfigQuickMenuItemModel searchWithWhere:nil].count == 0) {
        [[ZHNCosmosConfigQuickMenuItemModel configModelArray] enumerateObjectsUsingBlock:^(ZHNCosmosConfigQuickMenuItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.orderIndex = idx;
            [obj saveToDB];
        }];
    }
}

+ (NSArray<ZHNCosmosConfigQuickMenuItemModel *> *)activeQuickMenuItemModelArray {
    NSDictionary *dict = @{@"isActive":@(YES)};
    return [ZHNCosmosConfigQuickMenuItemModel searchWithWhere:dict orderBy:@"orderIndex" offset:0 count:100];
}

+ (NSArray<ZHNCosmosConfigQuickMenuItemModel *> *)nactiveQuickMenuItemModelArray {
    NSDictionary *dict = @{@"isActive":@(NO)};
    return [ZHNCosmosConfigQuickMenuItemModel searchWithWhere:dict orderBy:@"orderIndex" offset:0 count:100];
}

+ (void)actionForQuickMenuType:(ZHNCfgQuickMenuType)type {
    switch (type) {
        case ZHNCfgQuickMenuTypeSetting:
        {
            [ZHNControllerPushManager zhn_pushViewControllerWithClass:[ZHNSettingViewController class]];
        }
            break;
        case ZHNCfgQuickMenuTypeChangeThemeColor:
        {
            [ZHNMainControllerColorPickerTrasitionHelper showColorPicker];
        }
            break;
        case ZHNCfgQuickMenuTypeChangeNightVersion:
        {
            [ZHNNightVersionChangeTransitionManager zhn_transition];
        }
            break;
        default:
        {
            [ZHNHudManager showWarning:@"TODO~"];
        }
            break;
    }
}

+ (NSArray <ZHNCosmosConfigQuickMenuItemModel *> *)configModelArray {
    ZHNCosmosConfigQuickMenuItemModel *itemModle1 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"切换暗色/亮色"
                                                     imageName:@"control_pad_night_moon"
                                                     isActive:YES
                                                     itemType:ZHNCfgQuickMenuTypeChangeNightVersion];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle2 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"设置"
                                                     imageName:@"control_pad_setting"
                                                     isActive:YES
                                                     itemType:ZHNCfgQuickMenuTypeSetting];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle3 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"网页阅读模式"
                                                     imageName:@"control_pad_reading_mode"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeWebViewReadingPattern];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle4 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"开/关音效"
                                                     imageName:@"control_pad_speaker_on"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeOnOffSound];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle5 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"切换字体"
                                                     imageName:@"control_pad_speaker_on"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeChangeFont];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle6 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"显示/隐藏图片"
                                                     imageName:@"control_pad_photo"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeShowHidePic];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle7 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"切换卡片样式"
                                                     imageName:@"control_pad_card_style_1"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeChangeCardType];
    
    ZHNCosmosConfigQuickMenuItemModel *itemModle8 = [ZHNCosmosConfigQuickMenuItemModel
                                                     modelWithItemName:@"切换主题颜色"                                                     
                                                     imageName:@"control_pad_paint_board"
                                                     isActive:NO
                                                     itemType:ZHNCfgQuickMenuTypeChangeThemeColor];
    return @[itemModle1,itemModle2,itemModle3,itemModle4,itemModle5,itemModle6,itemModle7,itemModle8];
}

@end
