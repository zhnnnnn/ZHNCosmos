//
//  ZHNTimelineStatusForCacheRootModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/22.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineLayoutModel.h"
//
// LKDBHelper don`t support inherit，So need to use KVC
// Every class corresponding a DB table
//
#define KLayoutDataName @"layoutData"
#define KLayoutIDName @"statusID"
@interface ZHNTimelineStatusForCacheRootModel : NSObject
/**
 Get layout model with `layoutData`

 @return layout model
 */
- (ZHNTimelineLayoutModel *)zhn_layoutModel;

/**
 Get max `statusID` layout model

 @return layout model
 */
+ (ZHNTimelineLayoutModel *)zhn_maxLayoutModel;

/**
 Get min `statusID` layout model

 @return layout model
 */
+ (ZHNTimelineLayoutModel *)zhn_minLayoutModel;

/**
 Save layouts

 @param timelineLayouts layout models
 */
+ (void)zhn_saveTimelineLayouts:(NSArray *)timelineLayouts;

/**
 Delete all statues
 */
+ (void)zhn_deleteAllLayots;

/**
 Update layouts

 @param timelineLayouts layout models
 */
+ (void)zhn_updateTimelineLayouts:(NSArray *)timelineLayouts;

/**
 Get all Cached layout models

 @return all cacheed layout models
 */
+ (NSArray <ZHNTimelineLayoutModel *> *)zhn_getAllCachedTimelineLayouts;
@end

/////////////////////////////////////////////////////
@interface ZHNCacheLockManager : NSObject
+ (instancetype)shareManager;
- (NSLock *)lockForClass:(Class)cacheClass;
@end


