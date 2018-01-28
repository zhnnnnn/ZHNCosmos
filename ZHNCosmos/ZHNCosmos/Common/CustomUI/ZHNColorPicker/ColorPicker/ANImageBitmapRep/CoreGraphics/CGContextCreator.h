//
//  CGContextCreator.h
//  ImageBitmapRep
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#elif TARGET_OS_MAC
#import <Quartz/Quartz.h>
#endif

/**
 * This class has several static methods for creating bitmap contexts.
 * These methods are pretty much only called when creating a new
 * ANImageBitmapRep.
 */
@interface CGContextCreator : NSObject {
    
}

+ (CGContextRef)newARGBBitmapContextWithSize:(CGSize)size;
+ (CGContextRef)newARGBBitmapContextWithImage:(CGImageRef)image;

@end
