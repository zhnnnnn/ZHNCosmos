//
//  ZHNCosmosEditingBaseViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNEditingBaseViewController.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNEditingBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHNEditingBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView setEditing:YES animated:NO];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(cickRightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - target action
- (void)cickRightItemAction {
    if (self.tableView.editing) {
        if ([self zhn_clickSaveExtraHandleIfSuccessEndEditing]) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableView setEditing:NO animated:YES];
        }
    }else {
        self.navigationItem.rightBarButtonItem.title = @"确定";
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.activeModelArray.count;
    }else {
        return self.nactiveModelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNEditingCell *cell = [[ZHNEditingCell alloc]init];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    [self zhn_tabviewCell:cell statusIntitalWithindexPath:indexPath];
    return cell;
}

- (void)zhn_tabviewCell:(UITableViewCell *)cell statusIntitalWithindexPath:(NSIndexPath *)indexPath {}
- (BOOL)zhn_clickSaveExtraHandleIfSuccessEndEditing {return YES;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 30)];
    UILabel *label = [[UILabel alloc]init];
    label.text = self.headerTitleArray[section];
    label.dk_textColorPicker = DKColorPickerWithKey(SettingHeaderTextColor);
    label.frame = CGRectMake(20, 0, K_SCREEN_WIDTH - 20, 30);
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    [header addSubview:label];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, 30)];
    UILabel *label = [[UILabel alloc]init];
    label.text = self.footerTitleArray[section];
    label.dk_textColorPicker = DKColorPickerWithKey(SettingHeaderTextColor);
    label.frame = CGRectMake(20, 0, K_SCREEN_WIDTH - 40, 40);
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    [footer addSubview:label];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            NSObject *obj = self.activeModelArray[indexPath.row];
            [self.activeModelArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.nactiveModelArray insertObject:obj atIndex:0];
            NSIndexPath *movetoIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [tableView insertRowsAtIndexPaths:@[movetoIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case UITableViewCellEditingStyleInsert:
        {
            NSObject *obj = self.nactiveModelArray[indexPath.row];
            [self.nactiveModelArray removeObjectAtIndex:indexPath.row];
            [self.activeModelArray addObject:obj];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.activeModelArray.count - 1 inSection:0]];
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"移除";
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [self.activeModelArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }else {
        NSObject *obj = self.activeModelArray[sourceIndexPath.row];
        [self.activeModelArray removeObjectAtIndex:sourceIndexPath.row];
        NSInteger index = destinationIndexPath.row;
        [self.nactiveModelArray insertObject:obj atIndex:index];
        [tableView reloadData];
    }
}

#pragma mark - tableView
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(ToolViewBG);
        _tableView.dk_separatorColorPicker = DKColorPickerWithKey(SettingSeparatorColor);
    }
    return _tableView;
}

@end
////////////////////////////////////////////////////////
@implementation ZHNEditingCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake (12,12,20,20);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textLabel.frame = CGRectMake(50, self.textLabel.y, self.textLabel.width, self.textLabel.height);
    self.separatorInset = UIEdgeInsetsMake(0, self.textLabel.x, 0, 0);
}


@end


