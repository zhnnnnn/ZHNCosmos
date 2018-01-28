//
//  ZHNVideoFlowStore.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVideoFlowStore.h"

@implementation ZHNVideoFlowStore
- (instancetype)init {
    if (self = [super init]) {
        self.videoState = ZHNVideoStateNone;
        self.isFullScreen = NO;
        self.isNeedShowToolBar = YES;
        self.seekTime = 0;
        self.videoDuration = 0;
        self.currentTime = 0;
    }
    return self;
}

#pragma mark - actions
- (void)actionLoadVideo {
    self.videoState = ZHNVideoStateLoading;
}

- (void)actionPlayPauseVideo {
    switch (self.videoState) {
        case ZHNVideoStatePauseing:
        {
            self.videoState = ZHNVideoStatePlaying;
        }
            break;
        case ZHNVideoStatePlaying:
        {
            self.videoState = ZHNVideoStatePauseing;
        }
            break;
        default:
        {
            self.videoState = ZHNVideoStatePlaying;
        }
            break;
    }
}

- (void)actionFullScreenDEAL {
    self.isFullScreen = !self.isFullScreen;
}

- (void)actionToolViewDEAL {
    self.isNeedShowToolBar = !self.isNeedShowToolBar;
}

- (void)actionSeekToTime:(NSInteger)time {
    self.seekTime = time;
}

- (void)actionVideoLoadSuccessWithDuration:(NSInteger)duration {
    self.videoDuration = duration;
}

- (void)actionVideoPlayCurrentPlayTime:(NSInteger)currentTime {
    self.currentTime = currentTime;
}

- (void)actionVideoPlayComplete {
    self.videoState = ZHNVideoStateComplete;
}
@end
