//
//  ZHNCosmosConfigManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNCosmosConfigQuickMenuItemModel.h"
#import "ZHNCosmosConfigTabbarItemModel.h"
#import "ZHNCosmosConfigCommonModel.h"

typedef NS_ENUM(NSInteger,ZHNConfigReloadType) {
    ZHNConfigReloadTypeTabbar,
    ZHNConfigReloadTypeQuickMenu,
};
@interface ZHNCosmosConfigManager : NSObject
/**
 instance method

 @return instance
 */
+ (instancetype)shareinstance;

/**
 init config if need
 */
+ (void)zhn_initializeConfigIfNeed;

/**
 get common config model `ZHNCosmosConfigCommonModel`

 @return model
 */
+ (ZHNCosmosConfigCommonModel *)commonConfigModel;

/**
 update common config

 @param dbname db name
 @param value db value
 */
+ (void)updateCommonConfigWithDBname:(NSString *)dbname value:(int)value;

/**
 reload quick menu tabbar item config
 */
@property (nonatomic,strong) RACSubject *reloadQuickMenuTabbarItemConfigSubject;
@end
