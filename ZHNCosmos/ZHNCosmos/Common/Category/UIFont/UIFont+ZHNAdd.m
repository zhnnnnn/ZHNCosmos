//
//  UIFont+ZHNAdd.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIFont+ZHNAdd.h"
#import "ZHNCosmosConfigManager.h"

@implementation UIFont (ZHNAdd)
+ (UIFont *)zhn_fontWithSize:(CGFloat)size {
    NSString *fontName = [[ZHNCosmosConfigManager commonConfigModel] fontName];
    return [UIFont fontWithName:fontName size:size];
}
@end
