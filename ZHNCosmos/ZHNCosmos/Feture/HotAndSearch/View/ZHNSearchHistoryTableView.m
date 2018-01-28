//
//  ZHNSearchHistoryTableView.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNSearchHistoryTableView.h"
#import "UIScrollView+ZHNTransitionManager.h"

static NSString *const KReuseKey = @"KReuseKey";
@interface ZHNSearchHistoryTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *searchWordModels;
@end

@implementation ZHNSearchHistoryTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.alpha = 0;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:KReuseKey];
        self.searchWordModels = [ZHNSearchHistoryModel searchWithWhere:nil];
        
        // Scroll to dismiss
        @weakify(self);
        [self zhn_needTransitionManagerWithDirection:ZHNScrollDirectionTop pointerMarging:0 transitonHanldle:^{
            @strongify(self);
            [self.historyDelegate ZHNSearchHoistoryTableViewScrollToDismiss];
        }];
        
        // Tablefooter
        UIButton *clearCacheBtn = [[UIButton alloc]init];
        clearCacheBtn.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        [clearCacheBtn setTitle:@"删除全部历史记录" forState:UIControlStateNormal];
        clearCacheBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [clearCacheBtn setTitleColor:[ZHNThemeManager zhn_getThemeColor] forState:UIControlStateNormal];
        self.tableFooterView = clearCacheBtn;
        [[clearCacheBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [ZHNSearchHistoryModel deleteWithWhere:nil];
            self.searchWordModels = nil;
            [self reloadData];
        }];
        
        // Clear btn
        [RACObserve(self, self.searchWordModels) subscribeNext:^(NSArray *searchWords) {
            if (searchWords.count == 0) {
                clearCacheBtn.hidden = YES;
            }else {
                clearCacheBtn.hidden = NO;
            }
        }];
        
        // ThemeColor change
        self.extraThemeColorChangeHandle = ^{
            [clearCacheBtn setTitleColor:[ZHNThemeManager zhn_getThemeColor] forState:UIControlStateNormal];
        };
        
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            self.backgroundColor = ZHNCurrentThemeFitColorForkey(ToolViewBG);
            self.separatorColor = ZHNCurrentThemeFitColorForkey(SettingSeparatorColor);
            [self reloadData];
        };
    }
    return self;
}

- (void)addSearchWord:(NSString *)searchWord {
    // Cache word
    ZHNSearchHistoryModel *model = [[ZHNSearchHistoryModel alloc]init];
    model.searhWord = searchWord;
    [model saveToDB];
    // Reload tableView
    self.searchWordModels = [ZHNSearchHistoryModel searchWithWhere:nil];
    [self reloadData];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchWordModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KReuseKey];
    ZHNSearchHistoryModel *model = self.searchWordModels[indexPath.row];
    cell.textLabel.text = model.searhWord;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    @weakify(cell);
    cell.extraNightVersionChangeHandle = ^{
        @strongify(cell);
        UIView *selectView = [[UIView alloc]init];
        selectView.dk_backgroundColorPicker = DKColorPickerWithKey(CellSelectedColor);
        cell.selectedBackgroundView = selectView;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHNSearchHistoryModel *model = self.searchWordModels[indexPath.row];
    [self.historyDelegate ZHNSearchHoistoryTableViewCilickToSearchWord:model.searhWord];
}

@end

/////////////////////////////////////////////////////
@implementation ZHNSearchHistoryModel
+ (NSString *)getTableName {
    return @"ZHNSearchHistoryTable";
}

+ (NSString *)getPrimaryKey {
    return @"searhWord";
}
@end
