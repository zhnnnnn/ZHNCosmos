//
//  ZHNTimelineComment.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/18.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineComment.h"
#import "NSObject+YYModel.h"

@implementation ZHNTimelineComment
+ (NSDictionary *)modelCustomPropertyMapper {
    NSMutableDictionary *dict = [[super modelCustomPropertyMapper] mutableCopy];
    [dict addEntriesFromDictionary:@{@"ID":@"id",
                                     @"likeCounts":@"like_counts",
                                     @"moreInfo":@"more_info",
                                     @"replyComment":@"reply_comment"}];
    return [dict copy];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"comments" : [ZHNTimelineComment class],};
}
@end

////////////////////////////////////////////////////////
@implementation ZHNTimelineCommentMoreInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"highlightText":@"highlight_text",};
}
@end
