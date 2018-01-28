//
//  NSObject+isDictionary.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSObject+isDictionary.h"

@implementation NSObject (isDictionary)
- (BOOL)zhn_isDictionary {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}
@end
