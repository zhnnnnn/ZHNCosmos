//
//  ZHNStatusVideoView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineModel.h"

@interface ZHNStatusVideoView : UIImageView
+ (CGFloat)videoCardHeight;
@property (nonatomic,strong) ZHNTimelineURL *videoUrlModel;
@end
