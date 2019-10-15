//
//  ZHNTimelineDetailToolView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNJellyMagicSwitch.h"
#import "ZHNDetailBasicModel.h"

@protocol ZHNTimelineDetailToolViewDelegate
- (void)toolViewClickToPopController;
@end

@interface ZHNTimelineDetailToolView : UIView
@property (nonatomic,strong) ZHNJellyMagicSwitch *switcher;
@property (nonatomic,weak) id <ZHNTimelineDetailToolViewDelegate> delegate;
@property (nonatomic,strong) ZHNDetailBasicModel *detailBasic;
@end
