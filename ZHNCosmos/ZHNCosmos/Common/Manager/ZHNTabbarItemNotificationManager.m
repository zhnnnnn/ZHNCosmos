//
//  ZHNTabbarItemNotificationManager.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/16.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTabbarItemNotificationManager.h"

@implementation ZHNTabbarItemNotificationManager
+ (void)tabbarClickToReloadStatuesWithControllerClass:(Class)controllerClass {
    NSString *notificationName = [self p_notificationNameForClass:controllerClass];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

+ (void)tabbarObserveToReloadStatuesWithController:(NSObject *)controller handle:(void (^)())handle {
    NSString *notificationName = [self p_notificationNameForClass:[controller class]];
    [[[[NSNotificationCenter defaultCenter]
    rac_addObserverForName:notificationName object:nil]
    takeUntil:controller.rac_willDeallocSignal]
    subscribeNext:^(id x) {
        if (handle) {
            handle();
        }
    }];
}

+ (NSString *)p_notificationNameForClass:(Class)className {
    NSString *notificationName = [NSString stringWithFormat:@"%@_reloadData",NSStringFromClass(className)];
    return notificationName;
}
@end
