//
//  NSString+ZHNURLParams.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+ZHNURLParams.h"

@implementation NSString (ZHNURLParams)
- (NSString *)zhn_analyticURLForparam:(NSString *)param {
    NSError *error;
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [self substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return @"";
}

@end
