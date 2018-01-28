//
//  ZHNSearchTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSearchedTimelineViewController.h"

@implementation ZHNSearchedTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.searchKeyword;
       self.tableView.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.didAppeared) {return;}
    self.didAppeared = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/search/public.json";
}

- (NSArray *)requestResultArrayMapKeyOrderArray {
    return @[@"statuses"];
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    int pageID = 1;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            pageID = (int)(self.layoutArray.count / 25) + 1;
        }
            break;
        default:
            break;
    }

    ZHNUserMetaDataModel *user = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:user.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(25) forKey:@"count"];
    [params zhn_safeSetObjetct:@(pageID) forKey:@"page"];
    [params zhn_safeSetObjetct:@"t_search" forKey:@"sid"];
    [params zhn_safeSetObjetct:@"hasori" forKey:@"sort"];
    [params zhn_safeSetObjetct:[self p_fitForAPISearchKeyword] forKey:@"q"];
    return params;
}

- (ZHNResponseType)requestResponseType {
    return ZHNResponseTypeHTTP;
}

- (NSString *)p_fitForAPISearchKeyword {
    if ([self.searchKeyword containsString:@"@"]) {
        return [self.searchKeyword substringFromIndex:1];
    }
    if ([self.searchKeyword containsString:@"#"]) {
        return [self.searchKeyword substringWithRange:NSMakeRange(1, self.searchKeyword.length - 2)];
    }
    return self.searchKeyword;
}

@end
