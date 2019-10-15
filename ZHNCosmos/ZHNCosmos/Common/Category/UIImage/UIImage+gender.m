//
//  UIImage+gender.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UIImage+gender.h"

@implementation UIImage (gender)
+ (UIImage *)zhn_userAvatarPlaceholderImageForGender:(NSString *)gender {
    if ([gender isEqualToString:@"m"]) {
        return [UIImage imageNamed:@"placeholder_user_man"];
    }else {
        return [UIImage imageNamed:@"placeholder_user_woman"];
    }
}
@end
