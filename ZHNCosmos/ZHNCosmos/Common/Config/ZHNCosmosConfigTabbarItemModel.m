//
//  ZHNCosmosConfigTabbarItemModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosConfigTabbarItemModel.h"
#import "ZHNHomeTimelineViewController.h"
#import "ZHNCosmosTabbarController.h"
#import "ZHNCosmosTabbar.h"
#import "ZHNNavigationViewController.h"
#import "ZHNHomePageViewController.h"
#import "ZHNFavoriteTimelineViewController.h"
#import "ZHNDirectMessageViewController.h"
#import "ZHNHotAndSearchContainerViewController.h"
#import "ZHNMessageViewController.h"

@implementation ZHNCosmosConfigTabbarItemModel
+ (ZHNCosmosConfigTabbarItemModel *)modelWithItemName:(NSString *)itemName imageName:(NSString *)imageName itemType:(ZHNCosmosTabbarItemType)itemType isActive:(BOOL)isActive ctrClassName:(NSString *)ctrClassName {
    ZHNCosmosConfigTabbarItemModel *itemModel = [[ZHNCosmosConfigTabbarItemModel alloc]init];
    itemModel.itemName = itemName;
    itemModel.imageName = imageName;
    itemModel.type = itemType;
    itemModel.isActive = isActive;
    itemModel.controllerClassName = ctrClassName;
    return itemModel;
}

+ (void)configIfNeed {
    if ([ZHNCosmosConfigTabbarItemModel searchWithWhere:nil].count == 0) {
        [[ZHNCosmosConfigTabbarItemModel configModelArray] enumerateObjectsUsingBlock:^(ZHNCosmosConfigTabbarItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.orderIndex = idx;
            [obj saveToDB];
        }];
    }
}

+ (void)actionForTabbarItemModel:(ZHNCosmosConfigTabbarItemModel *)itemModel {
    ZHNCosmosTabbarController *tabbarController = (ZHNCosmosTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ZHNNavigationViewController *naviController = [tabbarController.tabbar.subControllerDict objectForKey:itemModel.itemName];
    if (!naviController) {
        UIViewController *rootViewController = [[NSClassFromString(itemModel.controllerClassName) alloc]init];
        naviController = [[ZHNNavigationViewController alloc]initWithRootViewController:rootViewController];
    }
    [tabbarController presentViewController:naviController animated:YES completion:nil];
}

+ (NSArray<ZHNCosmosConfigTabbarItemModel *> *)activeConfigTabbarItemModelArray {
    NSDictionary *dict = @{@"isActive":@(YES)};
    return [ZHNCosmosConfigTabbarItemModel searchWithWhere:dict orderBy:@"orderIndex" offset:0 count:100];
}

+ (NSArray<ZHNCosmosConfigTabbarItemModel *> *)nactiveConfigTabbarItemModelArry {
    NSDictionary *dict = @{@"isActive":@(NO)};
    return [ZHNCosmosConfigTabbarItemModel searchWithWhere:dict orderBy:@"orderIndex" offset:0 count:100];
}

+ (NSArray <ZHNCosmosConfigTabbarItemModel *> *)configModelArray {
    ZHNCosmosConfigTabbarItemModel *itemModel1 = [ZHNCosmosConfigTabbarItemModel
                                                  modelWithItemName:@"微博时间线"
                                                  imageName:@"tabbar_home_news"
                                                  itemType:ZHNCosmosTabbarItemTypeTimeline
                                                  isActive:YES
                                                  ctrClassName:NSStringFromClass([ZHNHomeTimelineViewController class])];
    
    ZHNCosmosConfigTabbarItemModel *itemModel2 = [ZHNCosmosConfigTabbarItemModel modelWithItemName:@"私信"
                                                  imageName:@"tab_direct_message"
                                                  itemType:ZHNCosmosTabbarItemTypeMessage
                                                  isActive:YES
                                                  ctrClassName:NSStringFromClass([ZHNDirectMessageViewController class])];
    
    ZHNCosmosConfigTabbarItemModel *itemModel3 = [ZHNCosmosConfigTabbarItemModel modelWithItemName:@"消息"
                                                  imageName:@"tabbar_message"
                                                  itemType:ZHNCosmosTabbarItemTypeDirect
                                                  isActive:YES
                                                  ctrClassName:NSStringFromClass([ZHNMessageViewController class])];
    
    ZHNCosmosConfigTabbarItemModel *itemModel4 = [ZHNCosmosConfigTabbarItemModel modelWithItemName:@"个人主页"
                                                  imageName:@"tabbar_smile"
                                                  itemType:ZHNCosmosTabbarItemTypePersonalCenter
                                                  isActive:YES
                                                  ctrClassName:NSStringFromClass([ZHNHomePageViewController class])];
    
    ZHNCosmosConfigTabbarItemModel *itemModel5 = [ZHNCosmosConfigTabbarItemModel modelWithItemName:@"收藏"
                                                  imageName:@"tabbar_star"
                                                  itemType:ZHNCosmosTabbarItemTypecollection
                                                  isActive:NO
                                                  ctrClassName:NSStringFromClass([ZHNFavoriteTimelineViewController class])];
    
    ZHNCosmosConfigTabbarItemModel *itemModel6 = [ZHNCosmosConfigTabbarItemModel modelWithItemName:@"热门搜索"
                                                  imageName:@"tab_search"
                                                  itemType:ZHNCosmosTabbarItemTypeHotAndSearch
                                                  isActive:NO
                                                  ctrClassName:NSStringFromClass([ZHNHotAndSearchContainerViewController class])];
    return @[itemModel1,itemModel2,itemModel3,itemModel4,itemModel5,itemModel6];
}

+ (NSString *)getPrimaryKey {
    return @"itemName";
}

@end
