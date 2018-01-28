//
//  ZHNTimelineLikeController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/10.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineLikeController.h"
#import "ZHNStatusCell.h"
#import "ZHNDetailLikeTableViewCell.h"
#import "ZHNRefreshHeader.h"
#import "ZHNRefreshFooter.h"
#import "ZHNDetailLikeSectionHeader.h"
#import "ZHNTimelineModel.h"
#import "NSObject+ZHNSafeJSON.h"
#import "ZHNHomePageViewController.h"

static NSInteger const KeveryRequestMaxCount = 50;
typedef NS_ENUM(NSInteger,ZHNLikeControllerSectionType) {
    ZHNLikeControllerSectionTypeDetail = 0,
    ZHNLikeControllerSectionTypeLike = 1
};
@interface ZHNTimelineLikeController ()
@property (nonatomic,strong) NSArray <ZHNTimelineStatus*> *statuses;
@property (nonatomic,assign) int page;
@end

@implementation ZHNTimelineLikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 0;
    self.panControllPopGesture.enabled = NO;
    self.tableView.panGestureRecognizer.cancelsTouchesInView = YES;
    self.page = 1;
}

- (void)zhn_detailBeginInitData {
    if (self.didAppeared) {return;}
    self.didAppeared = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)reloadNavigationDalegate {}
- (void)initializeScrollIndicator {}

- (void)initializeRefreshHeader {
    @weakify(self);
    self.tableView.mj_header = [ZHNRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self p_loadDataWithType:ZHNfetchDataTypeLoadLatest];
    }];
}

- (void)initializeRefreshFooter {
    @weakify(self);
    self.tableView.mj_footer = [ZHNRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self p_loadDataWithType:ZHNfetchDataTypeLoadMore];
    }];
}

#pragma mark - tableView delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ZHNLikeControllerSectionTypeDetail:
        {
            return 1;
        }
            break;
        case ZHNLikeControllerSectionTypeLike:
        {
            return self.statuses.count;
        }
            break;
        default:
            return 1;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == ZHNLikeControllerSectionTypeLike) {
        ZHNDetailLikeSectionHeader *header = [[ZHNDetailLikeSectionHeader alloc]init];
        header.likeNumStr = self.detailBasic.attitudes;
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == ZHNLikeControllerSectionTypeLike) {
        return 30;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ZHNLikeControllerSectionTypeDetail:
        {
            ZHNStatusCell *cell = [ZHNStatusCell zhn_statusCellWithTableView:tableView];
            cell.layout = self.layout;
            return cell;
        }
            break;
        case ZHNLikeControllerSectionTypeLike:
        {
            ZHNDetailLikeTableViewCell *cell = [ZHNDetailLikeTableViewCell zhn_detailLikeCellWithTableView:tableView];
            cell.user = [self.statuses[indexPath.row] user];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ZHNLikeControllerSectionTypeDetail:
            return self.layout.rowHeight + 10;
            break;
        default:
            return 44;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ZHNLikeControllerSectionTypeLike:
        {
            ZHNHomePageViewController *homePageController = [[ZHNHomePageViewController alloc]init];
            homePageController.homepageUser = [self.statuses[indexPath.row] user];
            [self.navigationController pushViewController:homePageController animated:YES];
        }
            break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - pravite methods
- (void)p_loadDataWithType:(ZHNfetchDataType)fetchDataType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(KeveryRequestMaxCount) forKey:@"count"];
    [params zhn_safeSetObjetct:@(1079493010) forKey:@"from"];
    [params zhn_safeSetObjetct:@(self.layout.statusID) forKey:@"id"];
    [params zhn_safeSetObjetct:@(self.page) forKey:@"page"];
    [params zhn_safeSetObjetct:@(2781539112) forKey:@"source"];
    @weakify(self);
    [ZHNNETWROK get:@"https://api.weibo.com/2/attitudes/show.json" params:params responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
        @strongify(self);
        NSArray *statuesArray = [NSArray yy_modelArrayWithClass:[ZHNTimelineStatus class] json:[result zhn_SJMapKey:@"attitudes"]];
        if (statuesArray.count > 0) {
            self.page++;
        }
        switch (fetchDataType) {
            case ZHNfetchDataTypeLoadLatest:
            {
                self.statuses = statuesArray;
            }
                break;
            case ZHNfetchDataTypeLoadMore:
            {
                NSMutableArray *muStauesArray = [self.statuses mutableCopy];
                [muStauesArray addObjectsFromArray:statuesArray];
                self.statuses = [muStauesArray copy];
            }
                break;
            default:
                break;
        }
        
        if (statuesArray.count == KeveryRequestMaxCount) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - setters
- (void)setDetailBasic:(ZHNDetailBasicModel *)detailBasic {
    _detailBasic = detailBasic;
    [self.tableView reloadData];
}
@end
