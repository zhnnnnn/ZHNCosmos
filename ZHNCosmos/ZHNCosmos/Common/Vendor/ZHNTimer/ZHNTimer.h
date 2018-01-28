//
//  ZHNTimer.h
//  ZHNTimer
//
//  Created by zhn on 2017/5/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^zhn_repeatHandlerBlock)();
@interface ZHNTimer : NSObject
/**
 初始化定时器

 @param seconds 定时器的时间间隔
 @param repeats 定时器是否需要重复
 @param queue 执行线程
 @param handler 间隔执行的操作
 @return 定时器
 */
+ (ZHNTimer *)zhn_timerWIthTimeInterval:(NSTimeInterval)seconds
                                repeats:(BOOL)repeats
                                  queue:(dispatch_queue_t)queue
                                handler:(zhn_repeatHandlerBlock)handler;


/**
 初始化定时器(在主线程)

 @param seconds 定时器的时间间隔
 @param repeats 定时器是否需要重复
 @param handler 间隔执行的操作
 @return 定时器
 */
+ (ZHNTimer *)zhn_timerWIthTimeInterval:(NSTimeInterval)seconds
                                repeats:(BOOL)repeats
                                handler:(zhn_repeatHandlerBlock)handler;

/**
 开始定时器
 */
- (void)fire;

/**
 暂停定时器
 */
- (void)frozen;

/**
 销毁定时器
 */
- (void)invalidate;
@end
