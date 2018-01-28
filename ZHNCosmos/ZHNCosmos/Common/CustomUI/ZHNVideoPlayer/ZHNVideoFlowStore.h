//
//  ZHNVideoFlowStore.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZHNVideoState) {
    ZHNVideoStateNone,
    ZHNVideoStateLoading,
    ZHNVideoStatePlaying,
    ZHNVideoStatePauseing,
    ZHNVideoStateComplete
};

@interface ZHNVideoFlowStore : NSObject
// Data
@property (nonatomic,assign) ZHNVideoState videoState;
@property (nonatomic,assign) BOOL isNeedShowToolBar;
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,assign) NSInteger seekTime;
@property (nonatomic,assign) NSInteger videoDuration;
@property (nonatomic,assign) NSInteger currentTime;

// Action
- (void)actionLoadVideo;
- (void)actionPlayPauseVideo;
- (void)actionVideoPlayComplete;
- (void)actionFullScreenDEAL;
- (void)actionToolViewDEAL;
- (void)actionSeekToTime:(NSInteger)time;
- (void)actionVideoLoadSuccessWithDuration:(NSInteger)duration;
- (void)actionVideoPlayCurrentPlayTime:(NSInteger)currentTime;
@end
