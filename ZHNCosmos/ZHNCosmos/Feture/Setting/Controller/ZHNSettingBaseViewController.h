//
//  ZHNCosmosSettingBaseViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNSettingCellModel.h"
#import "ZHNSettingSectionModel.h"

static NSString const *KSettingSectionTypeKey = @"KSettingSectionTypeKey";
static NSString const *KSettingSectionHeaderKey = @"KSettingSectionHeaderKey";
static NSString const *KSettingSectionFooterKey = @"KSettingSectionFooterKey";
static NSString const *KSettingCellTitleKey = @"KSettingCellTitleKey";
static NSString const *KSettingCellDetailKey = @"KSettingCellDetailKey";
static NSString const *KSettingAcceAccessoryTypeKey = @"KSettingAcceAccessoryTypeKey";
static NSString const *KSettingCellSelectBlockKey = @"KSettingCellSelectBlockKey";

@interface ZHNSettingBaseViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
/**
 initialize status model
 */
@property (nonatomic,copy) NSArray <ZHNSettingSectionModel *> *sectionModelArray;
@end
