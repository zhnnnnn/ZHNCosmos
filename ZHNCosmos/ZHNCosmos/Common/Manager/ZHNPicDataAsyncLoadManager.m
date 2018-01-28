//
//  ZHNPicDataLoadManager.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/15.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNPicDataAsyncLoadManager.h"

@implementation ZHNPicDataAsyncLoadManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNPicDataAsyncLoadManager *loadManager;
    dispatch_once(&onceToken, ^{
        loadManager = [[ZHNPicDataAsyncLoadManager alloc]init];
        loadManager.picloadQueue = [[NSOperationQueue alloc]init];
        loadManager.picloadQueue.name = @"zhn.pic.load";
        loadManager.picloadQueue.maxConcurrentOperationCount = 5;
    });
    return loadManager;
}
@end
