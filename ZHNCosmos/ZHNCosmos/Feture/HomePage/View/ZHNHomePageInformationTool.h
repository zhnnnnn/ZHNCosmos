//
//  ZHNHomePageInformationTool.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineModel.h"

@interface ZHNHomePageInformationTool : UIView
@property (nonatomic,strong) ZHNTimelineUser *userDetail;
+ (instancetype)loadView;
@end
