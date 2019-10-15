//
//  ZHNJellyMagicSwitch.h
//  zhnSegmentSwitch
//
//  Created by zhn on 2017/12/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHNJellyMagicSwitchCell,ZHNJellyMagicSwitch;
@protocol ZHNJellyMagicSwitchDataSource <NSObject>
- (NSInteger)numberOfItems;
- (Class)jellyMagicSwitchCellClass;
- (void)displayJellyMagicSwitchCell:(ZHNJellyMagicSwitchCell *)cell ForIndex:(NSInteger)index;
@end

@protocol ZHNJellyMagicSwitchDelegate <NSObject>
@optional
- (void)jellyMagicSwitch:(ZHNJellyMagicSwitch *)magicSwitch switchToPercent:(CGFloat)percent;
- (void)jellyMagicSwitch:(ZHNJellyMagicSwitch *)magicSwitch selectIndex:(NSInteger)index;
@end

@interface ZHNJellyMagicSwitch : UIView
@property (nonatomic,weak) id <ZHNJellyMagicSwitchDataSource> dataSource;
@property (nonatomic,weak) id <ZHNJellyMagicSwitchDelegate> delegate;

/**
 Current show index
 */
@property (nonatomic,assign) NSInteger currentSelectIndex;

/**
 Current show percent
 */
@property (nonatomic,assign) CGFloat switchPercent;

/**
 Slider bounce style. Defalut `NO`
 */
@property (nonatomic,assign) BOOL bounce;

/**
 Slider page enable. Default `NO`
 */
@property (nonatomic,assign) BOOL pageEnable;

/**
 Slider scroll enable. Default `NO`
 */
@property (nonatomic,assign) BOOL scrollEnable;

/**
 Content padding default `5`
 */
@property (nonatomic,assign) CGFloat contentPadding;

/**
 Reload data
 */
- (void)reloadData;

/**
 Reload theme color `backgroundClor` `text select clor` (Normal celll)
 */
- (void)reloadNormalSwitchThemeColor:(UIColor *)color;

/**
 Reload switcher colors

 @param backgroundColor background color
 @param sliderColor slider color
 @param normalTitleColor normal title color
 @param selectTitleColor select title color
 */
- (void)reloadSwitcherAppearanceWithBackgroundColor:(UIColor *)backgroundColor
                                        sliderColor:(UIColor *)sliderColor
                                   normalTitleColor:(UIColor *)normalTitleColor
                                   selectTitleColor:(UIColor *)selectTitleColor;

/**
 Create custom switch. U need implementation datasource.

 @param backgroundColor background color
 @param sliderColor slider color
 @param normalColor cell content normal color
 @param selectColor cell content select color
 @param contentPadding content padding
 @return switch
 */
+ (instancetype)zhn_jellyMagicSwitchWithBackgroundColor:(UIColor *)backgroundColor
                                            sliderColor:(UIColor *)sliderColor
                                 cellContentNormalColor:(UIColor *)normalColor
                                 cellContentSelectColor:(UIColor *)selectColor
                                         contentpadding:(CGFloat)contentPadding;

/**
 Create normal style switch

 @param titles swith titles
 @param normalTitleColor content normal color `label normal color`
 @param selectTitleColor cell content select color `label selct color`
 @param sliderColor slider color
 @param backgroundColor background color
 @return switch
 */
+ (instancetype)zhn_normalJellyMagicSwitchWithTitleArray:(NSArray <NSString *>*)titles
                                               titleFont:(UIFont *)titleFont
                                        normalTitleColor:(UIColor *)normalTitleColor
                                        selectTitleColor:(UIColor *)selectTitleColor
                                             sliderColor:(UIColor *)sliderColor
                                         backgroundColor:(UIColor *)backgroundColor;
@end

/////////////////////////////////////////////////////
@interface ZHNJellyMagicSwitchCell : UIView
@property (nonatomic,strong) UIColor *contentColor;
@property (nonatomic,strong) UILabel *label;
@end
