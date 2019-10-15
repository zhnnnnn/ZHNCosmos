//
//  ZHNSettingTapicEngineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingTapicEngineViewController.h"
#import "ZHNCosmosConfigCommonModel.h"
#import "ZHNRefreshHeader.h"

@interface ZHNSettingTapicEngineViewController ()

@end

@implementation ZHNSettingTapicEngineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tapic Engine";
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];

    ZHNSettingSectionModel *section1 = [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"TAPIC 震动反馈"
                                                                                 footDesc:nil
                                                                             dbConfigName:NSStringFromSelector(@selector(isNeedTapicEngine))
                                                                    sectionCellModelArray:@[cell1,cell2]];
    self.sectionModelArray = @[section1];
    [self.tableView reloadData];
    
    self.tableView.mj_header = [ZHNRefreshHeader headerWithRefreshingBlock:^{

    }];
}



@end
