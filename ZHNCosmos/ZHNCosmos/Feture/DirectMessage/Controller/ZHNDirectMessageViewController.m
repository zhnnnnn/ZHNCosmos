//
//  ZHNDirectMessageViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/21.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDirectMessageViewController.h"
#import "ZHNDirectMessageModel.h"
#import "ZHNDirectMessageCellNode.h"

@interface ZHNDirectMessageViewController ()

@end

@implementation ZHNDirectMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私信";
    self.tableNode.contentInset = UIEdgeInsetsMake(0, 0, K_tabbar_height, 0);
    [self displayTableNode_loadDataType:ZHNfetchDataTypeLoadCache];
    
    // Add user success. Reload data
    @weakify(self);
    [ZHNCosmosUserManager zhn_userAddSuccessWithResponseObject:self action:^{
        @strongify(self);
        [self displayTableNode_loadDataType:ZHNfetchDataTypeLoadCache];
    }];
}

- (NSString *)requestURL {
    return @"https://api.weibo.cn/2/direct_messages/user_list";
}

- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray {
    return @[@"user_list"];
}

- (Class)displayTableNode_dataClass {
    return [ZHNDirectMessageModel class];
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (BOOL)displayTableNode_needCache {
    return YES;
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    int cursor = 0;
    switch (type) {
        case ZHNfetchDataTypeLoadMore:
        {
            cursor = (int)(self.layoutArray.count / 25) + 1;
        }
            break;
        default:
            break;
    }
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:displayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(cursor) forKey:@"cursor"];
    [params zhn_safeSetObjetct:@"1055095010" forKey:@"from"];
    [params zhn_safeSetObjetct:@"211160679" forKey:@"source"];
    [params zhn_safeSetObjetct:@"25" forKey:@"count"];
    return params;
}

#pragma mark - detasource
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNDirectMessageCellNode *cell = [[ZHNDirectMessageCellNode alloc]init];
    cell.messageModel = self.statusArray[indexPath.row];
    return cell;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableNode:tableNode didSelectRowAtIndexPath:indexPath];
    [ZHNHudManager showWarning:@"TODO~"];
}
@end
