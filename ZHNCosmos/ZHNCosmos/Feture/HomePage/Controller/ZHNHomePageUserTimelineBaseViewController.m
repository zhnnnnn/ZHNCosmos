//
//  ZHNUserAllTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNHomePageUserTimelineBaseViewController.h"

@implementation ZHNHomePageUserTimelineBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 0;
    self.panControllPopGesture.enabled = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(K_statusBar_height, 0, K_Navibar_height, 0);
    // Fix add childViewController cause touch bug
    self.tableView.panGestureRecognizer.cancelsTouchesInView = YES;
}

- (void)reloadNavigationDalegate {
}

- (void)initializeLayoutsWithCachesIfHave {
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/statuses/user_timeline.json";
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    unsigned long long sinceID = 0;
    unsigned long long maxID = [self currentMaxIDForFetchDataType:type];
    ZHNUserMetaDataModel *user = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:user.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(25) forKey:@"count"];
    [params zhn_safeSetObjetct:@(self.uid) forKey:@"uid"];
    [params zhn_safeSetObjetct:@(self.userStatusType) forKey:@"feature"];
    [params zhn_safeSetObjetct:@(sinceID) forKey:@"since_id"];
    [params zhn_safeSetObjetct:@(maxID) forKey:@"max_id"];
    return params;
}

- (void)fetchedDataProcessing:(NSArray *)fetchedLatoutArray fetchDataType:(ZHNfetchDataType)fetchType {
    switch (fetchType) {
        case ZHNfetchDataTypeLoadCache:
        case ZHNfetchDataTypeLoadLatest:
        {
            self.layoutArray = fetchedLatoutArray;
            [[self cacheModelCalss] performSelector:@selector(zhn_deleteAllLayots)];
            [[self cacheModelCalss] performSelector:@selector(zhn_saveTimelineLayouts:) withObject:fetchedLatoutArray];
        }
            break;
        case ZHNfetchDataTypeLoadMore:
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.layoutArray];
            [tempArray addObjectsFromArray:fetchedLatoutArray];
            self.layoutArray = [tempArray copy];
        }
            break;
    }
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(homepageTableViewDidScroll:)]) {
        [self.delegate homepageTableViewDidScroll:scrollView];
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -self.view.y + 80;
}
@end
