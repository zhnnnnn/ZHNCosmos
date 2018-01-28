//
//  ZHNTimelineStatusConfigReloadObserver.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineStatusConfigReloadObserver.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"
#import "ZHNNetworkManager+timeline.h"
#import "RACSignal+statusMapping.h"
#import "ZHNHomePageAllTimelineCacheModel.h"
#import "ZHNHomePageOriginalTimelineCacheModel.h"
#import "ZHNFavoriteTimelineModel.h"

@interface ZHNTimelineStatusConfigReloadObserver()
@property (nonatomic,strong) NSMutableDictionary *dataArrayKeyDict;
@property (nonatomic,strong) NSMutableDictionary *racSubjectDict;
@property (nonatomic,assign) NSInteger reloadCount;// ignore init
@property (nonatomic,strong) NSMapTable *weakControllerTable;
@end

@implementation ZHNTimelineStatusConfigReloadObserver
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static ZHNTimelineStatusConfigReloadObserver *observer;
    dispatch_once(&onceToken, ^{
        observer = [[ZHNTimelineStatusConfigReloadObserver alloc]init];
        [observer p_initRacSubjectDict];
        @weakify(observer);
        observer.extraThemeColorChangeHandle = ^{
            @strongify(observer);
            if (observer.reloadCount < 2) {
                observer.reloadCount++;
                return;
            }
            [observer p_reloadCachedTimelineStatusConfigNeedReloadLayout:NO];
        };
        observer.extraNightVersionChangeHandle = ^{
            @strongify(observer);
            if (observer.reloadCount < 2) {
                observer.reloadCount++;
                return;
            }
            [observer p_reloadCachedTimelineStatusConfigNeedReloadLayout:NO];
        };
        
        [ZHNThemeManager zhn_observeToReloadRichTextConfigWithObserver:observer handle:^{
            [observer p_reloadCachedTimelineStatusConfigNeedReloadLayout:YES];
        }];
    });
    return observer;
}

- (RACSubject *)zhn_observeReloadCachedTimelineLayoutsWithCacheModelClass:(Class)cacheModelClass controller:(NSObject *)controller dataArrayKey:(NSString *)dataArrayKey {
    NSArray *layoutArray = [controller valueForKey:dataArrayKey];
    if (layoutArray && cacheModelClass) {
        [self.weakControllerTable setObject:controller forKey:NSStringFromClass(cacheModelClass)];
        [self.dataArrayKeyDict setObject:dataArrayKey forKey:NSStringFromClass(cacheModelClass)];
    }
    return [self.racSubjectDict objectForKey:NSStringFromClass(cacheModelClass)];
}

- (void)p_reloadCachedTimelineStatusConfigNeedReloadLayout:(BOOL)needLayout {
    // Beigin reload single
    for (NSString *classKey in self.racSubjectDict.allKeys) {
        RACSubject *subject = [self.racSubjectDict objectForKey:classKey];
        [subject sendNext:classKey];
    }
    
    // Reload Cache Data
    for (NSString *classKey in self.racSubjectDict.allKeys) {
        RACSignal *startLayoutSingle;
        Class cacheModelClass = NSClassFromString(classKey);
        NSObject *controller = [self.weakControllerTable objectForKey:classKey];
        NSString *dataArrayKey = [self.dataArrayKeyDict objectForKey:classKey];
        NSArray *layoutArray = [controller valueForKey:dataArrayKey];
        
        if (layoutArray.count > 0) {
            startLayoutSingle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:layoutArray];
                return nil;
            }];
        }else {
            startLayoutSingle = [self p_getCacheTimelineLayoutsWithCacheModelClass:cacheModelClass];
        }
        
        // font padding need reload layout
        RACSignal *reloadSingle = [startLayoutSingle formatterRichTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]];
        if (YES) {
            reloadSingle = [reloadSingle layout];
        }
        
        // reload richText
        RACScheduler *richTextScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
        [[[[reloadSingle
        replayLazily]
        subscribeOn:richTextScheduler]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSArray *reloadedLayouts) {
             // Reload memory data
            [controller setValue:reloadedLayouts forKey:dataArrayKey];
            
             // Reload cached data
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [cacheModelClass performSelector:@selector(zhn_updateTimelineLayouts:) withObject:reloadedLayouts];
             });
         }];
    }
}

- (RACSignal *)p_getCacheTimelineLayoutsWithCacheModelClass:(Class)cacheModelClass {
    return [[ZHNNETWROK getTimelineStatusWithType:ZHNfetchDataTypeLoadCache cacheModelClass:cacheModelClass requestUrl:nil requestParams:nil requsetResponse:ZHNResponseTypeJSON resultArrayMapKeyArray:nil requestStatusMapKeyArray:nil]
           flattenMap:^RACStream *(ZHNFetchTimelineDataMetaData *metaData) {
               NSArray *layouts = metaData.layouts;
               return [RACSignal return:layouts];
           }];
}

- (void)p_initRacSubjectDict {
    // home
    RACSubject *homeSubject = [RACSubject subject];
    [self.racSubjectDict setObject:homeSubject forKey:NSStringFromClass([ZHNHomeTimelineLayoutCacheModel class])];
    // User all timeline
    RACSubject *userAllSubject = [RACSubject subject];
    [self.racSubjectDict setObject:userAllSubject forKey:NSStringFromClass([ZHNHomePageAllTimelineCacheModel class])];
    // User more timeline
    RACSubject *userMoreSubject = [RACSubject subject];
    [self.racSubjectDict setObject:userMoreSubject forKey:NSStringFromClass([ZHNHomePageOriginalTimelineCacheModel class])];
    // Favorite
    RACSubject *favoriteSubject = [RACSubject subject];
    [self.racSubjectDict setObject:favoriteSubject forKey:NSStringFromClass([ZHNFavoriteTimelineModel class])];
}

- (NSMutableDictionary *)dataArrayKeyDict {
    if (_dataArrayKeyDict == nil) {
        _dataArrayKeyDict = [NSMutableDictionary dictionary];
    }
    return _dataArrayKeyDict;
}

- (NSMutableDictionary *)racSubjectDict {
    if (_racSubjectDict == nil) {
        _racSubjectDict = [NSMutableDictionary dictionary];
    }
    return _racSubjectDict;
}

- (NSMapTable *)weakControllerTable {
    if (_weakControllerTable == nil) {
        _weakControllerTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _weakControllerTable;
}
@end
