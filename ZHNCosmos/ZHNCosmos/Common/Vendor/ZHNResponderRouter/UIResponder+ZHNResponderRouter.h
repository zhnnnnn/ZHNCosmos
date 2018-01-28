//
//  UIResponder+ZHNResponderRouter.h
//  ZHNResponderRouter
//
//  Created by zhn on 2017/7/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ZHNResponderRouter)
- (void)zhn_routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end
