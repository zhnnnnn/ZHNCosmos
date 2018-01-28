//
//  NSAttributedString+ZHNCreate.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "NSAttributedString+ZHNCreate.h"

@implementation NSAttributedString (ZHNCreate)
+ (NSAttributedString *)zhn_attributeStringWithStr:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor {
    if (!str) {return nil;}
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:textColor forKey:NSForegroundColorAttributeName];
    [attr setObject:font forKey:NSFontAttributeName];
    NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:str attributes:attr];
    return atrStr;
}
@end
