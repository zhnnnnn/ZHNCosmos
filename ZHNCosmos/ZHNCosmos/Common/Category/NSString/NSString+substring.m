//
//  NSString+substring.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+substring.h"

@implementation NSString (substring)
- (NSString *)zhn_substringFromStr:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound || range.length == 0) {
        return self;
    }else {
        return [self substringFromIndex:range.location + 1];
    }
}

- (NSString *)zhn_substringToStr:(NSString *)str {
    NSRange range = [self rangeOfString:@"|"];
    if (range.location == NSNotFound || range.length == 0) {
        return self;
    }else {
        return [self substringToIndex:range.location];
    }
}

- (NSString *)zhn_subStringFromChar:(NSString *)startChar toChar:(NSString *)endChar {
    NSRange startRange = [self rangeOfString:startChar];
    NSRange endRange = [self rangeOfString:endChar];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

- (NSString *)zhn_replaceStringFromStr:(NSString *)fromStr toString:(NSString *)toStr useStr:(NSString *)useStr {
    // (?<=/)[^@/]+?(?=.gif)
    NSString *pattern = [NSString stringWithFormat:@"(?<=%@)[^@%@]+?(?=%@)",fromStr,fromStr,toStr];
    NSRegularExpression *rangeRegular = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
    NSArray *matches = [rangeRegular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSTextCheckingResult *match = [matches firstObject];
    if (match.range.location == NSNotFound || match.range.length == 0) {
        return self;
    }else {
        return [self stringByReplacingCharactersInRange:match.range withString:useStr];
    }
}
@end
