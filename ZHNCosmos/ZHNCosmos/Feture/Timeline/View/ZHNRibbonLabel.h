//
//  ZHNRibbonLabel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <YYText/YYText.h>

@interface ZHNRibbonLabel : YYLabel
- (void)intitallizeRibbonWithSuperViewFrame:(CGRect)superFrame
                              rabbionHeight:(CGFloat)height
                       rabbionCornerPadding:(CGFloat)padding;
@end
