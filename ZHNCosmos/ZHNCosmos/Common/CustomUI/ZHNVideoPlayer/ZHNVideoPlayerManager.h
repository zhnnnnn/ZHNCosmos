//
//  ZHNVideoPlayerManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineModel.h"
typedef void(^ZHNVideoShowAnimateStartHandle)();
typedef void(^ZHNVideoHideAnimateEndHandle)();
@interface ZHNVideoPlayerManager : NSObject
/**
 Create singleton Object

 @return singleton
 */
+ (instancetype)shareManager;

/**
 Judge if player is playing

 @return playing
 */
- (BOOL)isPlayerShowing;

/**
 Show player

 @param URLMetaData url metaData
 @param fromView show from view
 @param showHandle show animate start 
 @param hideHandle hide animate end
 */
- (void)zhn_playerForURLMetaData:(ZHNTimelineURL *)URLMetaData
                        fromView:(UIView *)fromView
                showAnimateStart:(ZHNVideoShowAnimateStartHandle)showHandle
                  hideAnimateEnd:(ZHNVideoHideAnimateEndHandle)hideHandle;
@end

