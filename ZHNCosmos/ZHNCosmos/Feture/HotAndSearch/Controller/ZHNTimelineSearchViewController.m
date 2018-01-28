//
//  ZHNTimelineSearchViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineSearchViewController.h"

@interface ZHNTimelineSearchViewController ()

@end

@implementation ZHNTimelineSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, 0, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/search/public.json";
}

- (ZHNResponseType)requestResponseType {
    return ZHNResponseTypeHTTP;
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    NSInteger pageID = 1;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            pageID = (NSInteger)(self.layoutArray.count / ([self everyRequestMaxCount])) + 1;
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
    [params zhn_safeSetObjetct:@"hasori" forKey:@"sort"];
    [params zhn_safeSetObjetct:@"t_search" forKey:@"sid"];
    return params;
}

#pragma mark - setters
- (void)setSearchWord:(NSString *)searchWord {
    _searchWord = searchWord;
    self.title = searchWord;
}
@end
