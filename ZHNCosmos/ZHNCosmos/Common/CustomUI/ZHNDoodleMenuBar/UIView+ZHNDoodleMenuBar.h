//
//  UIView+ZHNDoodleMenuBar.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNDoodleMenuBar.h"

typedef void (^ZHNDoodleMenuBarSelectItemHandle)(NSInteger index,BOOL isTypeSelectAfter);
@interface UIView (ZHNDoodleMenuBar)<ZHNDoodleMenuBarDelegate>
/**
 Show menu. Detault tintColor `redColor`
 
 @param menuItemArray menu item array
 */
- (void)zhn_showDoodleMenuBarWithMenuButtonItemArray:(NSArray <ZHNDoodleMenuButtonItem *>*)menuItemArray
                                     clickItemHandle:(ZHNDoodleMenuBarSelectItemHandle)handle;

/**
 Show menu. Custom tintColor

 @param menuItemArray menu item array
 @param tintColor tintColor
 */
- (void)zhn_showDoodleMenuBarWithMenuButtonItemArray:(NSArray<ZHNDoodleMenuButtonItem *> *)menuItemArray
                                           tintColor:(UIColor *)tintColor
                                     clickItemHandle:(ZHNDoodleMenuBarSelectItemHandle)handle;
@end
