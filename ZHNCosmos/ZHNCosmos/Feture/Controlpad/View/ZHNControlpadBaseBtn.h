//
//  ZHNControlpadBaseBtn.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^normalHandle) ();
typedef void (^checkMarkHandle) (BOOL value);
@interface ZHNControlpadBaseBtn : UIView
@property (nonatomic,assign) BOOL isHightlight;
@property (nonatomic,copy) IBInspectable NSString *title;
@property (nonatomic,copy) IBInspectable NSString *imageName;
@property (nonatomic,assign) IBInspectable BOOL isNoNeedCornerRadius;


@property (nonatomic,copy) normalHandle normalHandle;
@property (nonatomic,copy) checkMarkHandle checkMarkHandle;

- (void)btnClickHandle;
@end
