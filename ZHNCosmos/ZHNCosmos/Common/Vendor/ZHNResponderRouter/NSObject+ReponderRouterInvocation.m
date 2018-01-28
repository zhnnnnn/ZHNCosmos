//
//  NSObject+ReponderRouterInvocation.m
//  ZHNResponderRouter
//
//  Created by zhn on 2017/7/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSObject+ReponderRouterInvocation.h"
#import "UIResponder+ZHNResponderRouter.h"


@implementation NSObject (ReponderRouterInvocation)
- (NSInvocation *)zhn_createInvocationWithSelector:(SEL)selector {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        return nil;
    }
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    return invocation;
}

- (void)zhn_invoke:(NSInvocation *)invocation userInfo:(NSDictionary *)userInfo{
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
}

- (void)zhn_responderRouterWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    NSInvocation *invication = [[self zhn_currentEventStrategy] objectForKey:name];
    [self zhn_invoke:invication userInfo:userInfo];

}

- (NSDictionary *)zhn_currentEventStrategy {
    return nil;
}
@end
