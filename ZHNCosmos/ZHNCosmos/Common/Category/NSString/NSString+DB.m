//
//  NSString+DB.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+DB.h"

@implementation NSString (DB)
+ (NSString *)DBPathWithClass:(Class)cls {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbDir = [NSString stringWithFormat:@"db_%@",NSStringFromClass(cls)];
    return [documentsDirectory stringByAppendingPathComponent:dbDir];
}
@end
