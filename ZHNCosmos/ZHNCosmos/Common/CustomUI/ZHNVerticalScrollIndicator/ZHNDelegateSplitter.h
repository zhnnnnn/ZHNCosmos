//
//  ZHNDelegateSplitter.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
// Reference from http://kittenyang.com/forwardinvocation/
@interface ZHNDelegateSplitter : NSObject
+ (instancetype)zhn_delegateSplitterWithDelegateOne:(id)delegateOne delegateTwo:(id)delegateTwo;
@end
