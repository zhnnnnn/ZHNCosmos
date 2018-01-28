//
//  ZHNVideoPlayer.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHNVideoDirection) {
    ZHNVideoDirectionHorizon,
    ZHNVideoDirectionVertical
};

@protocol ZHNVideoPlayerDelegate <NSObject>
- (void)ZHNVideoPlayerClickToDimiss;
- (void)ZHNVideoPlayerClickToFullScreen:(BOOL)isFullScreen videoDirection:(ZHNVideoDirection)direction;
- (void)ZHNVideoPlayerClickDownload;
@end

@interface ZHNVideoPlayer : UIView
@property (nonatomic,weak) id <ZHNVideoPlayerDelegate> delegate;
- (void)zhn_playeWithVideoURL:(NSURL *)videoURL;
@end
