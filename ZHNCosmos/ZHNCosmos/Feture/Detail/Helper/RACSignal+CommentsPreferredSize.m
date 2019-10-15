//
//  RACSignal+CommentsPreferredSize.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "RACSignal+CommentsPreferredSize.h"
#import "ZHNTimelineModel.h"
#import "NSAttributedString+ZHNStringPreferredSize.h"

@implementation RACSignal (CommentsPreferredSize)
- (RACSignal *)preferredSizeWithMaxWidth:(CGFloat)maxWidth {
    return [self flattenMap:^RACStream *(NSArray *statusArray) {
        for (ZHNTimelineStatus *status in statusArray) {
            NSAttributedString *richText = [NSAttributedString yy_unarchiveFromData:status.richTextData];
            status.richTextPreferredSize = [richText zhn_sizeForMaxWidth:maxWidth];
        }
        return [RACSignal return:statusArray];
    }];
}
@end
