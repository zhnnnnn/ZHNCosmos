//
//  ZHNVideoToolView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNVideoToolView.h"

@interface ZHNVideoToolView()
@property (nonatomic,strong) UIView *bottomControl;
@property (nonatomic,strong) UIButton *downLoadBtn;
@property (nonatomic,strong) UIButton *disMissBtn;
@end

@implementation ZHNVideoToolView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bottomControl];
        [self addSubview:self.downLoadBtn];
        [self addSubview:self.disMissBtn];
        [self addSubview:self.fullScreenPlayTimeProgress];
        [self.currentTimeSlider setThumbImage:[UIImage imageNamed:@"video_control_dot"] forState:UIControlStateNormal];
        [self.currentTimeSlider setThumbImage:[UIImage imageNamed:@"video_control_dot"] forState:UIControlStateHighlighted];
        @weakify(self);
        [[self.downLoadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate ZHNToolViewClickDownLoadBtn];
        }];
        [[self.disMissBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate ZHNToolViewClickDismissBtn];
        }];
        
        self.fullScreenBtn.zhn_expandTouchInset = UIEdgeInsetsMake(-5, -5, -5, -5);
        self.playBtn.zhn_expandTouchInset = UIEdgeInsetsMake(-5, -5, -5, -5);
        self.disMissBtn.zhn_expandTouchInset = UIEdgeInsetsMake(-5, -5, -5, -5);
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self p_toolsNormalPosition];
}

#pragma mark - public methods
- (void)isLoading:(BOOL)loading {
    if (loading) {
        self.downLoadBtn.enabled = NO;
        self.bottomControl.userInteractionEnabled = NO;
    }else {
        self.downLoadBtn.enabled = YES;
        self.bottomControl.userInteractionEnabled = YES;
    }
}

- (void)pause {
    [self.playBtn setImage:[UIImage imageNamed:@"video_control_play"] forState:UIControlStateNormal];
}

- (void)play {
    [self.playBtn setImage:[UIImage imageNamed:@"video_control_pause"] forState:UIControlStateNormal];
}

- (void)hideToolView {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self p_toolsHidePosition];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)showToolView {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        [self p_toolsNormalPosition];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - targate action
- (IBAction)playPauseAction:(id)sender {
    [self.delegate ZHNToolViewClickPlayPauseBtn];
}

- (IBAction)fullScreenON_OFFAction:(id)sender {
    [self.delegate ZHNToolViewClickON_OFFFullScreenBtn];
}

- (IBAction)seekTimeAction:(UISlider *)sender {
    [self.delegate ZHNToolViewSliderSeekToPercent:[sender value]];
}

- (IBAction)seekTimeSliderBeginDraging:(id)sender {
    [self.delegate ZHNToolViewSliderBeginDraging];
}

- (IBAction)seekTimeSliderEndDraging:(id)sender {
    [self.delegate ZHNToolViewSliderEndDraging];
}

#pragma mark - pravite methods
- (void)p_toolsNormalPosition {
    [self.disMissBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(5);
        } else {
            make.top.equalTo(self).offset(5);
        }
        make.size.mas_equalTo(CGSizeMake(30 , 30));
    }];
    [self.downLoadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.disMissBtn);
        make.size.equalTo(self.disMissBtn);
    }];
    [self.bottomControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-5);
        } else {
            make.bottom.equalTo(self).offset(-5);
        }
        make.left.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [self.fullScreenPlayTimeProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self);
        }
    }];
}

- (void)p_toolsHidePosition {
    [self.disMissBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(-40);
        make.size.mas_equalTo(CGSizeMake(20 , 20));
    }];
    [self.downLoadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.disMissBtn).offset(-40);
        make.size.equalTo(self.disMissBtn);
    }];
    [self.bottomControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getters
- (UIView *)bottomControl {
    if (_bottomControl == nil) {
        _bottomControl = [[[NSBundle mainBundle] loadNibNamed:@"ZHNVideoBottomControl" owner:self options:nil] lastObject];
        _bottomControl.backgroundColor = [UIColor clearColor];
        _bottomControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomControl;
}

- (UIButton *)downLoadBtn {
    if (_downLoadBtn == nil) {
        _downLoadBtn = [[UIButton alloc]init];
        [_downLoadBtn setImage:[UIImage imageNamed:@"video_control_download"] forState:UIControlStateNormal];
    }
    return _downLoadBtn;
}

- (UIButton *)disMissBtn {
    if (_disMissBtn == nil) {
        _disMissBtn = [[UIButton alloc]init];
        [_disMissBtn setImage:[UIImage imageNamed:@"video_control_close"] forState:UIControlStateNormal];
    }
    return _disMissBtn;
}

- (UIProgressView *)fullScreenPlayTimeProgress {
    if (_fullScreenPlayTimeProgress == nil) {
        _fullScreenPlayTimeProgress = [[UIProgressView alloc]init];
        _fullScreenPlayTimeProgress.progress = 0;
        _fullScreenPlayTimeProgress.hidden = YES;
        _fullScreenPlayTimeProgress.progressTintColor = [UIColor whiteColor];
        _fullScreenPlayTimeProgress.trackTintColor = [UIColor clearColor];
    }
    return _fullScreenPlayTimeProgress;
}
@end



