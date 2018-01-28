//
//  ZHNHotTopicModel.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotTopicModel.h"

@implementation ZHNHotTopicModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cardType":@"card_type",
             @"titleSub":@"title_sub"};
}
@end
