//
//  WBEmojiContentModel.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 17/8/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "WBEmojiInfoModel.h"

@implementation WBEmojiInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"emoticons" : [WBEmojiItemModel class],
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id",
             };
}
@end

////////////////////////////////////////////////////////
@implementation WBEmojiItemModel

@end
