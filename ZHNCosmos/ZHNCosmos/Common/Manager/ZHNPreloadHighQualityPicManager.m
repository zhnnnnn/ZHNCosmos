//
//  ZHNPreloadHighQualityPicManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPreloadHighQualityPicManager.h"
#import "UIImage+YYWebimageCache.h"
#import "ZHNCosmosConfigManager.h"

static NSMutableArray *preloadImageQueueArray;

static void ZHNRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    [[ZHNPreloadHighQualityPicManager manager].preloadQueue addOperationWithBlock:^{
        if (preloadImageQueueArray.count == 0) return;
        NSMutableArray *currentQueueArray = preloadImageQueueArray;
        preloadImageQueueArray = [NSMutableArray array];
        for (int index = 0; index < currentQueueArray.count; index++) {
            NSOperation *operation = currentQueueArray[currentQueueArray.count - 1 - index];
            [[ZHNPreloadHighQualityPicManager manager].preloadQueue addOperation:operation];
        }
    }];
}

@implementation ZHNPreloadHighQualityPicManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static ZHNPreloadHighQualityPicManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNPreloadHighQualityPicManager alloc]init];
        manager.preloadQueue = [[NSOperationQueue alloc]init];
        manager.preloadQueue.maxConcurrentOperationCount = 5;
        preloadImageQueueArray = [NSMutableArray array];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                           kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                           true,      // repeat
                                           0xFFFFFF,  // after CATransaction(2000000)
                                           ZHNRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
    return manager;
}

- (void)preloadHighQualityPicForImageURLStr:(NSString *)imageURLStr {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
        NSString *bigPicUrlString = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:imageURLStr];
        switch (common.bigpicPreload) {
            case bigpicPreloadOn:
            {
                [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:bigPicUrlString] options:YYWebImageOptionIgnoreImageDecoding progress:nil transform:nil completion:nil];
            }
                break;
            case bigpicPreloadSmart:
            {
                if ([[ZHNNetworkManager shareInstance] isWIFI]) {
                    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:bigPicUrlString] options:YYWebImageOptionIgnoreImageDecoding progress:nil transform:nil completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }];
    [preloadImageQueueArray addObject:operation];
}
@end
