//
//  ZHNTimelineStatusConfigReloadObserver.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ZHNTimelineStatusType) {
    ZHNTimelineStatusTypeHome,
    ZHNTimelineStatusTypeMine,
    ZHNTimelineStatusCollect
};

typedef void(^ZHNTimelineReloadCacheSuccess)(NSArray *layouts);
@interface ZHNTimelineStatusConfigReloadObserver : NSObject
/**
 Observer , that observe `theme change` `night version change` etc. To reload cache and memory data.

 @return Observer
 */
+ (instancetype)shareInstance;


/**
 Observe cached data reload, and update

 @param cacheModelClass cache model class `must `ZHNTimelineStatusForCacheRootModel` sub class`
 @param layoutArray memory layout array if have.
 @return RACSubject, before update cached status will call `sendNext` method.
 */
- (RACSubject *)zhn_observeReloadCachedTimelineLayoutsWithCacheModelClass:(Class)cacheModelClass
                                                               controller:(NSObject *)controller
                                                             dataArrayKey:(NSString *)dataArrayKey;

@end
