//
//  ZHNDirectMessageModel.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/21.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNDirectMessageModel.h"

@implementation ZHNDirectMessageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"directMessage":@"direct_message",
             @"unreadCount":@"unread_count"};
}
@end

////////////////////////////////////////////////////////
@implementation ZHNDirectMessageDetailModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"createdAt":@"created_at"};
}
@end
