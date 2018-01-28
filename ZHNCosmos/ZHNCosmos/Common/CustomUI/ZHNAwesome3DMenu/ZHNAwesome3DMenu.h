//
//  ZHNAwesome3DMenu.h
//  ZHNAwesome3DMenu
//
//  Created by zhn on 2017/9/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHNAwesome3DMenuDelegate <NSObject>
@optional
- (void)ZHNAwesome3DMenuSelectedIndex:(NSInteger)index;
@end


@class ZHN3DMenuActivity;
@interface ZHNAwesome3DMenu : UIView
/**
 initial method (normal type pan this menu do something,if u do like this longpress a view then add this menu above this view than u want use this 3d menu s effect u need set 'hostGesture' in the longpreass selector)

 @param activityArray item activity array
 @return menu
 */
+ (ZHNAwesome3DMenu *)zhn_3dMenuWithActivityArray:(NSArray <ZHN3DMenuActivity *> *)activityArray;

/**
 center icon image name
 */
@property (nonatomic,copy) NSString *iconImageName;

/**
 host gesture
 */
@property (nonatomic,strong) UIGestureRecognizer *hostGesture;

/**
 animate All item
 */
- (void)animateAllItem;

/**
 delegate
 */
@property (nonatomic,weak) id <ZHNAwesome3DMenuDelegate> delegate;
@end

/////////////////////////////////////////////////////
typedef void(^ZHN3DMenuSelectBlock) ();
@interface ZHN3DMenuActivity : NSObject
// property
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIColor *titnColor;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highLightImage;
@property (nonatomic,copy) ZHN3DMenuSelectBlock selectAction;

/**
 initial method

 @param title title
 @param imageName imageName
 @param normalColor normal image color
 @param highLoghtColor highligt image color
 @param selectAction selct action
 @return activity
 */
+ (ZHN3DMenuActivity *)zhn_activityWithTitle:(NSString *)title
                                   tintColor:(UIColor *)tintColor
                                   imageName:(NSString *)imageName
                                 normalColor:(UIColor *)normalColor
                              highLoghtColor:(UIColor *)highLoghtColor
                             selectionAction:(ZHN3DMenuSelectBlock)selectAction;
/**
 initial method

 @param title title
 @param normalImage normal image
 @param hightLightImage hightlight(selcted) image
 @param selectAction select action
 @return activity
 */
+ (ZHN3DMenuActivity *)zhn_activityWithTitle:(NSString *)title
                                   tintColor:(UIColor *)tintColor
                                 normalImage:(UIImage *)normalImage
                              highLightImage:(UIImage *)hightLightImage
                                selectAction:(ZHN3DMenuSelectBlock)selectAction;
@end
