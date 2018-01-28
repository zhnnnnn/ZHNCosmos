//
//  ZHNCosmosSettingBaseViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingBaseViewController.h"
#import "ZHNCosmosConfigManager.h"
#import "UITableViewCell+ZHNSelectColor.h"

@interface ZHNSettingBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHNSettingBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[section];
    return sectionModel.cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingBaseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingBaseCell"];
        cell.selectColorFitnightVersion = YES;
    }
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
    ZHNSettingCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
    cell.textLabel.text = cellModel.title;
    cell.detailTextLabel.text = cellModel.detail;
    cell.tintColor = [ZHNThemeManager zhn_getThemeColor];
    cell.accessoryType = cellModel.type;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    cell.detailTextLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    // for checkmark
    if (sectionModel.DBConfigName) {
        int cache = [[[ZHNCosmosConfigManager commonConfigModel] valueForKey:sectionModel.DBConfigName] intValue];
        if (cache  == cellModel.ifSelectConfigValue) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[section];
    return [self p_headerFooterIntitalWithTitle:sectionModel.headDesc];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[section];
    return [self p_headerFooterIntitalWithTitle:sectionModel.footDesc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[section];
    return [sectionModel headerHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[section];
    return [sectionModel footerHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHNSettingSectionModel *sectionModel = self.sectionModelArray[indexPath.section];
    // check mark
    if (sectionModel.DBConfigName) {
        // clear all check mark
        [sectionModel.cellModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *tempPath = [NSIndexPath indexPathForRow:idx inSection:indexPath.section];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:tempPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }];
        // select current check mark
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        // cache
        ZHNSettingCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
        [ZHNCosmosConfigManager updateCommonConfigWithDBname:sectionModel.DBConfigName
                                                       value:cellModel.ifSelectConfigValue];
    }else {
        // action
        ZHNSettingCellModel *cellModel = sectionModel.cellModelArray[indexPath.row];
        if (cellModel.selectBlock) {
            cellModel.selectBlock();
        }
    }
}

#pragma mark - pravite methods
- (UIView *)p_headerFooterIntitalWithTitle:(NSString *)title {
    CGFloat height = [ZHNSettingSectionModel heightWithString:title];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, height)];
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.dk_textColorPicker = DKColorPickerWithKey(SettingHeaderTextColor);
    label.frame = CGRectMake(KHeaderFooterLabelPadding, 0, K_SCREEN_WIDTH - KHeaderFooterLabelPadding, height);
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    [view addSubview:label];
    return view;
}

#pragma mark - getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(ToolViewBG);
        _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SettingSeparatorColor);
        if(@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(K_navigationBar_content_height + K_statusBar_height, 0, 0, 0);
    }
    return _tableView;
}

@end
