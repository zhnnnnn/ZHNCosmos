//
//  AppDelegate.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHNCosmosTabbarController.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNStatusHelper.h"
#import "JPFPSStatus.h"
#import "ZHNTimelineStatusConfigReloadObserver.h"
#import "ZHNCosmosLoginView.h"
#import "ZHNUserMetaDataModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Config
    [ZHNThemeManager zhn_initializeThemeColorAndRecommendColorArrayIfNeed];
    [ZHNCosmosConfigManager zhn_initializeConfigIfNeed];
    // TabbarController
    UIWindow *keyWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = keyWindow;
    keyWindow.rootViewController = [[ZHNCosmosTabbarController alloc]init];
    keyWindow.isCustomThemeColor = YES;
    [keyWindow makeKeyAndVisible];
    // `Theme` `Night Version`
    [ZHNTimelineStatusConfigReloadObserver shareInstance];
    // Monitor net work
    [[ZHNNetworkManager shareInstance] startMonitorNetworkType];
    // Show fps label
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![ZHNUserMetaDataModel displayUserMetaData]) {
            [ZHNCosmosLoginView zhn_showLoginView];
        }
    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
