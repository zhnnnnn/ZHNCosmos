//
//  ZHNNetworkManager+timeline.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/3.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNNetworkManager+timeline.h"
#import "ZHNTimelineModel.h"
#import "ZHNLinkerTypeModel.h"
#import "LKDBHelper.h"
#import "ZHNUserMetaDataModel.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNTimelineLayoutModel.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"
#import "RACSignal+ZHNRichTextHelper.h"
#import "RACSignal+statusMapping.h"
#import "ZHNOrdinaryCacheManager.h"

@implementation ZHNNetworkManager (timeline)
- (RACSignal *)nativeTimelineStatus {
    return
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test1.json" ofType:@""];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        NSArray *statusArray = [NSArray yy_modelArrayWithClass:[ZHNTimelineStatus class] json:dict[@"statuses"]];
        [subscriber sendNext:statusArray];
        return nil;
    }]
     completeFormatter]
     flattenMap:^RACStream *(NSArray *statusArray) {
         ZHNFetchTimelineDataMetaData *fetchData = [ZHNFetchTimelineDataMetaData zhn_fetchMetaDataWithLayouts:statusArray dataType:ZHNTimelineDataTypeCache];
         return [RACSignal return:fetchData];
    }];
}

- (RACSignal *)getTimelineStatusWithType:(ZHNfetchDataType)dataType cacheModelClass:(Class)cacheModelClass requestUrl:(NSString *)requestUrl requestParams:(NSDictionary *)requestParams requsetResponse:(ZHNResponseType)responseType resultArrayMapKeyArray:(NSArray *)mapKeyArray requestStatusMapKeyArray:(NSArray *)statusMapKeyArray{
    if (dataType == ZHNfetchDataTypeLoadCache) {// Cache
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSArray *statusArray = [cacheModelClass performSelector:@selector(zhn_getAllCachedTimelineLayouts)];
            if (statusArray.count > 0) {// Have cache, use cache
                NSAssert(![cacheModelClass isKindOfClass:[ZHNTimelineStatusForCacheRootModel class]], @"cacheModelClass需要是ZHNTimelineStatusForCacheRootModel的子类");
                ZHNFetchTimelineDataMetaData *metaData = [ZHNFetchTimelineDataMetaData zhn_fetchMetaDataWithLayouts:statusArray dataType:ZHNTimelineDataTypeCache];
                [subscriber sendNext:metaData];
            }else {// No cache , Call API
                [[self getTimelineStatusWithType:ZHNfetchDataTypeLoadLatest cacheModelClass:cacheModelClass requestUrl:requestUrl requestParams:requestParams requsetResponse:responseType resultArrayMapKeyArray:mapKeyArray requestStatusMapKeyArray:statusMapKeyArray] subscribeNext:^(ZHNFetchTimelineDataMetaData *metaData) {
                    [subscriber sendNext:metaData];
                }];
            }
            return nil;
        }];
    }else {// Network
        return
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (requestUrl == nil) {
                [subscriber sendError:nil];
                return nil;
            }
            [ZHNNETWROK get:requestUrl params:requestParams responseType:responseType success:^(id result, NSURLSessionDataTask *task) {
                NSDictionary *resultDict;
                if ([result isKindOfClass:[NSDictionary class]]) {
                    resultDict = result;
                }
                if ([result isKindOfClass:[NSData class]]) {
                  resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                }
                
                id json = resultDict;
                if (mapKeyArray) {
                    for (NSString *key in mapKeyArray) {
                        json = json[key];
                    }
                }
                
                if (statusMapKeyArray) {
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSDictionary *dict in json) {
                        id newDict = dict;
                        for (NSString *key in statusMapKeyArray) {
                            newDict = newDict[key];
                        }
                        [array addObject:newDict];
                    }
                    json = array;
                }
                
                NSArray *statusArray = [NSArray yy_modelArrayWithClass:[ZHNTimelineStatus class] json:json];
                if ([result zhn_isDictionary]) {
                    if (cacheModelClass) {
                        if (result[@"max_id"]) {
                            [ZHNOrdinaryCacheManager zhn_cacheMaxID:[result[@"max_id"] longLongValue] ForCachedClass:cacheModelClass];
                        }else {
                            if (dataType == ZHNfetchDataTypeLoadMore) {
                                if (statusArray.count > 0) {
                                    NSMutableArray *muStatusArray = [statusArray mutableCopy];
                                    [muStatusArray removeObjectAtIndex:0];
                                    statusArray = [muStatusArray copy];
                                }
                            }
                            ZHNTimelineStatus *lastStatus = [statusArray lastObject];
                            [ZHNOrdinaryCacheManager zhn_cacheMaxID:lastStatus.statusID ForCachedClass:cacheModelClass];
                        }
                    }
                }
                
                [subscriber sendNext:statusArray];
            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return nil;
        }]
         completeFormatter]
         flattenMap:^RACStream *(NSArray *layouts) {
             // Cache status array if need
             if (cacheModelClass) {
                 [cacheModelClass performSelector:@selector(zhn_saveTimelineLayouts:) withObject:layouts];
             }
             // Create metaData
             ZHNFetchTimelineDataMetaData *metaData = [ZHNFetchTimelineDataMetaData zhn_fetchMetaDataWithLayouts:layouts dataType:ZHNTimelineDataTypeNet];
             return [RACSignal return:metaData];
         }];
    }
}
@end

////////////////////////////////////////////////////////
@implementation ZHNFetchTimelineDataMetaData
+ (instancetype)zhn_fetchMetaDataWithLayouts:(NSArray *)layouts dataType:(ZHNTimelineDataType)dataType {
    ZHNFetchTimelineDataMetaData *metaData = [[ZHNFetchTimelineDataMetaData alloc]init];
    metaData.layouts = layouts;
    metaData.dataType = dataType;
    return metaData;
}
@end


