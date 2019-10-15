//
//  ZHNCosmosTabbar.m
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosTabbar.h"
#import "ZHNShineButton.h"
#import "UIImage+Tint.h"
#import "ZHNTimer.h"
#import "ZHNUniversalSettingMenu.h"
#import "ZHNNavigationViewController.h"
#import "ZHNCosmosLongPressButton.h"
#import "ZHNCosmosTabbarController.h"

#define INTERGER_TO_STRING(idx) [NSString stringWithFormat:@"%ld",idx]
static const CGFloat KTabbarTransitionDelta = 30;
static const CGFloat KTabbarTransitionDuration = 0.25;
@interface ZHNCosmosTabbar()
@property (nonatomic,strong) UIView *fakePlaceholder;
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIView *promptView;
@property (nonatomic,weak) ZHNCosmosTabbarItem *selectItem;
@property (nonatomic,strong) UIVisualEffectView *blurView;
@end

@implementation ZHNCosmosTabbar
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        COSWEAKSELF
        self.extraNightVersionChangeHandle = ^{
            [ZHNThemeManager zhn_extraNightHandle:^{
                weakSelf.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            } dayHandle:^{
                weakSelf.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            }];
        };
    }
    return self;
}

#pragma mark - public methods
- (void)reloadTabbarControllerConfigWithNewModelArray:(NSArray<ZHNCosmosTabbarItemModel *> *)newItemModelArray {
    if (newItemModelArray.count != self.itemModelArray.count) {return;}
    // if different reload data
    [newItemModelArray enumerateObjectsUsingBlock:^(ZHNCosmosTabbarItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.itemName != self.itemModelArray[idx].itemName) {
            self.itemModelArray = newItemModelArray;
            return;
        }
    }];
}

- (void)reloadQuickMenuCofigWithModelArray:(NSArray<ZHN3DMenuActivity *> *)menuActivityArray {
    [self.toolView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZHNCosmosLongPressButton class]]) {
            ZHNCosmosLongPressButton *lbtn = (ZHNCosmosLongPressButton *)obj;
            lbtn.coronaActivityArray = menuActivityArray;
            return;
        }
    }];
}

#pragma mark - setters
- (void)setItemModelArray:(NSArray<ZHNCosmosTabbarItemModel *> *)itemModelArray {
    _itemModelArray = itemModelArray;
    // clear tabbar item
    [self.blurView removeFromSuperview];
    [self.toolView removeFromSuperview];
    self.selectItem = nil;
    self.toolView = nil;
    
    self.fakePlaceholder = [[UIView alloc]init];
    self.fakePlaceholder.isCustomThemeColor = YES;
    [self.superController.view addSubview:self.fakePlaceholder];
    self.fakePlaceholder.frame = self.superController.view.bounds;
    
    // init tabbar item
    for (NSInteger index = 0; index < _itemModelArray.count; index++) {
        ZHNCosmosTabbarItemModel *item = _itemModelArray[index];
        switch (item.itemType) {
            case ZHNTabbarItemTypeShineBtn:
            {
                // get config to init tabbar item
                COSWEAKSELF
                ZHNCosmosTabbarItem *barItem = [[ZHNCosmosTabbarItem alloc]init];
                barItem.tabbarItemName = item.itemName;
                barItem.tag = index;
                barItem.normalImage = [[UIImage imageNamed:item.imageName] imageWithTintColor:KTabbarItemNormalColor];
                __weak __typeof__(barItem) weakbarItem = barItem;
                // select tabbar s action
                barItem.selectAction = ^{
                    // controller transition
                    ZHNCosmosTabbarItemModel *selectModel = _itemModelArray[weakSelf.selectItem.tag];
                    ZHNCosmosTabbarItemModel *gotoModel = _itemModelArray[weakbarItem.tag];
                    UIViewController *fromController = [weakSelf.subControllerDict objectForKey:selectModel.itemName];
                    UIViewController *toController = [weakSelf.subControllerDict objectForKey:gotoModel.itemName];
                    if (weakbarItem.tag > weakSelf.selectItem.tag) {
                        [weakSelf p_controllerTransitionWithFromController:fromController
                                                              toController:toController
                                                         isDirectiontoLeft:YES];
                    }else {
                        [weakSelf p_controllerTransitionWithFromController:fromController
                                                              toController:toController
                                                         isDirectiontoLeft:NO];
                    }
                    // tabbar item
                    [weakSelf.selectItem deselect];
                    weakSelf.selectItem = weakbarItem;
                };
                barItem.reloadAction = item.reloadAction;
                [self.toolView addSubview:barItem];

                // init controller
                UIViewController *controller = [self.subControllerDict objectForKey:item.itemName];
                if (!controller) {
                    UIViewController *subController = [[item.controllerCls alloc]init];
                    ZHNNavigationViewController *subNaviController = [[ZHNNavigationViewController alloc]initWithRootViewController:subController];
                    [self.superController addChildViewController:subNaviController];
                    // cache controller
                    [self.subControllerDict setObject:subNaviController forKey:item.itemName];
                }
                
                if (index == 0) {
                    self.selectItem = barItem;
                }
            }
                break;
            case ZHNTabbarItemTypeLongPressBtn:
            {
                ZHNCosmosLongPressButton *btn = [[ZHNCosmosLongPressButton alloc]init];
                btn.imageName = item.imageName;
                btn.tapAction = item.tapAction;
                btn.coronaActivityArray = item.activityArray;
                [self.toolView addSubview:btn];
            }
                break;
            default:
                break;
        }
    }
    
    // ChildController`s view frame
    for (NSString *itemName in self.subControllerDict.allKeys) {
        UIViewController *controller = [self.subControllerDict objectForKey:itemName];
        [self.superController.view insertSubview:controller.view belowSubview:self.fakePlaceholder];
        controller.view.frame = self.superController.view.bounds;
    }
    UIViewController *defaultSelectController = [self.subControllerDict objectForKey:self.selectItem.tabbarItemName];
    [self.superController.view addSubview:defaultSelectController.view];
    defaultSelectController.view.frame = self.superController.view.bounds;
    [self.selectItem noAnimateSelect];
    
    // Normal view frame
    [self addSubview:self.blurView];
    [self addSubview:self.toolView];
    self.blurView.frame = CGRectMake(0, K_tabbar_safeArea_height, K_SCREEN_WIDTH, K_tabbar_height);
    self.toolView.frame = CGRectMake(0, K_tabbar_safeArea_height, K_SCREEN_WIDTH, K_tabbar_height);
    [self.toolView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = K_SCREEN_WIDTH / self.itemModelArray.count;
        obj.frame = CGRectMake(idx * width, 0, width, K_tabbar_response_height);
    }];
    [self.superController.view bringSubviewToFront:self];
}

#pragma mark - pravite methods
- (void)p_controllerTransitionWithFromController:(UIViewController *)fromController toController:(UIViewController *)toController isDirectiontoLeft:(BOOL)toLeft {
    // tempView just fo animate
    UIView *tempView = [[UIView alloc]init];
    tempView.dk_backgroundColorPicker = DKColorPickerWithKey(NormalViewBG);
    UIView *supView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    tempView.frame = supView.bounds;
    [supView insertSubview:tempView atIndex:1];
    
    if (toLeft) {// animate <-
        [self.superController.view insertSubview:toController.view belowSubview:self.superController.tabbar];
        [self.superController.view insertSubview:fromController.view belowSubview:self.superController.tabbar];
        toController.view.frame = CGRectMake(KTabbarTransitionDelta, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
        [UIView animateWithDuration:KTabbarTransitionDuration animations:^{
            fromController.view.frame = CGRectMake(-KTabbarTransitionDelta, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
            fromController.view.alpha = 0;
            toController.view.frame = self.superController.view.bounds;
        } completion:^(BOOL finished) {
            fromController.view.alpha = 1;
            [fromController.view removeFromSuperview];
            [tempView removeFromSuperview];
        }];
    }else {// animate ->
        [self.superController.view insertSubview:toController.view belowSubview:self.superController.tabbar];
        [self.superController.view insertSubview:fromController.view belowSubview:self.superController.tabbar];
        toController.view.frame = CGRectMake(-KTabbarTransitionDelta, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
        [UIView animateWithDuration:KTabbarTransitionDuration animations:^{
            fromController.view.frame = CGRectMake(KTabbarTransitionDelta, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
            fromController.view.alpha = 0;
            toController.view.frame = self.superController.view.bounds;
        } completion:^(BOOL finished) {
            fromController.view.alpha = 1;
            [fromController.view removeFromSuperview];
            [tempView removeFromSuperview];
        }];
    }
}

#pragma mark - getters
- (UIViewController *)selectedController {
    ZHNCosmosTabbarItemModel *itemModel = self.itemModelArray[self.selectItem.tag];
    return [self.subControllerDict objectForKey:itemModel.itemName];
}

- (UIView *)toolView {
    if (_toolView == nil) {
        _toolView = [[UIView alloc]init];
        _toolView.backgroundColor = [UIColor clearColor];
    }
    return _toolView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        _blurView = [[UIVisualEffectView alloc]init];
    }
    return _blurView;
}

- (NSMutableDictionary *)subControllerDict {
    if (_subControllerDict == nil) {
        _subControllerDict = [NSMutableDictionary dictionary];
    }
    return _subControllerDict;
}
@end

