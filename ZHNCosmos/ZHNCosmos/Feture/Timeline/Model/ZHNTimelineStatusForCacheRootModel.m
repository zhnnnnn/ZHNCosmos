//
//  ZHNTimelineStatusForCacheRootModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineStatusForCacheRootModel.h"
#import "ZHNTimelineModel.h"
#define ZHNLOCK [[[ZHNCacheLockManager shareManager] lockForClass:[self class]] lock];
#define ZHNUNLOCK [[[ZHNCacheLockManager shareManager] lockForClass:[self class]] unlock];
@implementation ZHNTimelineStatusForCacheRootModel
+ (NSString *)getTableName {
    return @"ZHNCosmosTimelineStatus";
}

+ (NSString *)getPrimaryKey {
    return KLayoutIDName;
}

+ (void)zhn_saveTimelineLayouts:(NSArray *)timelineLayouts {
    ZHNLOCK
    for (ZHNTimelineLayoutModel *layout in timelineLayouts) {
        ZHNTimelineStatusForCacheRootModel *cache = [[self alloc]init];
        [cache setValue:@(layout.statusID) forKey:KLayoutIDName];
        [cache setValue:[NSKeyedArchiver archivedDataWithRootObject:layout] forKey: KLayoutDataName];
        [cache saveToDB];
    }
    NSLog(@"%@ save cache complete",NSStringFromClass([self class]));
    ZHNUNLOCK
}

+ (void)zhn_deleteAllLayots {
    ZHNLOCK
    [self deleteWithWhere:nil];
    ZHNUNLOCK
}

+ (void)zhn_updateTimelineLayouts:(NSArray *)timelineLayouts {
    ZHNLOCK
    for (ZHNTimelineLayoutModel *layout in timelineLayouts) {
        ZHNTimelineStatusForCacheRootModel *cache = [[self alloc]init];
        [cache setValue:@(layout.statusID) forKey:KLayoutIDName];
        [cache setValue:[NSKeyedArchiver archivedDataWithRootObject:layout] forKey: KLayoutDataName];
        [cache updateToDB];
    }
    NSLog(@"%@ update cache complete",NSStringFromClass([self class]));
    ZHNUNLOCK
}

+ (NSArray<ZHNTimelineLayoutModel *> *)zhn_getAllCachedTimelineLayouts {
    ZHNLOCK
    NSString *order = [NSString stringWithFormat:@"%@ desc",KLayoutIDName];
    NSArray *caches = [self searchWithWhere:nil orderBy:order offset:0 count:0];
    NSMutableArray *layoutArray = [NSMutableArray array];
    for (id cache in caches) {
        ZHNTimelineLayoutModel *layout = [NSKeyedUnarchiver unarchiveObjectWithData:[cache valueForKey:KLayoutDataName]];
        [layoutArray addObject:layout];
    }
    ZHNUNLOCK
    return [layoutArray copy];
}

+ (ZHNTimelineLayoutModel *)zhn_minLayoutModel {
    ZHNLOCK
    NSString *order = [NSString stringWithFormat:@"%@ asc",KLayoutIDName];
    ZHNTimelineLayoutModel *min = [[self searchWithWhere:nil orderBy:order offset:0 count:1] firstObject];
    ZHNUNLOCK
    return min;
}

+ (ZHNTimelineLayoutModel *)zhn_maxLayoutModel {
    ZHNLOCK
    NSString *order = [NSString stringWithFormat:@"%@ desc",KLayoutIDName];
    ZHNTimelineLayoutModel *max = [[self searchWithWhere:nil orderBy:order offset:0 count:1] firstObject];
    ZHNUNLOCK
    return max;
}

- (ZHNTimelineLayoutModel *)zhn_layoutModel {
  return [NSKeyedUnarchiver unarchiveObjectWithData:[self valueForKey:KLayoutDataName]];
}
@end

/////////////////////////////////////////////////////
@interface ZHNCacheLockManager()
@property (nonatomic,strong) NSMutableDictionary *lockDict;
@end

@implementation ZHNCacheLockManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNCacheLockManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNCacheLockManager alloc]init];
    });
    return manager;
}

- (NSLock *)lockForClass:(Class)cacheClass {
    NSLock *lock = [self.lockDict objectForKey:NSStringFromClass(cacheClass)];
    if (!lock) {
        lock = [[NSLock alloc]init];
        [self.lockDict setObject:lock forKey:NSStringFromClass(cacheClass)];
        return lock;
    }else {
        return lock;
    }
}

- (NSMutableDictionary *)lockDict {
    if (_lockDict == nil) {
        _lockDict = [NSMutableDictionary dictionary];
    }
    return _lockDict;
}
@end



