//
//  ZHNPicDataLoadManager.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/15.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNPicDataAsyncLoadManager : NSObject
@property (nonatomic,strong) NSOperationQueue *picloadQueue;
+ (instancetype)shareManager;
@end
