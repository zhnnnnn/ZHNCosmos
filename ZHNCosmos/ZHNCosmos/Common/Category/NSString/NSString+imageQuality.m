//
//  NSString+imageQuality.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+imageQuality.h"
static NSString *const KthumbnailKey = @"thumbnail";
static NSString *const Kmiddle_360PKey = @"wap360";
static NSString *const Kmiddle_720PKey = @"bmiddle";
static NSString *const KlargeKey = @"large";
@implementation NSString (imageQuality)
- (NSString *)thumbil {
    for (NSString *key in [self keyArray]) {
        if ([self containsString:key]) {
            return [self stringByReplacingOccurrencesOfString:key withString:KthumbnailKey];
        }
    }
    return nil;
}

- (NSString *)middle_720P {
    for (NSString *key in [self keyArray]) {
        if ([self containsString:key]) {
            return [self stringByReplacingOccurrencesOfString:key withString:Kmiddle_720PKey];
        }
    }
    return nil;
}

- (NSString *)middle_360P {
    for (NSString *key in [self keyArray]) {
        if ([self containsString:key]) {
            return [self stringByReplacingOccurrencesOfString:key withString:Kmiddle_360PKey];
        }
    }
    return nil;
}

- (NSString *)large {
    for (NSString *key in [self keyArray]) {
        if ([self containsString:key]) {
            return [self stringByReplacingOccurrencesOfString:key withString:KlargeKey];
        }
    }
    return nil;
}

- (NSArray <NSString *> *) keyArray {
    return @[KthumbnailKey,Kmiddle_720PKey,KlargeKey,Kmiddle_360PKey];
}
@end
