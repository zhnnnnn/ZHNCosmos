//
//  ZHNMethodSwizzingHelper.m
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNMethodSwizzingHelper.h"
#import <objc/runtime.h>
@implementation ZHNMethodSwizzingHelper
+ (void)swizzinClass:(Class)swizzingClass OriginalSEL:(SEL)originalSEL TonewSEL:(SEL)newSEL {
    Method originalMehtod = class_getInstanceMethod(swizzingClass, originalSEL);
    Method newMethod = class_getInstanceMethod(swizzingClass, newSEL);
    BOOL didAddMethod = class_addMethod(swizzingClass, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(swizzingClass, newSEL, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));
    }else {
        method_exchangeImplementations(originalMehtod, newMethod);
    }
}
@end
