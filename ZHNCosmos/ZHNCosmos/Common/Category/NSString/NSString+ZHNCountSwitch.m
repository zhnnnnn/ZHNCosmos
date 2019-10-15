//
//  NSString+ZHNCountSwitch.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "NSString+ZHNCountSwitch.h"

@implementation NSString (ZHNCountSwitch)
+ (NSString *)zhn_fitFansCount:(unsigned long long)fansCount {
    if (fansCount < 10000) {
        return [NSString stringWithFormat:@"%lld",fansCount];
    }else {
        fansCount = fansCount/10000;
        return [NSString stringWithFormat:@"%lld万",fansCount];
    }
}
@end
