//
//  NSString+ZHNVideo.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSString+ZHNVideo.h"

@implementation NSString (ZHNVideo)
+ (NSString *)zhn_videoStrForDuration:(NSInteger)duration {
    int min = (int)duration/60;
    int sec = (int)duration - 60 * min;
    return [NSString stringWithFormat:@"%02d:%02d",min,sec];
}
@end
