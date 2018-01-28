//
//  ZHNSettingRefreshViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingRefreshViewController.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNSettingRefreshViewController ()

@end

@implementation ZHNSettingRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionModelArray = @[[self section1],[self section2],[self section3],[self section4],[self section5]];
    [self.tableView reloadData];
}

- (ZHNSettingSectionModel *)section1 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"高亮显示链接来源"
                                                      footDesc:@"若开启，可能会使每次刷新需要更多的时间"
                                                  dbConfigName:NSStringFromSelector(@selector(isHightlightShowUrl))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section2 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"发布微博后自动刷新首页"
                                                      footDesc:nil
                                                  dbConfigName:NSStringFromSelector(@selector(isNeedAutoRefreshAfterPublish))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section3 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"顺序"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"倒序"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"刷新方式"
                                                      footDesc:nil
                                                  dbConfigName:NSStringFromSelector(@selector(isRefreshPositiveSequence))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section4 {
    
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"20"
                                                           ifSelctConfigValue:everytimeRefeshCount20];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"50"
                                                           ifSelctConfigValue:everytimeRefeshCount50];
    
    ZHNSettingCellModel *cell3 = [ZHNSettingCellModel checkMarkModelWithTitle:@"100"
                                                           ifSelctConfigValue:everytimeRefeshCount100];

    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"每次刷新条数"
                                                      footDesc:nil
                                                  dbConfigName:NSStringFromSelector(@selector(everytimeRefeshCount))
                                         sectionCellModelArray:@[cell1,cell2,cell3]];
}

- (ZHNSettingSectionModel *)section5 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"200"
                                                           ifSelctConfigValue:maxTimelineCacheCount200];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"350"
                                                           ifSelctConfigValue:maxTimelineCacheCount350];
    
    ZHNSettingCellModel *cell3 = [ZHNSettingCellModel checkMarkModelWithTitle:@"500"
                                                           ifSelctConfigValue:maxTimelineCacheCount500];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"最大缓存微博条数"
                                                      footDesc:nil
                                                  dbConfigName:NSStringFromSelector(@selector(maxTimelineCacheCount))
                                         sectionCellModelArray:@[cell1,cell2,cell3]];
}

@end
