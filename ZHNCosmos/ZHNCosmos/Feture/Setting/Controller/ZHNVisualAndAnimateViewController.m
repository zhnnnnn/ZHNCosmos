//
//  ZHNVisualAndAnimateViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/18.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNVisualAndAnimateViewController.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNVisualAndAnimateViewController ()

@end

@implementation ZHNVisualAndAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视觉与动画";
    self.sectionModelArray = @[[self section1],[self section2],[self section3],[self section4],[self section5],[self section6]];
    [self.tableView reloadData];
}

- (ZHNSettingSectionModel *)section1 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"每天随机切换主题色"
                                                      footDesc:@"若开启，每天会随机在候选的主题色里选其一显示"
                                                  dbConfigName:NSStringFromSelector(@selector(everydayRandomThemeColor))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section2 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"导航栏适应主题色"
                                                      footDesc:@"若开启，状态栏会随着主题颜色改变"
                                                  dbConfigName:NSStringFromSelector(@selector(navigationbarFitThemeColor))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section3 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"动态缩小导航栏"
                                                      footDesc:@"若开启，滑动列表会自动缩小导航栏以获得更多的阅读空间"
                                                  dbConfigName:NSStringFromSelector(@selector(dynamicScrollNavibar))
                                         sectionCellModelArray:@[cell1,cell2]];
}


- (ZHNSettingSectionModel *)section4 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"手指触摸动画"
                                                      footDesc:@"若开启，手指触摸UI时会有一个缩小的动画"
                                                  dbConfigName:NSStringFromSelector(@selector(touchViewTransfromAnimate))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section5 {
    
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"左右"
                                                           ifSelctConfigValue:controllerTransitionTypeUpDown];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"上下"
                                                           ifSelctConfigValue:controllerTransitionTypeLeftRight];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"页面切换动画"
                                                      footDesc:nil
                                                  dbConfigName:NSStringFromSelector(@selector(transitionType))
                                         sectionCellModelArray:@[cell1,cell2]];
}

- (ZHNSettingSectionModel *)section6 {
    ZHNSettingCellModel *cell1 = [ZHNSettingCellModel checkMarkModelWithTitle:@"开启"
                                                           ifSelctConfigValue:YES];
    
    ZHNSettingCellModel *cell2 = [ZHNSettingCellModel checkMarkModelWithTitle:@"关闭"
                                                           ifSelctConfigValue:NO];
    
    return  [ZHNSettingSectionModel checkmarkModelWithHeadDesc:@"底栏切换动画"
                                                      footDesc:@"若开启，切换底栏的时候会有过度动画"
                                                  dbConfigName:NSStringFromSelector(@selector(tabbarControllerTransionAnimate))
                                         sectionCellModelArray:@[cell1,cell2]];
}

@end
