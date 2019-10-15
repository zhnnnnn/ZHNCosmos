//
//  ZHNHotTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotTimelineViewController.h"
#import "RACSignal+statusMapping.h"

@interface ZHNHotTimelineViewController ()

@end

@implementation ZHNHotTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load data
    [[self loadDataWithType:ZHNfetchDataTypeLoadLatest]
     subscribeNext:^(id x) {
    }];
    
    // Fix add childViewController cause touch bug
    self.tableView.panGestureRecognizer.cancelsTouchesInView = YES;
    
    // Manual observe to reload data
    [self manualObserveReloadTimelineRichText];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)reloadNavigationDalegate {
}

- (NSString *)requestURL {
    return @"https://api.weibo.cn/2/statuses/unread_hot_timeline";
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    NSInteger maxID = 1;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            maxID = (int)(self.layoutArray.count / [self everyRequestMaxCount]) + 1;
        }
            break;
        default:
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@"102803_ctg1_8999_-_ctg1_8999_home" forKey:@"containerid"];
    [params zhn_safeSetObjetct:@([self everyRequestMaxCount]) forKey:@"count"];
    [params zhn_safeSetObjetct:@"discover|new_feed" forKey:@"extparam"];
    [params zhn_safeSetObjetct:@"10000001" forKey:@"featurecode"];
    [params zhn_safeSetObjetct:@"102803_ctg1_8999_-_ctg1_8999_home" forKey:@"fid"];
    [params zhn_safeSetObjetct:@"1055095010" forKey:@"from"];
    [params zhn_safeSetObjetct:@"1028038999" forKey:@"fromlog"];
    [params zhn_safeSetObjetct:@"10000001" forKey:@"luicode"];
    [params zhn_safeSetObjetct:@(maxID) forKey:@"max_id"];
    [params zhn_safeSetObjetct:@"1" forKey:@"need_jump_scheme"];
    [params zhn_safeSetObjetct:@"-1" forKey:@"preAdInterval"];
    [params zhn_safeSetObjetct:@"auto" forKey:@"refresh"];
    [params zhn_safeSetObjetct:@"0" forKey:@"since_id"];
    [params zhn_safeSetObjetct:@"211160679" forKey:@"source"];
    [params zhn_safeSetObjetct:@"1" forKey:@"trim_level"];
    [params zhn_safeSetObjetct:@"0" forKey:@"trim_page_recom"];
    [params zhn_safeSetObjetct:@"10000495" forKey:@"uicode"];
    return params;
}
@end
