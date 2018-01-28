//
//  ZHNStatusToolView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHNTimelineLayoutModel;
@interface ZHNStatusToolView : UIView
@property (nonatomic,assign) CGRect toolbarFrame;
@property (nonatomic,assign) BOOL isReweet;
@property (nonatomic,strong) ZHNTimelineStatus *status;
@end

////////////////////////////////////////////////////////
@interface ZHNStatusToolBarButton : UIButton

@end
