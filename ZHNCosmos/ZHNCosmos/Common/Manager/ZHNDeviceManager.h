//
//  ZHNDeviceManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNDeviceManager : NSObject
/**
 Status bar orientation animate change to LandscapeRight
 */
+ (void)zhn_statusBarAnimateToLandscapeRight;

/**
 Status bar orientation animate change to Portrait
 */
+ (void)zhn_statusBarAnimateToPortrait;

/**
 Fade animate set Status bar hidden

 @param hidden hidden
 */
+ (void)zhn_fadeAnimateStatusBarHidden:(BOOL)hidden;

/**
 Slide animate set Satus bar hidden

 @param hidden hidden
 */
+ (void)zhn_slideAnimateStatusBarHidden:(BOOL)hidden;
@end
