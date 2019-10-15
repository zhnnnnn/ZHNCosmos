//
//  ZHNTimelineForCacheModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineStatusForCacheRootModel.h"

@interface ZHNHomeTimelineLayoutCacheModel : ZHNTimelineStatusForCacheRootModel
@property (nonatomic,strong) NSData *layoutData;
@property (nonatomic,assign) unsigned long long statusID;
@end
