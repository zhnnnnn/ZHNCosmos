//
//  ZHNFavoriteTimelineModel.h
//  ZHNCosmos
//
//  Created by 张辉男 on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineStatusForCacheRootModel.h"

@interface ZHNFavoriteTimelineModel : ZHNTimelineStatusForCacheRootModel
@property (nonatomic,strong) NSData *layoutData;
@property (nonatomic,assign) unsigned long long statusID;
@end
