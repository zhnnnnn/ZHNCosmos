//
//  ZHNColorSaturationBrightnessPickerView.h
//  ZHNColorPicker
//
//  Created by zhn on 2017/9/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ZHNGetHSB.h"

@protocol ZHNColorSaturationBrightnessPickerDeleate <NSObject>
@optional
- (void)zhn_saturationBrightnessPickerDragingColor:(UIColor *)color;
- (void)zhn_saturationBrightnessPickerSelectedColor:(UIColor *)color;
@end

@interface ZHNColorSaturationBrightnessPickerView : UIView
/**
 select tint color h , s = 1, b = 1;
 */
@property (nonatomic,strong) UIColor *pickerTintColor;


/**
 show color hsb for indicaior position
 */
@property (nonatomic,assign) HSBType colorHSB;

/**
 selctColor
 */
@property (nonatomic,strong) UIColor *selectColor;

/**
 indicator radius
 */
@property (nonatomic,assign,readonly) CGFloat indicatorRadius;

/**
 delegate
 */
@property (nonatomic,weak) id <ZHNColorSaturationBrightnessPickerDeleate> delegate;

/**
 update picker color

 @param pickerColor color
 */
- (void)updatePickerColor:(UIColor *)pickerColor;

/**
 reload picker (set a color not change color with touch)

 @param pickerColor picker show color (saturation = 1 ,brightnesscololr = 1)
 @param colrHSB color hsb (indicator color hsb)
 */
- (void)reloadPickerWithPickerColor:(UIColor *)pickerColor colorHSB:(HSBType)colrHSB;
@end

///////////////////////////////////////////////////// indicator
@interface ZHNSAPickerIndicator : UIView
/**
 indicator color
 */
@property (nonatomic,strong) UIColor *indicatorColor;

/**
 touch begin dealing

 @param touch touch
 @param path fit path
 */
- (void)zhn_indicatorTouchBeginWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path;

/**
 touch move dealing
 
 @param touch touch
 @param path fit path
 */
- (void)zhn_indicatorTouchMovedWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path;

/**
 touch end or cancle dealing

 @param touch touch
 @param path fit path
 */
- (void)zhn_indicatorTouchEndWithTouch:(UITouch *)touch limitCyclePath:(UIBezierPath *)path;

/**
 get the fit point. if u touch outside view need some count.

 @param oldPoint old point may outside the size
 @param path fit path
 @return new fit point
 */
- (CGPoint)fitPointWithOldPoint:(CGPoint)oldPoint limitCyclePath:(UIBezierPath *)path;
@end

///////////////////////////////////////////////////// gradient
@interface ZHNSaturationView : UIView

/**
 saturation = 1 brightness = 1 color for color change
 */
@property (nonatomic,strong) UIColor *sbColor;

/**
 update color

 @param color show color
 */
- (void)updateSbColor:(UIColor *)color;
@end

/////////////////////////////////////////////////////
@interface ZHNBrightnessView : UIView

@end


