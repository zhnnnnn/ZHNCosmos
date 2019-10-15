//
//  NSObject+ZHNSafeJSON.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSObject+ZHNSafeJSON.h"

@implementation NSObject (ZHNSafeJSON)
- (id)zhn_SJMapKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self objectForKey:key];
    }else {
        return nil;
    }
}
@end
