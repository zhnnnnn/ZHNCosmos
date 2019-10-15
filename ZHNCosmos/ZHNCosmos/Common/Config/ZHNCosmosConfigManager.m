//
//  ZHNCosmosConfigManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosConfigManager.h"

@interface ZHNCosmosConfigManager()
@property (nonatomic,strong) ZHNCosmosConfigCommonModel *commonModel;
@end

@implementation ZHNCosmosConfigManager
#pragma mark - public methods
+ (void)zhn_initializeConfigIfNeed {
    [ZHNCosmosConfigQuickMenuItemModel configIfNeed];
    [ZHNCosmosConfigTabbarItemModel configIfNeed];
    [ZHNCosmosConfigCommonModel configIfNeed];
}

+ (instancetype)shareinstance {
    static ZHNCosmosConfigManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNCosmosConfigManager alloc]init];
    });
    return manager;
}

+ (ZHNCosmosConfigCommonModel *)commonConfigModel {
    ZHNCosmosConfigCommonModel *commonModel = [ZHNCosmosConfigManager shareinstance].commonModel;
    if (!commonModel) {
        [ZHNCosmosConfigManager shareinstance].commonModel = [[ZHNCosmosConfigCommonModel searchWithWhere:nil]firstObject];
        return [ZHNCosmosConfigManager shareinstance].commonModel;
    }else {
        return commonModel;
    }
}

+ (void)updateCommonConfigWithDBname:(NSString *)dbname value:(int)value {
    ZHNCosmosConfigCommonModel *model = [ZHNCosmosConfigManager commonConfigModel];
    [model setValue:@(value) forKey:dbname];
    [model updateToDB];
    NSString *notificationName = [ZHNCosmosConfigCommonModel zhn_resetConfigSuccessNotificationNameForPropertyName:dbname];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

#pragma mark - getters
- (RACSubject *)reloadQuickMenuTabbarItemConfigSubject {
    if (_reloadQuickMenuTabbarItemConfigSubject == nil) {
        _reloadQuickMenuTabbarItemConfigSubject = [RACSubject subject];
    }
    return _reloadQuickMenuTabbarItemConfigSubject;
}

@end
