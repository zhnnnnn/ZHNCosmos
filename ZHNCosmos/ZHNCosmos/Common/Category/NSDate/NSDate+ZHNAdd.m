//
//  NSDate+ZHNAdd.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSDate+ZHNAdd.h"

@implementation NSDate (ZHNAdd)
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
}

- (NSString *)displayDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if ([self isToday]) {
        formatter.dateFormat = @"今天 HH:mm";
    }else {
        formatter.dateFormat = @"yy-MM-dd HH:mm";
    }
    return [formatter stringFromDate:self];
}
@end
