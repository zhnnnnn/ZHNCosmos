//
//  ZHNVideoToolView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNVideoFlowStore.h"

@protocol ZHNVideoToolViewDelegate <NSObject>
- (void)ZHNToolViewClickPlayPauseBtn;
- (void)ZHNToolViewClickON_OFFFullScreenBtn;
- (void)ZHNToolViewClickDismissBtn;
- (void)ZHNToolViewClickDownLoadBtn;

- (void)ZHNToolViewSliderSeekToPercent:(CGFloat)percent;
- (void)ZHNToolViewSliderBeginDraging;
- (void)ZHNToolViewSliderEndDraging;
@end

@interface ZHNVideoToolView : UIView
- (void)isLoading:(BOOL)loading;
- (void)pause;
- (void)play;

- (void)hideToolView;
- (void)showToolView;

@property (nonatomic,weak) id <ZHNVideoToolViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet UILabel *playedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (strong, nonatomic) UIProgressView *fullScreenPlayTimeProgress;
@end
