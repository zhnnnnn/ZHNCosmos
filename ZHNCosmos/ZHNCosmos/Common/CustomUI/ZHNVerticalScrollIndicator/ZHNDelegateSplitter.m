//
//  ZHNDelegateSplitter.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNDelegateSplitter.h"

@interface ZHNDelegateSplitter()
@property (nonatomic,weak) id delegateOne;
@property (nonatomic,weak) id delegateTwo;
@end

@implementation ZHNDelegateSplitter
+ (instancetype)zhn_delegateSplitterWithDelegateOne:(id)delegateOne delegateTwo:(id)delegateTwo {
    ZHNDelegateSplitter *splitter = [[ZHNDelegateSplitter alloc]init];
    splitter.delegateOne = delegateOne;
    splitter.delegateTwo = delegateTwo;
    return splitter;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signatureOne = [self.delegateOne methodSignatureForSelector:aSelector];
    NSMethodSignature *singnatureTwo = [self.delegateTwo methodSignatureForSelector:aSelector];
    if (signatureOne) {
        return signatureOne;
    }else if (singnatureTwo) {
        return singnatureTwo;
    }else {
        return nil;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    if ([self.delegateOne respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.delegateOne];
    }
    if ([self.delegateTwo respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.delegateTwo];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegateOne respondsToSelector:aSelector] || [self.delegateTwo respondsToSelector:aSelector]) {
        return YES;
    }else {
        return NO;
    }
}
@end
