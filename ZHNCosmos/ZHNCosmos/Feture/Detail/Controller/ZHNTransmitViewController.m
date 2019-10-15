//
//  ZHNTransmitViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTransmitViewController.h"
#import "ZHNTimelineModel.h"
#import "ZHNTimelineTransmitCellNode.h"
#import "RACSignal+statusMapping.h"
#import "RACSignal+CommentsPreferredSize.h"

@implementation ZHNTransmitViewController
- (NSArray<NSString *> *)gooeyMenuTitles {
    return @[@"转发",@"评论",@"查看微博",@"分享",@"取消"];
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/statuses/repost_timeline.json";
}

- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray {
    return @[@"reposts"];
}

- (NSInteger)everyRequestMaxCount {
    return 30;
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    ZHNUserMetaDataModel *user = [ZHNUserMetaDataModel displayUserMetaData];
    unsigned long long sinceID = 0;
    unsigned long long maxID = 0;
    ZHNTimelineStatus *maxStatus = [self.statusArray lastObject];
    if (maxStatus) {
        maxID = maxStatus.statusID;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:user.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@([self everyRequestMaxCount]) forKey:@"count"];
    [params zhn_safeSetObjetct:@(0) forKey:@"filter_by_author"];
    [params zhn_safeSetObjetct:@(self.statuID) forKey:@"id"];
    [params zhn_safeSetObjetct:@(sinceID) forKey:@"since_id"];
    [params zhn_safeSetObjetct:@(maxID) forKey:@"max_id"];
    return params;
}

#pragma mark - delegate
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNTimelineTransmitCellNode *node = [[ZHNTimelineTransmitCellNode alloc]init];
    node.status = self.statusArray[indexPath.row];
    [self tableNodeDisplayCell:node indexpath:indexPath];
    return node;
}
@end
