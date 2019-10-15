//
//  RACSignal+CommentsPreferredSize.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (CommentsPreferredSize)
- (RACSignal *)preferredSizeWithMaxWidth:(CGFloat)maxWidth;
@end
