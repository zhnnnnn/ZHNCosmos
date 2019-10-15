//
//  ZHNFavoriteTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNFavoriteTimelineViewController.h"
#import "ZHNFavoriteTimelineModel.h"

@interface ZHNFavoriteTimelineViewController ()

@end

@implementation ZHNFavoriteTimelineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    self.tableView.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, 0, 0);
    // Load cache data
    [[self loadDataWithType:ZHNfetchDataTypeLoadCache]
     subscribeNext:^(id x) {
    }];
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/favorites.json";
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (Class)cacheModelCalss {
    return [ZHNFavoriteTimelineModel class];
}

- (NSArray *)requestResultArrayMapKeyOrderArray {
    return @[@"favorites"];
}

- (NSArray *)requestStatuesMapkeyOrderArray {
    return @[@"status"];
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
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(pageID) forKey:@"page"];
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
@end
