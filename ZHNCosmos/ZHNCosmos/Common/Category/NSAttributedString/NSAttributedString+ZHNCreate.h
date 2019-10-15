//
//  NSAttributedString+ZHNCreate.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (ZHNCreate)
+ (NSAttributedString *)zhn_attributeStringWithStr:(NSString *)str
                                              font:(UIFont *)font
                                         textColor:(UIColor *)textColor;
@end
