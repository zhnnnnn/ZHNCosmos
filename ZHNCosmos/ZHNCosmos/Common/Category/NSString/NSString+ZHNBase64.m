//
//  NSString+ZHNBase64.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+ZHNBase64.h"

@implementation NSString (ZHNBase64)
- (NSString *)zhn_Base64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
@end
