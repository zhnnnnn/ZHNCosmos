//
//  ZHNVideoPlayer.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHNVideoFlowStore.h"
#import "ZHNVideoToolView.h"
#import "ZHNTimer.h"
#import "NSString+ZHNVideo.h"
#import "ZHNVideoLoading.h"
#import "ZHNDeviceManager.h"

@interface ZHNVideoPlayer()<ZHNVideoToolViewDelegate>
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,assign) ZHNVideoDirection videoDirection;
@property (nonatomic,strong) ZHNVideoFlowStore *store;
@property (nonatomic,strong) ZHNVideoToolView *toolView;
@property (nonatomic,strong) ZHNVideoLoading *loading;
@property (nonatomic,strong) ZHNTimer *dismissTimer;
@property (nonatomic,strong) ZHNTimer *currentTimeTimer;
@end

@implementation ZHNVideoPlayer
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = ZHNHexColor(@"c7c7c7");
        self.store = [[ZHNVideoFlowStore alloc]init];
        [self addSubview:self.toolView];
        [self addSubview:self.loading];
        [self p_addGestures];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.playerLayer.frame = self.bounds;
    self.loading.center = self.center;
    self.loading.bounds = CGRectMake(0, 0, 60, 30);
}

- (void)zhn_playeWithVideoURL:(NSURL *)videoURL {
    self.videoURL = videoURL;
    @weakify(self);
    [RACObserve(self, self.store.videoState) subscribeNext:^(id value) {
        @strongify(self);
        ZHNVideoState state = [value integerValue];
        switch (state) {
            case ZHNVideoStateLoading:
            {
                [self.loading zhn_loading];
                [self.toolView isLoading:YES];
                [self.player play];
            }
                break;
            case ZHNVideoStatePlaying:
            {
                [self p_reloadDismissTimer];
                [self.toolView isLoading:NO];
                [self.player play];
                [self.toolView play];
            }
                break;
            case ZHNVideoStatePauseing:
            {
                [self.player pause];
                [self.toolView pause];
            }
                break;
            case ZHNVideoStateComplete:
            {
            }
                break;
            default:
                break;
        }
    }];
    
    [[RACObserve(self, self.store.isFullScreen) skip:1] subscribeNext:^(id value) {
        @strongify(self);
        [self p_reloadDismissTimer];
        BOOL isFullScreen = [value boolValue];
        if (isFullScreen) {
            if (self.videoDirection == ZHNVideoDirectionHorizon) {
                [ZHNDeviceManager zhn_statusBarAnimateToLandscapeRight];
                [ZHNDeviceManager zhn_fadeAnimateStatusBarHidden:NO];
            }
            [self.delegate ZHNVideoPlayerClickToFullScreen:YES videoDirection:self.videoDirection];
        }else {
            [ZHNDeviceManager zhn_statusBarAnimateToPortrait];
            [self.delegate ZHNVideoPlayerClickToFullScreen:NO videoDirection:self.videoDirection];
        }
    }];
    
    [[RACObserve(self, self.store.isNeedShowToolBar) skip:1] subscribeNext:^(id value) {
        @strongify(self);
        [self p_reloadDismissTimer];
        BOOL isNeedShowToolBar = [value boolValue];
        if (isNeedShowToolBar) {
            if (self.store.isFullScreen) {
                [ZHNDeviceManager zhn_slideAnimateStatusBarHidden:NO];
            }
            [self.toolView showToolView];
            self.toolView.fullScreenPlayTimeProgress.hidden = YES;
        }else {
            if (self.store.isFullScreen) {
                [ZHNDeviceManager zhn_slideAnimateStatusBarHidden:YES];
            }
            self.toolView.fullScreenPlayTimeProgress.hidden = NO;
            [self.toolView hideToolView];
        }
    }];
    
    [RACObserve(self, self.store.seekTime) subscribeNext:^(id value) {
        @strongify(self);
        NSInteger seekTime = [value integerValue];
        [self.player seekToTime:CMTimeMake(seekTime, 1) completionHandler:^(BOOL finished) {
        }];
    }];
    
    [[RACObserve(self, self.store.videoDuration) skip:1] subscribeNext:^(id value) {
        @strongify(self);
        NSInteger videoDutation = [value integerValue];
        NSString *video = [NSString zhn_videoStrForDuration:videoDutation];
        self.toolView.remainTimeLabel.text = video;
    }];
    
    [[RACObserve(self, self.store.currentTime) skip:1] subscribeNext:^(id value) {
        @strongify(self);
        NSInteger playedTime = [value integerValue];
        NSInteger remindTime = self.store.videoDuration - playedTime;
        self.toolView.playedTimeLabel.text = [NSString zhn_videoStrForDuration:playedTime];
        self.toolView.remainTimeLabel.text = [NSString zhn_videoStrForDuration:remindTime];
        CGFloat percent = (CGFloat)playedTime/(CGFloat)self.store.videoDuration;
        self.toolView.currentTimeSlider.value = percent;
        self.toolView.fullScreenPlayTimeProgress.progress = percent;
    }];
    
    [self.store actionLoadVideo];
}

#pragma mark - delegates
- (void)ZHNToolViewSliderBeginDraging {
    [self.store actionPlayPauseVideo];
    [self p_deleteUpdateCurrentTimeTimer];
    [self p_deleteDismissTimer];
}

- (void)ZHNToolViewSliderEndDraging {
    [self.store actionPlayPauseVideo];
    [self p_addUpdateCurrentTimeTimer];
    [self p_addDimissTimer];
}

- (void)ZHNToolViewSliderSeekToPercent:(CGFloat)percent {
    [self.store actionSeekToTime:percent * self.store.videoDuration];
}

- (void)ZHNToolViewClickPlayPauseBtn {
    [self.store actionPlayPauseVideo];
}

- (void)ZHNToolViewClickON_OFFFullScreenBtn {
    [self.store actionFullScreenDEAL];
}

- (void)ZHNToolViewClickDownLoadBtn {
    [self.delegate ZHNVideoPlayerClickDownload];
}

- (void)ZHNToolViewClickDismissBtn {
    [ZHNDeviceManager zhn_statusBarAnimateToPortrait];
    [self.delegate ZHNVideoPlayerClickToDimiss];
}

#pragma mark - prative methods
- (void)p_addGestures {
    // Hide show tool bar
    @weakify(self);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [[tapGes rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.store.videoState == ZHNVideoStateLoading) {return;}
        [self.store actionToolViewDEAL];
    }];
    [self addGestureRecognizer:tapGes];
    
    // Double tap to play pause video
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]init];
    doubleTapGesture.numberOfTapsRequired = 2;
    [tapGes requireGestureRecognizerToFail:doubleTapGesture];
    [[doubleTapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.store.videoState == ZHNVideoStateLoading) {return;}
        [self.store actionPlayPauseVideo];
    }];
    [self addGestureRecognizer:doubleTapGesture];
}

- (void)p_addDimissTimer {
    @weakify(self);
    self.dismissTimer = [ZHNTimer zhn_timerWIthTimeInterval:7 repeats:NO handler:^{
        @strongify(self);
        [self.store actionToolViewDEAL];
    }];
    [self.dismissTimer fire];
}

- (void)p_deleteDismissTimer {
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
}

- (void)p_reloadDismissTimer {
    [self p_deleteDismissTimer];
    if (self.store.isNeedShowToolBar == YES) {
      [self p_addDimissTimer];
    }
}

- (void)p_addUpdateCurrentTimeTimer {
    @weakify(self);
    self.currentTimeTimer = [ZHNTimer zhn_timerWIthTimeInterval:1 repeats:YES handler:^{
        @strongify(self);
        NSInteger current = CMTimeGetSeconds(self.playerItem.currentTime);
        [self.store actionVideoPlayCurrentPlayTime:current];
    }];
    [self.currentTimeTimer fire];
}

- (void)p_deleteUpdateCurrentTimeTimer {
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
}

#pragma mark - getters
- (AVPlayer *)player {
    if (_player == nil) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
        self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
        playerLayer.frame = self.bounds;
        [self.layer addSublayer:playerLayer];
        self.playerLayer = playerLayer;
        [self bringSubviewToFront:self.toolView];
        [self bringSubviewToFront:self.loading];
        @weakify(self);
        [RACObserve(self, self.playerItem.status) subscribeNext:^(id status) {
            @strongify(self);
            AVPlayerItemStatus itemStatus = [status integerValue];
            if (itemStatus == AVPlayerItemStatusReadyToPlay) {
                [self.store actionPlayPauseVideo];
                CMTime duration = self.playerItem.duration;
                NSInteger seconds = CMTimeGetSeconds(duration) ;
                [self.store actionVideoLoadSuccessWithDuration:seconds];
                // End loading
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.loading zhn_endLoading];
                });
                // Update current play time
                [self p_addUpdateCurrentTimeTimer];
                // Get video layer size
                self.videoDirection = ZHNVideoDirectionHorizon;
                CGSize videoSize = self.playerItem.presentationSize;
                if (videoSize.height / videoSize.width > 1.4) {
                    self.videoDirection = ZHNVideoDirectionVertical;
                }
            }
            // Observe play end
            [[[[NSNotificationCenter defaultCenter]
               rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem]
              takeUntil:[self rac_willDeallocSignal]]
             subscribeNext:^(id x) {
                @strongify(self);
                [self ZHNToolViewClickDismissBtn];
            }];
        }];
    }
    return _player;
}

- (ZHNVideoToolView *)toolView {
    if (_toolView == nil) {
        _toolView = [[ZHNVideoToolView alloc]init];
        _toolView.backgroundColor = [UIColor clearColor];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (ZHNVideoLoading *)loading {
    if (_loading == nil) {
        _loading = [ZHNVideoLoading zhn_createLoadForColor:[ZHNThemeManager zhn_getThemeColor]];
    }
    return _loading;
}

@end
