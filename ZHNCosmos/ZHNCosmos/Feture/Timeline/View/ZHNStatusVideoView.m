//
//  ZHNStatusVideoView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStatusVideoView.h"
#import "ZHNTimelineLayoutModel.h"
#import "ZHNNetworkManager+timeline.h"
#import "UIImageView+ZHNWebimage.h"
#import "ZHNRibbonLabel.h"

typedef NS_ENUM(NSInteger,ZHNStatusVideoViewType) {
    ZHNStatusVideoViewLoading,
    ZHNStatusVideoViewReload,
    ZHNStatusVideoViewNormal
};

static CGFloat const KBtnSize = 60;
@interface ZHNStatusVideoView()
@property (nonatomic,strong) ZHNRibbonLabel *ribbonLabel;
@property (nonatomic,strong) UIButton *controlBtn;
@end

@implementation ZHNStatusVideoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        [self addSubview:self.ribbonLabel];
        [self addSubview:self.controlBtn];
        
        UITapGestureRecognizer *tapToPlayGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopPlay)];
        [self addGestureRecognizer:tapToPlayGesture];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.width > 0) {
        self.controlBtn.hidden = NO;
        self.controlBtn.center = CGPointMake(self.width/2, self.height/2);
        self.controlBtn.bounds = CGRectMake(0, 0, KBtnSize, KBtnSize);
    }else {
        self.controlBtn.hidden = YES;
    }
}

- (void)tapTopPlay {
    [self zhn_routerEventWithName:KCellTapVideoAction
                         userInfo:@{
                                    KCellTapVideoURLMetaDataKey:self.videoUrlModel,
                                    KCellTapVideoVideoViewKey:self,
                                    KCellTapVideoNeedRemoveFromViewKey:@(NO)
                                    }];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.ribbonLabel intitallizeRibbonWithSuperViewFrame:self.frame rabbionHeight:10 rabbionCornerPadding:25];
}

+ (CGFloat)videoCardHeight {
    return KCellContentWidth/1.8;
}

- (void)setVideoUrlModel:(ZHNTimelineURL *)videoUrlModel {
    _videoUrlModel = videoUrlModel;
    NSString *placeHolder;
    if ([videoUrlModel.replaceString isEqualToString:@"秒拍"]) {
        placeHolder = @"placeholder_miaopai";
    }else {
        placeHolder = @"placeholder_weibovideo";
    }
    
    @weakify(self);
    [self zhn_setImageWithVideoShortUrl:videoUrlModel.urlShort placeholder:placeHolder complete:^(long long videoSize, int videoDuration) {
        // size
        NSString *unit = @"KB";
        CGFloat size = videoSize/1024;
        if (size > 1024) {
            size = size/1024;
            unit = @"MB";
        }
        // duraiton
        int min = videoDuration/60;
        int sec = videoDuration - 60 * min;
        // str
        NSString *str = [NSString stringWithFormat:@"%02d:%02d %.1f%@",min,sec,size,unit];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.ribbonLabel.text = str;
        });
    }];
}

- (UIButton *)controlBtn {
    if (_controlBtn == nil) {
        _controlBtn = [[UIButton alloc]init];
        _controlBtn.userInteractionEnabled = NO;
        [_controlBtn setImage:[UIImage imageNamed:@"status_video_button"] forState:UIControlStateNormal];
        [[_controlBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        }];
    }
    return _controlBtn;
}

- (ZHNRibbonLabel *)ribbonLabel {
    if (_ribbonLabel == nil) {
        _ribbonLabel = [[ZHNRibbonLabel alloc]init];
        _ribbonLabel.font = [UIFont systemFontOfSize:8];
        _ribbonLabel.displaysAsynchronously = YES;
        _ribbonLabel.textColor = [UIColor whiteColor];
        _ribbonLabel.isCustomThemeColor = YES;
        _ribbonLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ribbonLabel;
}
@end
