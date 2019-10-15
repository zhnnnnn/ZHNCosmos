//
//  NSMutableDictionary+ZHNSafe.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ZHNSafe)
- (void)zhn_safeSetObjetct:(id)object forKey:(NSString *)key;
@end
