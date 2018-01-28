//
//  ZHNPreloadHighQualityPicManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNPreloadHighQualityPicManager : NSObject
+ (instancetype)manager;
- (void)preloadHighQualityPicForImageURLStr:(NSString *)imageURLStr;

/** pravite */
@property (nonatomic,strong) NSOperationQueue *preloadQueue;
@end
