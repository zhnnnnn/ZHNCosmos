//
//  UIResponder+ZHNResponderRouter.m
//  ZHNResponderRouter
//
//  Created by zhn on 2017/7/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIResponder+ZHNResponderRouter.h"
#import <objc/runtime.h>

@implementation UIResponder (ZHNResponderRouter)
- (void)zhn_routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self.nextResponder zhn_routerEventWithName:eventName userInfo:userInfo];
}

@end
