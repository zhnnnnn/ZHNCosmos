//
//  RACSignal+statusMapping.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (statusMapping)

/**
 Complete formatter rich text. contain 'URLMapReweet,formatterRichText,layout'

 @return layout single
 */
- (RACSignal *)completeFormatter;

/**
 Use short url to get long url and mapping long url`s `replace string` `icon` `color`

 @param isReweet is Reweet status
 @return status single
 */
- (RACSignal *)URLMapReweet:(BOOL)isReweet;

/**
 Formatter rich text contain `@` `topic` `emoji` `url`

 @return status single
 */
- (RACSignal *)formatterRichTextMaxWidth:(CGFloat)maxWidth;

/**
 Create cell`s subview`s frame

 @return layout single
 */
- (RACSignal *)layout;
@end
