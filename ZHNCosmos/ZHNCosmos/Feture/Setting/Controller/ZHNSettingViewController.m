//
//  ZHNCosmosSettingViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/18.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingViewController.h"
#import "ZHNSettingTapicEngineViewController.h"
#import "ZHNQuickMenuConfigViewController.h"
#import "ZHNTabbarConfigViewController.h"
#import "UIScrollView+ZHNTransitionManager.h"
#import "ZHNSettingRefreshViewController.h"
#import "ZHNSettingPicViewController.h"
#import "ZHNVisualAndAnimateViewController.h"

@interface ZHNSettingViewController ()

@end

@implementation ZHNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismissAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.sectionModelArray = @[[self section1Model],[self section2Model],[self section3Model]];
    [self.tableView reloadData];
    
    @weakify(self);
    [self.tableView zhn_needTransitionManagerWithDirection:ZHNScrollDirectionTop pointerMarging:0 transitonHanldle:^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (ZHNSettingSectionModel *)section1Model {
    @weakify(self);
    ZHNSettingCellModel *cellModel1 = [ZHNSettingCellModel normalModelWtiTitle:@"刷新"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                @strongify(self);
                                                                [self.navigationController pushViewController:[[ZHNSettingRefreshViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel2 = [ZHNSettingCellModel normalModelWtiTitle:@"图片"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                @strongify(self);
                                                                [self.navigationController pushViewController:[[ZHNSettingPicViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel3 = [ZHNSettingCellModel normalModelWtiTitle:@"视频"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel4 = [ZHNSettingCellModel normalModelWtiTitle:@"视觉与动画"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                [self.navigationController pushViewController:[[ZHNVisualAndAnimateViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel5 = [ZHNSettingCellModel normalModelWtiTitle:@"Taptic Engine"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                @strongify(self);
                                                                [self.navigationController pushViewController:[[ZHNSettingTapicEngineViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel6 = [ZHNSettingCellModel normalModelWtiTitle:@"屏蔽"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel7 = [ZHNSettingCellModel normalModelWtiTitle:@"统计"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    
    NSArray *cellArray = @[cellModel1,cellModel2,cellModel3,cellModel4,cellModel5,cellModel6,cellModel7];
    return [ZHNSettingSectionModel normalModelWithHeadDesc:@"通用"
                                                  footDesc:nil
                                     sectionCellModelArray:cellArray];
}

- (ZHNSettingSectionModel *)section2Model {
    @weakify(self);
    ZHNSettingCellModel *cellModel1 = [ZHNSettingCellModel normalModelWtiTitle:@"快捷菜单"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                @strongify(self);
                                                                [self.navigationController pushViewController:[[ZHNQuickMenuConfigViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel2 = [ZHNSettingCellModel normalModelWtiTitle:@"自定义底栏"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                                @strongify(self);
                                                                [self.navigationController pushViewController:[[ZHNTabbarConfigViewController alloc]init] animated:YES];
                                                            }];
    
    ZHNSettingCellModel *cellModel3 = [ZHNSettingCellModel normalModelWtiTitle:@"切换尾巴来源"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel4 = [ZHNSettingCellModel normalModelWtiTitle:@"拇指返回手势"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    NSArray *cellArray = @[cellModel1,cellModel2,cellModel3,cellModel4];
    return [ZHNSettingSectionModel normalModelWithHeadDesc:@"实验室"
                                                  footDesc:nil
                                     sectionCellModelArray:cellArray];
}

- (ZHNSettingSectionModel *)section3Model {
    ZHNSettingCellModel *cellModel1 = [ZHNSettingCellModel normalModelWtiTitle:@"常见问题"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel2 = [ZHNSettingCellModel normalModelWtiTitle:@"使用协议"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel3 = [ZHNSettingCellModel normalModelWtiTitle:@"使用反馈"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryNone
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel4 = [ZHNSettingCellModel normalModelWtiTitle:@"APP Store 评价"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryNone
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel5 = [ZHNSettingCellModel normalModelWtiTitle:@"Slack 交流群"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    ZHNSettingCellModel *cellModel6 = [ZHNSettingCellModel normalModelWtiTitle:@"开源协议"
                                                                  detail:nil
                                                                cellType:UITableViewCellAccessoryDisclosureIndicator
                                                            selectAction:^{
                                                            }];
    
    NSArray *cellArray = @[cellModel1,cellModel2,cellModel3,cellModel4,cellModel5,cellModel6];
    return [ZHNSettingSectionModel normalModelWithHeadDesc:@"其他"
                                                  footDesc:nil
                                     sectionCellModelArray:cellArray];
}


@end
