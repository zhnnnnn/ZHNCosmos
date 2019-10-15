//
//  ZHNColorPickerView.h
//  ZHNColorPicker
//
//  Created by zhn on 2017/10/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHNColorPickerViewDelegate <NSObject>
@optional
- (void)ZHNColorPickerPickColor:(UIColor *)color;
@end

@interface ZHNColorPickerView : UIView
/**
 start show color (while layout show color)
 */
@property (nonatomic,strong) UIColor *showColor;

/**
 get select color
 */
@property (nonatomic,strong) UIColor *pickerSelectColor;

/**
 delegate
 */
@property (nonatomic,weak) id <ZHNColorPickerViewDelegate> delegate;

/**
 reload show color

 @param showColor show color
 */
- (void)reloadShowColor:(UIColor *)showColor;
@end
