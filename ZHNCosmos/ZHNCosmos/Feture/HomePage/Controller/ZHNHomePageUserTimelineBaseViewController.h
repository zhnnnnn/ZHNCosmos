//
//  ZHNUserAllTimelineViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineBaseViewController.h"
typedef NS_ENUM(NSInteger,ZHNUserTimelineStatusType) {
    ZHNUserTimelineStatusTypeAll = 0,
    ZHNUserTimelineStatusTypeOriginal = 1,
    ZHNUserTimelineStatusTypePic = 2,
    ZHNUserTimelineStatusTypeVideo = 3,
    ZHNUserTimelineStatusTypeMusic = 4
};

@protocol ZHNHomepageUserTimelineScrollDelegate <NSObject>
@optional
- (void)homepageTableViewDidScroll:(UIScrollView *)scrollView;
@end

@interface ZHNHomePageUserTimelineBaseViewController : ZHNTimelineBaseViewController
@property (nonatomic,assign) unsigned long long uid;
@property (nonatomic,assign) ZHNUserTimelineStatusType userStatusType;
@property (nonatomic,weak) id <ZHNHomepageUserTimelineScrollDelegate> delegate;
- (void)initializeLayoutsWithCachesIfHave;
@end
