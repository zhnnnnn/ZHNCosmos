//
//  NSMutableDictionary+ZHNSafe.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSMutableDictionary+ZHNSafe.h"

@implementation NSMutableDictionary (ZHNSafe)
- (void)zhn_safeSetObjetct:(id)object forKey:(NSString *)key {
    if (object && key) {
        [self setObject:object forKey:key];
    }
}
@end
