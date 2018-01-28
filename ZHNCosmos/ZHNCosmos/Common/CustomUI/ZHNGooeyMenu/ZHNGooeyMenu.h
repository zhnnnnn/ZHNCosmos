//
//  ZHNGooeyMenu.h
//  ZHNGooeyMenu
//
//  Created by zhn on 2017/10/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

// reference from https://github.com/KittenYang GooeySlideMenu

#import <UIKit/UIKit.h>
typedef void (^ZHNGooeyClickHandle) (NSInteger index, NSString *title);
@interface ZHNGooeyMenu : UIView

/**
 menu no need show current select index

 @param titleArray title string array
 @param Height every item height
 @param color menu backgroundcolor
 @return menu
 */
- (ZHNGooeyMenu *)initWithTitleArray:(NSArray <NSString *> *)titleArray
                          itemHeight:(CGFloat)Height
                           menuColor:(UIColor *)color;

/**
 menu need show current select index

 @param titleArray title string array
 @param Height every item height
 @param color menu background color
 @param index current index
 @return menu
 */
- (ZHNGooeyMenu *)initWithTitleArray:(NSArray<NSString *> *)titleArray
                          itemHeight:(CGFloat)Height
                           menuColor:(UIColor *)color
                         selectIndex:(NSInteger)index;

/**
 reload menu with current index

 @param index current index
 */
- (void)reloadMenuWitSelectIndex:(NSInteger)index;

/**
 click item handle
 */
@property (nonatomic,copy) ZHNGooeyClickHandle clickHandle;

/**
 show this menu
 */
- (void)showMenu;
@end

