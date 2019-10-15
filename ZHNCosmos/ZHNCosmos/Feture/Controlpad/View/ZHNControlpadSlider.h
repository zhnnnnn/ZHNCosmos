//
//  ZHNControlpadSlider.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^controlPadSliderValueChangeHandle)(CGFloat value);
@interface ZHNControlpadSlider : UIView
@property (nonatomic,copy) IBInspectable NSString *cofigDBName;
@property (nonatomic,assign) IBInspectable CGFloat maxValue;
@property (nonatomic,assign) IBInspectable CGFloat minValue;
@property (nonatomic,assign) CGFloat currentValue;
@property (nonatomic,copy) controlPadSliderValueChangeHandle valueChangeHandle;
@end
