//
//  ZHNVideoPlayerManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVideoPlayerManager.h"
#import "ZHNVideoPlayer.h"
#import "UIImageView+ZHNWebimage.h"

@interface ZHNVideoPlayerManager()<ZHNVideoPlayerDelegate>
@property (nonatomic,assign) CGPoint startCenter;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,assign) CGRect smallScreenFrame;
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,copy) ZHNVideoHideAnimateEndHandle hideHandle;
@property (nonatomic,strong) ZHNVideoPlayer *videoPlayer;
@end

@implementation ZHNVideoPlayerManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNVideoPlayerManager *manger;
    dispatch_once(&onceToken, ^{
        manger = [[ZHNVideoPlayerManager alloc]init];
    });
    return manger;
}

- (BOOL)isPlayerShowing {
    return self.containerView ? YES : NO;
}

- (void)zhn_playerForURLMetaData:(ZHNTimelineURL *)URLMetaData fromView:(UIView *)fromView showAnimateStart:(ZHNVideoShowAnimateStartHandle)showHandle hideAnimateEnd:(ZHNVideoHideAnimateEndHandle)hideHandle {
    
    if (self.isPlayerShowing) {// Player playing
        [self.videoPlayer removeFromSuperview];
        self.videoPlayer = nil;
        ZHNVideoPlayer *player = [[ZHNVideoPlayer alloc]init];
        self.videoPlayer = player;
        player.delegate = self;
        [self.containerView addSubview:player];
        [player mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        // Load Video
        [self p_playerLoadVideoWithURLMetaData:URLMetaData];
    }else {// No player playing
        // Destory playing player
        [self p_destroyPlayingPlayer];
        
        UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        UIView *containerView = [[UIView alloc]init];
        containerView.layer.cornerRadius = 5;
        containerView.layer.masksToBounds = YES;
        [superView addSubview:containerView];
        ZHNVideoPlayer *player = [[ZHNVideoPlayer alloc]init];
        self.videoPlayer = player;
        player.delegate = self;
        [containerView addSubview:player];
        UIView *shotView = [fromView snapshotViewAfterScreenUpdates:YES];
        [containerView addSubview:shotView];
        UIView *maskView = [[UIView alloc]init];
        maskView.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
        maskView.alpha = 0.3;
        maskView.hidden = YES;
        [containerView addSubview:maskView];
        self.containerView = containerView;
        
        // from
        CGRect fromFrame = [fromView.superview convertRect:fromView.frame toView:superView];
        CGRect frameStart = CGRectMake(fromFrame.origin.x - 10, fromFrame.origin.y - 10, fromFrame.size.width + 20, fromFrame.size.height + 20);
        containerView.frame = frameStart;
        [player mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [shotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        // to
        CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat x = 10;
        CGFloat height = 200;
        CGRect frameEnd = CGRectMake(x, y, K_SCREEN_WIDTH - 20, height);
        
        // Pan view
        @weakify(self);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
        [[panGesture rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *pan) {
            @strongify(self);
            if (self.isFullScreen) {return;}
            switch (pan.state) {
                case UIGestureRecognizerStateBegan:
                {
                    self.startCenter = self.containerView.center;
                }
                    break;
                case UIGestureRecognizerStateChanged:
                {
                    CGPoint translate = [pan translationInView:self.containerView];
                    self.containerView.center = CGPointMake(self.startCenter.x + translate.x, self.startCenter.y + translate.y);
                    if (self.containerView.center.x < 0 ||
                        self.containerView.center.x > K_SCREEN_WIDTH ||
                        self.containerView.center.y < 0 ||
                        self.containerView.center.y > K_SCREEN_HEIGHT) {
                        maskView.hidden = NO;
                    }else {
                        maskView.hidden = YES;
                    }
                }
                    break;
                case UIGestureRecognizerStateEnded:
                case UIGestureRecognizerStateFailed:
                case UIGestureRecognizerStateCancelled:
                {
                    if (maskView.hidden == NO) {
                        [self ZHNVideoPlayerClickToDimiss];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
        [containerView addGestureRecognizer:panGesture];
        
        // Animate
        if (showHandle) {
            showHandle();
        }
        self.hideHandle = hideHandle;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            containerView.frame = frameEnd;
            shotView.alpha = 0;
        } completion:^(BOOL finished) {
            [shotView removeFromSuperview];
            // Load Video
            [self p_playerLoadVideoWithURLMetaData:URLMetaData];
        }];
    }
}

- (void)p_playerLoadVideoWithURLMetaData:(ZHNTimelineURL *)URLMetaData {
    ZHNVideoMeteData *videoMetaData = [URLMetaData zhn_searchVideoMetaData];
    if (videoMetaData) {
        [self.videoPlayer zhn_playeWithVideoURL:[NSURL URLWithString:videoMetaData.videoUrl]];
    }else {
        UIImageView *temp = [[UIImageView alloc]init];
        [self.containerView addSubview:temp];
        [temp zhn_setImageWithVideoShortUrl:URLMetaData.urlShort placeholder:nil complete:^(long long videoSize, int videoDuration) {
            [temp removeFromSuperview];
            ZHNVideoMeteData *videoMetaData = [ZHNTimelineURL zhn_searchVideoMetaDataForShortURLStr:URLMetaData.urlShort]
            ;
            [self.videoPlayer zhn_playeWithVideoURL:[NSURL URLWithString:videoMetaData.videoUrl]];
        }];
    }
}

- (void)p_destroyPlayingPlayer {
    if (self.containerView) {
        self.containerView.hidden = YES;
        [self ZHNVideoPlayerClickToDimiss];
    }
}

#pragma mark - delegate
- (void)ZHNVideoPlayerClickToFullScreen:(BOOL)isFullScreen videoDirection:(ZHNVideoDirection)direction{
    self.isFullScreen = isFullScreen;
    if (isFullScreen) {
        self.smallScreenFrame = self.containerView.frame;
        switch (direction) {
            case ZHNVideoDirectionHorizon:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.containerView.center = CGPointMake(K_SCREEN_HEIGHT/2, K_SCREEN_WIDTH/2);
                    self.containerView.bounds = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
                    self.containerView.transform = CGAffineTransformMakeRotation(M_PI_2);
                    [self.containerView layoutIfNeeded];
                } completion:^(BOOL finished) {
                }];
            }
                break;
            case ZHNVideoDirectionVertical:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.containerView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
                    [self.containerView layoutIfNeeded];
                } completion:^(BOOL finished) {
                }];
            }
                break;
        }
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.transform = CGAffineTransformIdentity;
            self.containerView.frame = self.smallScreenFrame;
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)ZHNVideoPlayerClickToDimiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.center = CGPointMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y);
        self.containerView.bounds = CGRectMake(0, 0, 0, 0);
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.hideHandle) {
            self.hideHandle();
        }
        [self.containerView removeFromSuperview];
        self.containerView = nil;
        self.videoPlayer = nil;
    }];
}

- (void)ZHNVideoPlayerClickDownload {
    
}

@end



