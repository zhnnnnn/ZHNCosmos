//
//  NSObject+ZHNCosmosTheme.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNThemeManager.h" 

typedef void(^ZHNCosmosNightVersionHandle)();
typedef void(^ZHNCosmosThemeColorHandle)();
@interface NSObject (ZHNCosmosTheme)
//-------------------------- night version --------------------------
/**
 nightversion function use dknightversion lib but somewhere dont meet the need.
 */
@property (nonatomic,copy) ZHNCosmosNightVersionHandle extraNightVersionChangeHandle;

//-------------------------- color theme --------------------------
/**
 need the cache theme color
 */
@property (nonatomic,assign) BOOL isCustomThemeColor;

/**
 is theme color change u want to do something.
 */
@property (nonatomic,copy) ZHNCosmosThemeColorHandle extraThemeColorChangeHandle;
@end

////////////////////////////////////////////////////////
typedef void(^ZHNThemeDeallocerBlock) ();
@interface ZHNThemeDeallocer : NSObject
@property (nonatomic,copy) ZHNThemeDeallocerBlock deallocAction;
+ (ZHNThemeDeallocer *)deallocerWithBlcok:(ZHNThemeDeallocerBlock)block;
@end
