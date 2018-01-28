//
//  ZHNOrdinaryCacheManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
static CGFloat KWatchedOffsetyFirstload = -1000000;
@interface ZHNOrdinaryCacheManager : NSObject
+ (void)zhn_cacheHometimeLineWatchedOffsety:(CGFloat)offsety;
+ (CGFloat)zhn_hometimelineWatchedOffsety;

+ (void)zhn_cacheMaxID:(unsigned long long)maxID ForCachedClass:(Class)cachedClass;
+ (unsigned long long)zhn_maxIDForCachedClass:(Class)cachedClass;
@end
