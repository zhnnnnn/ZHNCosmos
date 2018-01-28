//
//  NSObject+ReponderRouterInvocation.h
//  ZHNResponderRouter
//
//  Created by zhn on 2017/7/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ReponderRouterInvocation)
/**
 Create a invocation (Cache invocation)

 @param selector method selector
 @return invocation
 */
- (NSInvocation *)zhn_createInvocationWithSelector:(SEL)selector;

/**
 Call invocation.(pravite)

 @param invocation invocation
 @param userInfo userinfo
 */
- (void)zhn_invoke:(NSInvocation *)invocation userInfo:(NSDictionary *)userInfo;

/**
 invocation dict

 @return dict
 */
- (NSDictionary *)zhn_currentEventStrategy;

/**
 User name to call invocation

 @param name name
 @param userInfo user info
 */
- (void)zhn_responderRouterWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
@end
