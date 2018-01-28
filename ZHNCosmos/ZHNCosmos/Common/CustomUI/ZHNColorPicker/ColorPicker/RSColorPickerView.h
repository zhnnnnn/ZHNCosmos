//
//  RSColorPickerView.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@class RSColorPickerView, BGRSLoupeLayer;

@protocol RSColorPickerViewDelegate <NSObject>
/**
 * Called everytime the color picker's selection/color is changed.
 * Don't do expensive operations here as it will slow down your app.
 */
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker;
@optional
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

IB_DESIGNABLE
@interface RSColorPickerView : UIView

/**
 * Specifies if the color picker should be drawn as a circle, or as a square.
 */
@property (nonatomic) IBInspectable BOOL cropToCircle;

/**
 * The brightness of the current selection
 */
@property (nonatomic) CGFloat brightness;

/**
 * The opacity of the current selection.
 */
@property (nonatomic) CGFloat opacity;

/**
 * The selection color.
 * This setter may modify `brightness` and `opacity` as necessary.
 */
@property (nonatomic) UIColor * selectionColor;

/**
 * The delegate
 */
@property (nonatomic, weak) id <RSColorPickerViewDelegate> delegate;

/**
 * The current point (in the color picker's bounds) of the selected color.
 */
@property (readwrite) CGPoint selection;

/**
 * The distance around the edges of the color picker that is drawn for padding.
 * Colors are cut-off before this distance so that the user can pick all colors.
 */
@property (readonly) CGFloat paddingDistance;

/**
 * Specifies if the loupe should be drawn or not.
 * Default: YES (show).
 */
@property (nonatomic) BOOL showLoupe;

/**
 * The color at a given point in the color picker's bounds.
 */
- (UIColor *)colorAtPoint:(CGPoint)point;

/**
 * Methods that create/cache data needed to create a color picker.
 * These run async (except where noted) and can help the overall UX.
 */

+ (void)prepareForDiameter:(CGFloat)diameter;
+ (void)prepareForDiameter:(CGFloat)diameter padding:(CGFloat)padding;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding;
+ (void)prepareForDiameter:(CGFloat)diameter scale:(CGFloat)scale padding:(CGFloat)padding inBackground:(BOOL)bg;
@end
