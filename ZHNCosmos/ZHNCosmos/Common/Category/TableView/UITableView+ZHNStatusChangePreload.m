//
//  UITableView+ZHNStatusChangePreload.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/17.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UITableView+ZHNStatusChangePreload.h"
#import "ZHNTimelineModel.h"
#import "ZHNTimelineLayoutModel.h"
#import "RACSignal+statusMapping.h"
#import "RACSignal+ZHNRichTextHelper.h"

@implementation UITableView (ZHNStatusChangePreload)
- (void)zhn_preloadWithLoadPreferenceCount:(NSInteger)count controller:(NSObject *)controller dataArrayKey:(NSString *)dataArrayKey{
    __block NSArray *dataArray;
    NSMutableArray *needReloadIndexPathArray = [NSMutableArray array];
    NSIndexPath *firstIndexPath = [[self indexPathsForVisibleRows] firstObject];
    [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dataArray = [controller valueForKey:dataArrayKey];
        if (dataArray.count == 0) {
            [subscriber sendNext:nil];
            return nil;
        }
        
        // Need reload index array
        NSInteger centerIndex = firstIndexPath.row;
        NSIndexPath *centerIndexPath = [NSIndexPath indexPathForRow:centerIndex inSection:0];
        [needReloadIndexPathArray addObject:centerIndexPath];
        
        for (int index = 1; index < count; index++) {
            NSInteger left = centerIndex - index;
            NSInteger right = centerIndex + index;
            if (left >= 0) {
                NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:left inSection:0];
                [needReloadIndexPathArray addObject:leftIndexPath];
            }
            if (right < dataArray.count) {
                NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:right inSection:0];
                [needReloadIndexPathArray addObject:rightIndexPath];
            }
        }
        
        NSMutableArray *statusArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in needReloadIndexPathArray) {
            NSObject *data = dataArray[indexPath.row];
            ZHNTimelineStatus *status;
            if ([data isKindOfClass:[ZHNTimelineStatus class]]) {
                status = (ZHNTimelineStatus *)data;
            }
            if ([data isKindOfClass:[ZHNTimelineLayoutModel class]]) {
                status = [(ZHNTimelineLayoutModel *)data status];
            }
            [statusArray addObject:status];
        }
        [subscriber sendNext:statusArray];
        return nil;
    }]
    formatterRichTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]]
    layout]
    subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]]
    deliverOnMainThread]
    subscribeNext:^(NSArray *layouts) {
        NSMutableArray *tempDataArray = [dataArray mutableCopy];
        [needReloadIndexPathArray enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            tempDataArray[indexPath.row] = layouts[idx];
        }];
        [controller setValue:[tempDataArray copy] forKey:dataArrayKey];
        
        [self reloadRowsAtIndexPaths:needReloadIndexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)p_reloadDataForStatues:(ZHNTimelineStatus *)status {
    [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSAttributedString *attribuString = [[NSAttributedString alloc] initWithString:status.text];
        [subscriber sendNext:attribuString];
        return nil;
    }]
    atFormatter]
    topicFormatter]
    emojiFormatter]
    urlFormatter:status richTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]]
    subscribeNext:^(NSMutableAttributedString *richText) {
        status.richTextData = [richText yy_archiveToData];
    }];
}
@end
