//
//  NSString+timeInterval.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+timeInterval.h"

@implementation NSString (timeInterval)
+ (NSString *)zhn_getCurrentTimeInterval {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.0f",interval];
}
@end
