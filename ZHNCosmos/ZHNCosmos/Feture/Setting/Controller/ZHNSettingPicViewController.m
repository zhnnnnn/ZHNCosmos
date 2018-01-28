//
//  ZHNSettingPicViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingPicViewController.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNSettingPicViewController ()

@end

@implementation ZHNSettingPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片";
    self.sectionModelArray = @[[self section1],[self section2],[self section3],[self section4],[self section5]];
    [self.tableView reloadData];
}

- (ZHNSettingSectionModel *)section1 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"中等 (720)"
                                                           ifSelctConfigValue:bigpicQualityMiddle_720P];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"原图"
                                                           ifSelctConfigValue:bigpicQualityOriginal_large];
    
    ZHNSettingCellModel *cell3 = [ZHNSettingCellModel checkMarkModelWithTitle:@"智能"
                                                           ifSelctConfigValue:bigpicQualitySmart];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"大图质量"
                                                      footDesc:@"智能：Wifi环境下点开大图加载原图，蜂窝环境下点开大图若没有大图缓存则加载中等质量"
                                                  dbConfigName:NSStringFromSelector(@selector(bigpicQuality))
                                         sectionCellModelArray:@[cell1,cell2,cell3]];
}

- (ZHNSettingSectionModel *)section2 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"显示"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"不显示"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"显示大图流量角标"
                                                      footDesc:@"提前获取查看大图需要耗费的流量（当且仅当蜂窝网络下显示）"
                                                  dbConfigName:NSStringFromSelector(@selector(isShowFlowCorner))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section3 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:bigpicPreloadOn];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:bigpicPreloadOff];
    
    ZHNSettingCellModel *cell3 = [ZHNSettingCellModel checkMarkModelWithTitle:@"智能"
                                                           ifSelctConfigValue:bigpicPreloadSmart];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"大图预加载"
                                                      footDesc:@"启用预加载，查看大图无需等待"
                                                  dbConfigName:NSStringFromSelector(@selector(bigpicPreload))
                                         sectionCellModelArray:@[cell1,cell2,cell3]];
}

- (ZHNSettingSectionModel *)section4 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"显示"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"不显示"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"加载大图时显示遮罩"
                                                      footDesc:@"当你点击一张图片准备放大查看的时候，有可能这张图片还是首次查看（没有缓存），这时你可以选择先显示一个遮罩让其后台加载，然后继续浏览其他内容，等后台加载完再看"
                                                  dbConfigName:NSStringFromSelector(@selector(isLoadbigpicshowMask))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section5 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"中等"
                                                           ifSelctConfigValue:bigpicPreloadOn];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"原图"
                                                           ifSelctConfigValue:bigpicPreloadOff];
    
    ZHNSettingCellModel *cell3 = [ZHNSettingCellModel checkMarkModelWithTitle:@"智能"
                                                           ifSelctConfigValue:bigpicPreloadSmart];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"图片上传质量"
                                                      footDesc:@"智能：Wifi环境下切换到高质量，蜂窝环境下切换到中等质量"
                                                  dbConfigName:NSStringFromSelector(@selector(bigpicPreload))
                                         sectionCellModelArray:@[cell1,cell2,cell3]];
}


@end
