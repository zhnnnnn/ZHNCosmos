//
//  ZHNCosmosLoginView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNCosmosLoginView : UIView
/**
 Animate show loginView
 */
+ (void)zhn_showLoginView;

/**
 Create loginView

 @return loginView
 */
+ (instancetype)zhn_loadView;
@end
