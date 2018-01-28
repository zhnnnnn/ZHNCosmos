//
//  ZHNControlpadSwitch.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SwitchValueChangeHandle) (BOOL dbValue);
@interface ZHNControlpadSwitch : UIView
// for xib set
@property (nonatomic,copy) IBInspectable NSString *leftImageName;
@property (nonatomic,copy) IBInspectable NSString *rightImageName;
@property (nonatomic,copy) IBInspectable NSString *leftTitleName;
@property (nonatomic,copy) IBInspectable NSString *rightTitleName;
@property (nonatomic,copy) IBInspectable NSString *configDBname;
@property (nonatomic,assign) IBInspectable BOOL leftItemForValue;
// 
@property (nonatomic,copy) SwitchValueChangeHandle valueChangeHandle;
@end
