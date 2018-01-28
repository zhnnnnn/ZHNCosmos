//
//  ZHNAlert.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/17.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZHNAlertClickAction)();
@interface ZHNAlert : NSObject
/**
 Show alert ,show one btn only

 @param message message
 @param confirmTitle confirm title
 @param confirmAction confirm handle
 */
+ (void)zhn_showAlertWithMessage:(NSString *)message
                    confirmTitle:(NSString *)confirmTitle
                   confirmAction:(ZHNAlertClickAction)confirmAction;

/**
 Show alert, show two btn

 @param message message
 @param cancleTitle cancle title
 @param cancleAction cancle handle
 @param confirmTitle confirm title
 @param confirmAction confirm handle
 */
+ (void)zhn_showAlertWithMessage:(NSString *)message
                     CancleTitle:(NSString *)cancleTitle
                    cancleAction:(ZHNAlertClickAction)cancleAction
                    confirmTitle:(NSString *)confirmTitle
                   confirmAction:(ZHNAlertClickAction)confirmAction;
@end

////////////////////////////////////////////////////////
@interface ZHNALertMenuView : UIView
+ (ZHNALertMenuView *)zhn_menuWithMessage:(NSString *)message
                              cancleTitle:(NSString *)cancleTitle
                             confirmTitle:(NSString *)confrimTitle
                             cancleAction:(ZHNAlertClickAction)cancleAction
                            confirmAction:(ZHNAlertClickAction)confrimAction
                                 blurView:(UIVisualEffectView *)blurView;

@property (nonatomic,strong) UIColor *alertColor;

- (CGSize)alertFitSize;
@end
