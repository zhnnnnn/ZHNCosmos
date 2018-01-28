//
//  ZHNImageFileSizeManager.h
//  ZHNTestWebview
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZHNTimelineModel.h"

@class ZHNOpetation;
typedef void(^ZHNImageFileSizeHandle)(long long size,NSURLSessionDataTask *task);
@interface ZHNImageFileSizeManager : NSObject

/**
 Singleton 

 @return singleton
 */
+ (instancetype)shareManager;

/**
 Async get image file size with image url

 @param picMeteData pic meteData
 @param robbionLabel image size show label
 @return operation
 */
- (ZHNOpetation *)zhn_showImagefileSizeForPicMeteData:(ZHNTimelinePicMetaData *)picMeteData
                                       InRobbionLabel:(YYLabel *)robbionLabel;
@end

////////////////////////////////////////////////////////
@interface ZHNOpetation : NSObject
@property (nonatomic,strong) NSOperation *operation;
@property (nonatomic,strong) NSURLSessionDataTask *imageTask;
@property (nonatomic,strong) NSURLSessionDataTask *liveMovTask;
- (void)cancel;
@end
