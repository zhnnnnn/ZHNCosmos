//
//  ZHNHomePageAllTimelineCacheModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineStatusForCacheRootModel.h"

@interface ZHNHomePageAllTimelineCacheModel : ZHNTimelineStatusForCacheRootModel
@property (nonatomic,strong) NSData *layoutData;
@property (nonatomic,assign) unsigned long long statusID;
@end
