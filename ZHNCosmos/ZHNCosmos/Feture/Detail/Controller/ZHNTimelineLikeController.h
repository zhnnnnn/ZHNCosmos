//
//  ZHNTimelineLikeController.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/10.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineBaseViewController.h"
#import "ZHNDetailInitDataProtocol.h"
#import "ZHNDetailBasicModel.h"

@interface ZHNTimelineLikeController : ZHNTimelineBaseViewController <ZHNDetailInitDataProtocol>
@property (nonatomic,strong) ZHNTimelineLayoutModel *layout;
@property (nonatomic,strong) ZHNDetailBasicModel *detailBasic;
@end
