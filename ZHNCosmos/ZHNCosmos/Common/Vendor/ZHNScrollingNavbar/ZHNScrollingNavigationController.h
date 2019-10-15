//
//  ZHNScrollingNavigationController.h
//  ZHNScroll
//
//  Created by zhn on 2017/12/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

//  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀
//  reference from https://github.com/andreamazz/AMScrollingNavbar
//  This project is Swift. I convert it to Objective-c. And i add a title label scale
//  effect just like SFSafariController`s navibar. Usage is in the same way.
//  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀

#import <UIKit/UIKit.h>

@class ZHNScrollingNavigationController;

/**
 The state of the navigation bar
 
 - collapsed: the navigation bar is fully collapsed
 - expanded: the navigation bar is fully visible
 - scrolling: the navigation bar is transitioning to either `Collapsed` or `Scrolling`
 */
typedef NS_ENUM(NSInteger,NavigationBarState) {
    NavigationBarStateCollapsed,
    NavigationBarStateExpend,
    NavigationBarStateScrolling
};

typedef NS_ENUM(NSInteger,ZHNNavibarScrollingType) {
    ZHNNavibarScrollingTypeScrollingAll,
    ZHNNavibarScrollingTypeScrollingLikeSafari
};

/**
 Scrolling Navigation Bar delegate protocol
 */
@protocol ScrollingNavigationControllerDelegate <NSObject>
@optional
/**
 Called when the state of the navigation bar is about to change
 */
- (void)scrollingNavigationController:(ZHNScrollingNavigationController *)controller didChangeState:(NavigationBarState)state;
/**
 Called when the state of the navigation bar changes
 */
- (void)scrollingNavigationController:(ZHNScrollingNavigationController *)controller willChangeState:(NavigationBarState)state;
@end

@interface ZHNScrollingNavigationController : UINavigationController
@property (nonatomic,strong) UIView *scrollableView;

/**
 Returns the `NavigationBarState` of the navigation bar
 */
@property (nonatomic,assign) NavigationBarState state;

/**
 Determines whether the navbar should scroll when the content inside the scrollview fits
 the view's size. Defaults to `NO`
 */
@property (nonatomic,assign) BOOL shouldScrollWhenContentFits;

/**
 Determines if the navbar should expand once the application becomes active after entering background
 Defaults to `YES`
 */
@property (nonatomic,assign) BOOL expandOnActive;

/**
 Determines if the navbar scrolling is enabled.
 Defaults to `YES`
 */
@property (nonatomic,assign) BOOL scrollingEnabled;

/**
 Determines if the controller is pushing or poping.
 Defaults to `NO`
 */
@property (nonatomic,assign) BOOL transitioning;

/**
 Ignore refresh pulling (`ASTableNode` not suppert,If u want `ASTableView` ignore refreshing pull set `delay` to a relatively large value)
 Defaults to `NO`
 */
@property (nonatomic,assign) BOOL ignoreRefreshPulling;

/**
 An array of `UIView`s that will follow the navbar
 */
@property (nonatomic,strong) NSArray *followers;

/**
 The delegate for the scrolling navbar controller
 */
@property (nonatomic,weak) id <ScrollingNavigationControllerDelegate> scrollingNavbarDelegate;

/**
 Start scrolling
 
 Enables the scrolling by observing a view
 
 - parameter scrollableView: The view with the scrolling content that will be observed
 - parameter delay: The delay expressed in points that determines the scrolling resistance. Defaults to `0`
 - parameter scrollSpeedFactor : This factor determines the speed of the scrolling content toward the navigation bar animation
 - parameter followers: An array of `UIView`s that will follow the navbar
 */
- (void)followScrollViewWithScrollableView:(UIView *)scrollableView
                      naviBarScrollingType:(ZHNNavibarScrollingType)scrollingType
                                     delay:(CGFloat)delay
                         scrollSpeedFactor:(CGFloat)scrollSpeedFactor
                                 followers:(NSArray <UIView *> *)followers;

/**
 Hide the navigation bar
 
 - parameter animated: If true the scrolling is animated. Defaults to `true`
 - parameter duration: Optional animation duration. Defaults to 0.1
 */
- (void)hideNavbarWithAnimate:(BOOL)animate
                     duration:(NSTimeInterval)duration;

/**
 Show the navigation bar
 
 - parameter animated: If true the scrolling is animated. Defaults to `true`
 - parameter duration: Optional animation duration. Defaults to 0.1
 */
- (void)showNavbarWithAnimate:(BOOL)animate
                     duration:(NSTimeInterval)duration;

/**
 Stop observing the view and reset the navigation bar
 
 - parameter showingNavbar: If true the navbar is show, otherwise it remains in its current state. Defaults to `true`
 */
- (void)stopFollowingScrollView:(BOOL)showingNavbar;

/**
 Hide system navibar title label
 
 - parameter hidden: If true the navbar is show, otherwise it remains in its current state. Defaults to `true`
 */
- (void)hiddenSystemNavibarTitleLabel:(BOOL)hidden;

/**
 Reload fake navigation title label frame
 */
- (void)reloadFakeNavibarTitleLabelFrame;

/**
 Reload fake navigation title label text color
 */
- (void)reloadFakeNavibarTitleLabelTextColor;
@end
