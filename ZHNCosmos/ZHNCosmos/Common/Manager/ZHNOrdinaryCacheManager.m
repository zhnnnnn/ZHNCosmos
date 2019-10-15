//
//  ZHNOrdinaryCacheManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNOrdinaryCacheManager.h"

@implementation ZHNOrdinaryCacheManager
+ (void)zhn_cacheHometimeLineWatchedOffsety:(CGFloat)offsety {
    [[NSUserDefaults standardUserDefaults] setObject:@(offsety) forKey:@"offset"];
}

+ (CGFloat)zhn_hometimelineWatchedOffsety {
    id offsetObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"offset"];
    if (offsetObject) {
        return [offsetObject floatValue];
    }else {
        return KWatchedOffsetyFirstload;
    }
}

+ (void)zhn_cacheMaxID:(unsigned long long)maxID ForCachedClass:(Class)cachedClass {
    [[NSUserDefaults standardUserDefaults] setObject:@(maxID) forKey:NSStringFromClass(cachedClass)];
}

+ (unsigned long long)zhn_maxIDForCachedClass:(Class)cachedClass {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass(cachedClass)] longLongValue];
}
@end
