//
//  ZHNTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNHomeTimelineViewController.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"
#import "ZHNUserMetaDataModel.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNOrdinaryCacheManager.h"
#import "ZHNTabbarItemNotificationManager.h"

@implementation ZHNHomeTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部微博";
    self.tableView.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, K_tabbar_height, 0);
    
    @weakify(self);
    [[self loadDataWithType:ZHNfetchDataTypeLoadCache]
     subscribeCompleted:^{
         @strongify(self);
         CGFloat x = self.tableView.contentOffset.x;
         CGFloat y = [ZHNOrdinaryCacheManager zhn_hometimelineWatchedOffsety];
         if (y == KWatchedOffsetyFirstload) {return;}
         [self.tableView setContentOffset:CGPointMake(x, y) animated:NO];
     }];
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/statuses/home_timeline.json";
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    unsigned long long maxID = [self currentMaxIDForFetchDataType:type];
    unsigned long long sinceID = [self currentSinceIDForFetchDataType:type];
    ZHNUserMetaDataModel *user = [ZHNUserMetaDataModel displayUserMetaData];
    ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:user.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(common.everytimeRefeshCount) forKey:@"count"];
    [params zhn_safeSetObjetct:@(0) forKey:@"feature"];
    [params zhn_safeSetObjetct:@(1) forKey:@"page"];
    [params zhn_safeSetObjetct:@(maxID) forKey:@"max_id"];
    [params zhn_safeSetObjetct:@(sinceID) forKey:@"since_id"];
    return params;
}

- (NSInteger)everyRequestMaxCount {
    ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
    return common.everytimeRefeshCount;
}

- (Class)cacheModelCalss {
    return [ZHNHomeTimelineLayoutCacheModel class];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [ZHNOrdinaryCacheManager zhn_cacheHometimeLineWatchedOffsety:scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [ZHNOrdinaryCacheManager zhn_cacheHometimeLineWatchedOffsety:scrollView.contentOffset.y];
}

@end
