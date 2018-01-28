//
//  ZHNTabbarItemNotificationManager.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/16.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNTabbarItemNotificationManager : NSObject
/**
 Click tabbar select item to reload data (Post a notificaiton)

 @param controllerClass clicked controller class
 */
+ (void)tabbarClickToReloadStatuesWithControllerClass:(Class)controllerClass;

/**
 Add notification to reload data

 @param controller click controller 
 @param handle reload data handle
 */
+ (void)tabbarObserveToReloadStatuesWithController:(NSObject *)controller handle:(void(^)())handle;
@end
