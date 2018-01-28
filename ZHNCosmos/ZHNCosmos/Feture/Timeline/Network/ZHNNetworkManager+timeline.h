//
//  ZHNNetworkManager+timeline.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/3.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNNetworkManager.h"
#import "ZHNTimelineStatusForCacheRootModel.h"

typedef NS_ENUM(NSInteger,ZHNfetchDataType) {
    ZHNfetchDataTypeLoadMore,
    ZHNfetchDataTypeLoadLatest,
    ZHNfetchDataTypeLoadCache // If no cache will use ZHNfetchDataTypeLoadLatest
};

typedef NS_ENUM(NSInteger,ZHNTimelineDataType) {
    ZHNTimelineDataTypeNet,
    ZHNTimelineDataTypeCache
};

@interface ZHNNetworkManager (timeline)
/**
 Get local Status

 @return status single
 */
- (RACSignal *)nativeTimelineStatus;

/**
 Get status use fetchDataType

 @param dataType fetchDataType
 @param cacheModelClass cache model class (a cache model class map a db table)
 @param requestUrl request url
 @param requestParams request params
 @param responseType request response type
 @return status single
 */
- (RACSignal *)getTimelineStatusWithType:(ZHNfetchDataType)dataType
                         cacheModelClass:(Class)cacheModelClass
                              requestUrl:(NSString *)requestUrl
                           requestParams:(NSDictionary *)requestParams
                         requsetResponse:(ZHNResponseType)responseType
                  resultArrayMapKeyArray:(NSArray *)mapKeyArray
                requestStatusMapKeyArray:(NSArray *)statusMapKeyArray;
@end

////////////////////////////////////////////////////////
@interface ZHNFetchTimelineDataMetaData : NSObject
@property (nonatomic,strong) NSArray *layouts;
@property (nonatomic,assign) ZHNTimelineDataType dataType;
+ (instancetype)zhn_fetchMetaDataWithLayouts:(NSArray *)layouts
                                    dataType:(ZHNTimelineDataType)dataType;
@end
