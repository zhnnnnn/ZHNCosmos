//
//  ZHNHotTopicViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotTopicViewController.h"
#import "ZHNHotTopicCellNode.h"
#import "ZHNHotTopicModel.h"

@interface ZHNHotTopicViewController ()

@end

@implementation ZHNHotTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayTableNode_loadDataType:ZHNfetchDataTypeLoadLatest];
    self.tableNode.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
}

- (void)reloadNavigationDalegate {
}

- (NSString *)requestURL {
    return @"https://api.weibo.cn/2/cardlist";
}

- (NSInteger)everyRequestMaxCount {
    return 20;
}

- (Class)displayTableNode_dataClass {
    return [ZHNHotTopicModel class];
}

- (NSArray *)displayTableNode_specialMapJsonArrayWithResult:(id)result {
    NSArray *array = [[[result zhn_SJMapKey:@"cards"][0] zhn_SJMapKey:@"card_group"] mutableCopy];
    NSMutableArray *fitArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"card_type"] integerValue] == 8) {
            [fitArray addObject:obj];
        }
    }];
    return [fitArray copy];
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    int pageID = 1;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            pageID = (int)(self.statusArray.count / [self everyRequestMaxCount]) + 1;
        }
            break;
        default:
            break;
    }
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:@(pageID) forKey:@"page"];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@"100803_-_page_hot_list" forKey:@"containerid"];
    [params zhn_safeSetObjetct:@([self everyRequestMaxCount]) forKey:@"count"];
    [params zhn_safeSetObjetct:@"1055095010" forKey:@"from"];
    [params zhn_safeSetObjetct:@(1) forKey:@"need_head_cards"];
    [params zhn_safeSetObjetct:@"211160679" forKey:@"source"];
    return params;
}

#pragma mark - datasource
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNHotTopicCellNode *cellNode = [[ZHNHotTopicCellNode alloc]init];
    cellNode.topicModel = self.statusArray[indexPath.row];
    cellNode.tagIndex = indexPath.row;
    return cellNode;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableNode:tableNode didSelectRowAtIndexPath:indexPath];
    ZHNHotTopicModel *topicModel = self.statusArray[indexPath.row];
    [self zhn_responderRouterWithName:KCellTapToSearchWordAction userInfo:@{KCellTapToSearchWordKey:topicModel.titleSub}];
}
@end
