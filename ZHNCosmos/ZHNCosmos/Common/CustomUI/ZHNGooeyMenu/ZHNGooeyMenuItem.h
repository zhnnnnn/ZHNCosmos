//
//  ZHNGooeyMenuItem.h
//  ZHNGooeyMenu
//
//  Created by zhn on 2017/10/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHNGooeyItemSeletBlock) (NSInteger seletIndex);
@interface ZHNGooeyMenuItem : UIView
- (instancetype)initWithTitle:(NSString *)title;
@property (nonatomic,copy) ZHNGooeyItemSeletBlock seletAction;
- (void)hightlight;
- (void)normal;
@end

