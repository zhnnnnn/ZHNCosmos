//
//  NSString+substring.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (substring)
- (NSString *)zhn_substringFromStr:(NSString *)str;
- (NSString *)zhn_substringToStr:(NSString *)str;
- (NSString *)zhn_subStringFromChar:(NSString *)startChar toChar:(NSString *)endChar;
- (NSString *)zhn_replaceStringFromStr:(NSString *)fromStr toString:(NSString *)toStr useStr:(NSString *)useStr;
@end
