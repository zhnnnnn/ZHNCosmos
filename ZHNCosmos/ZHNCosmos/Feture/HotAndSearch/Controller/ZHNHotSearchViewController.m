//
//  ZHNHotSearchViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotSearchViewController.h"
#import "ZHNRefreshHeader.h"
#import "ZHNHotSearchModel.h"
#import "ZHNHotSearchCellNode.h"
#import "UIView+ZHNSnapchot.h"
#import "ZHNSearchedTimelineViewController.h"

@interface ZHNHotSearchViewController ()<ASTableDelegate,ASTableDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) NSArray *hotSearchs;
@property (nonatomic,strong) NSArray *hotSearchCards;
@property (nonatomic,strong) ZHNHotSearchCardGroupModel *titleCard;
@end

@implementation ZHNHotSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubnode:self.tableNode];
    self.tableNode.frame = self.view.bounds;
    
    @weakify(self);
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        self.tableNode.backgroundColor = ZHNCurrentThemeFitColorForkey(CellBG);
        self.tableNode.view.separatorColor = ZHNCurrentThemeFitColorForkey(HotCellSeparatorColor);
    };
    
    self.tableNode.view.mj_header = [ZHNRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self p_loadData];
    }];
    [self p_loadData];
}



- (void)reloadNavigationDalegate {}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.hotSearchCards.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNHotSearchCellNode *cellNode = [[ZHNHotSearchCellNode alloc]init];
    cellNode.cardModel = self.hotSearchCards[indexPath.row];
    return cellNode;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableNode deselectRowAtIndexPath:indexPath animated:YES];
    ZHNHotSearchCardGroupModel *model = self.hotSearchCards[indexPath.row];
    ZHNSearchedTimelineViewController *seachedController = [[ZHNSearchedTimelineViewController alloc]init];
    seachedController.searchKeyword = model.desc;
    [self.navigationController pushViewController:seachedController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView yy_setImageWithURL:[NSURL URLWithString:self.titleCard.titlePic] placeholder:nil];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blank_data_placeholder"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -K_Navibar_height;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - pravite methods
- (void)p_loadData {
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@"106003type%3D25%26t%3D3%26disable_hot%3D1%26filter_type%3Drealtimehot" forKey:@"containerid"];
    [params zhn_safeSetObjetct:@"20" forKey:@"count"];
    [params zhn_safeSetObjetct:@"1055095010" forKey:@"from"];
    [params zhn_safeSetObjetct:@"1" forKey:@"page"];
    [params zhn_safeSetObjetct:@"211160679" forKey:@"source"];
    @weakify(self);
    
    // Fix asyncdisplay refresh flash bug. Through comparison, i think this is the better way, because its easier and it`s works well. u can compare with `ZHNAsyncDisplayTableNodeBaseViewController`
    UIImageView *refreshPlaceholder = [[UIImageView alloc]init];
    refreshPlaceholder.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    refreshPlaceholder.image = [self.tableNode.view zhn_layerSnapchot];
    [self.tableNode.view addSubview:refreshPlaceholder];
    
    [ZHNNETWROK get:@"https://api.weibo.cn/2/page" params:params responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
        @strongify(self);
        self.hotSearchs = [NSArray yy_modelArrayWithClass:[ZHNHotSearchModel class] json:result[@"cards"]];
        for (ZHNHotSearchModel *hotSearch in self.hotSearchs) {
            if ([hotSearch.itemid isEqualToString:@"title_pic"]) {
                self.titleCard = [hotSearch.cardGroup firstObject];
            }
            if ([hotSearch.itemid isEqualToString:@"hotword"]) {
                self.hotSearchCards = hotSearch.cardGroup;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNode reloadData];
            [self.tableNode.view.mj_header endRefreshing];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [refreshPlaceholder removeFromSuperview];
            });
        });
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
    }];
}

#pragma mark - getters
- (ASTableNode *)tableNode {
    if (_tableNode == nil) {
        _tableNode = [[ASTableNode alloc]initWithStyle:UITableViewStyleGrouped];
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        _tableNode.view.emptyDataSetSource = self;
        _tableNode.view.emptyDataSetDelegate = self;
    }
    return _tableNode;
}
@end
