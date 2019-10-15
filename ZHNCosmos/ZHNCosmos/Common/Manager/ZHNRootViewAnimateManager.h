//
//  ZHNRootViewAnimateManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNRootViewAnimateManager : NSObject
+ (void)showAnimateWithTransformScale:(CGFloat)scale;
+ (void)hideAnimateWithTramsformScale:(CGFloat)scale;

+ (void)showAnimateWithTransformScale:(CGFloat)scale animateDuration:(CGFloat)duration;
+ (void)hideAnimateWithTramsformScale:(CGFloat)scale animateDuration:(CGFloat)duration;
@end
