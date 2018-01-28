//
//  ZHNControlpadTransitionHelper.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNControlpadTransitionHelper : NSObject
+ (instancetype)shareinstance;
+ (void)showControlpad;
+ (void)dismissControlpadCompletion:(void(^)())completion;
@end
