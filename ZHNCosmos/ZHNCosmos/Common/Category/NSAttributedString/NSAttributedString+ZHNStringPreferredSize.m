//
//  NSAttributedString+ZHNStringPreferredSize.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/19.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "NSAttributedString+ZHNStringPreferredSize.h"

@implementation NSAttributedString (ZHNStringPreferredSize)
- (CGSize)zhn_sizeForMaxWidth:(CGFloat)maxWidth {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self];
    return layout.textBoundingSize;
}
@end
