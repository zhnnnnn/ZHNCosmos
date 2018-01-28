//
//  ZHNUserSearchViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNUserSearchViewController.h"
#import "ZHNSearchUserCellNode.h"
#import "ZHNHomePageViewController.h"

@interface ZHNUserSearchViewController ()

@end

@implementation ZHNUserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableNode.view.mj_header beginRefreshing];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.panControllPopGesture.enabled = YES;
    self.navigationController.delegate = self;
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/search/users.json";
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray {
    return @[@"users"];
}

- (Class)displayTableNode_dataClass {
    return [ZHNTimelineUser class];
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    NSInteger pageID = 1;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            pageID = (NSInteger)(self.statusArray.count / ([self everyRequestMaxCount])) + 1;
        }
            break;
        default:
            break;
    }
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@([self everyRequestMaxCount]) forKey:@"count"];
    [params zhn_safeSetObjetct:@(pageID) forKey:@"page"];
    [params zhn_safeSetObjetct:self.searchWord forKey:@"q"];
    [params zhn_safeSetObjetct:@"2" forKey:@"sort"];
    return params;
}

#pragma mark - tableNode dataSource
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNSearchUserCellNode *CellNode = [[ZHNSearchUserCellNode alloc]init];
    CellNode.user = self.statusArray[indexPath.row];
    return CellNode;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableNode:tableNode didSelectRowAtIndexPath:indexPath];
    ZHNHomePageViewController *controller = [[ZHNHomePageViewController alloc]init];
    controller.homepageUser = self.statusArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - setters
- (void)setSearchWord:(NSString *)searchWord {
    _searchWord = searchWord;
    self.title = [NSString stringWithFormat:@"搜索：%@",searchWord];
}
@end
