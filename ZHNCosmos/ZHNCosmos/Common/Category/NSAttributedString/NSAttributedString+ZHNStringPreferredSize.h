//
//  NSAttributedString+ZHNStringPreferredSize.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/19.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (ZHNStringPreferredSize)
- (CGSize)zhn_sizeForMaxWidth:(CGFloat)maxWidth;
@end
