//
//  ZHNDirectMessageModel.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/21.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineModel.h"
@class ZHNDirectMessageDetailModel;
@interface ZHNDirectMessageModel : NSObject <YYModel>
@property (nonatomic,strong) ZHNTimelineUser *user;
@property (nonatomic,assign) NSInteger unreadCount;
@property (nonatomic,strong) ZHNDirectMessageDetailModel *directMessage;
@end

////////////////////////////////////////////////////////
@interface ZHNDirectMessageDetailModel : NSObject <YYModel>
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) NSDate *createdAt;
@end
