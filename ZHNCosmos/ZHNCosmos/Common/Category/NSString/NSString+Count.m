//
//  NSString+Count.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+Count.h"

@implementation NSString (Count)
+ (NSString *)showStringForCount:(int)count {
    if (count < 10000) {
        return [NSString stringWithFormat:@"%d",count];
    }else {
        count = count/10000;
        return [NSString stringWithFormat:@"%d万",count];
    }
}
@end
