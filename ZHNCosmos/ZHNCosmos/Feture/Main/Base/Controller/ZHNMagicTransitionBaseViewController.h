//
//  ZHNMagicTransitionBaseViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNScrollingNavigationBaseViewController.h"

@interface ZHNMagicTransitionBaseViewController : ZHNScrollingNavigationBaseViewController <UINavigationControllerDelegate,UINavigationBarDelegate>
 //If a `ZHNMagicTransitionBaseViewController` add a child `ZHNMagicTransitionBaseViewController`, Transition will have bug, So need to overwrite `reloadNavigationDalegate` method but do nothing, And set `panControllPopGesture` `endable = NO` in `viewDidLoad`
@property (nonatomic,strong) UIScreenEdgePanGestureRecognizer *panControllPopGesture;

- (void)reloadNavigationDalegate;
@end
