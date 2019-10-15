//
//  RACSignal+ZHNRichTextHelper.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZHNCosmosConfigManager.h"
#define KHighlightTypeKey @"KHighlightTypeKey"
#define KTextFont [ZHNCosmosConfigManager commonConfigModel].font
#define KTextPadding [ZHNCosmosConfigManager commonConfigModel].padding
@interface RACSignal (ZHNRichTextHelper)
/** @xxx formatter `need formatter at first to init textColor` */
- (RACSignal *)atFormatter;
/** #xxx# formatter */
- (RACSignal *)topicFormatter;
/** emoji formatter */
- (RACSignal *)emojiFormatter;
/** urls formatter */
- (RACSignal *)urlFormatter:(ZHNTimelineStatus *)status richTextMaxWidth:(CGFloat)richTextMaxWidth;
@end
