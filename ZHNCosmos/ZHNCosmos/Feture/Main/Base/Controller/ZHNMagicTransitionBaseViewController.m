//
//  ZHNMagicTransitionBaseViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/9/28.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNMagicTransitionBaseViewController.h"
#import "ZHNMagicPopTransition.h"
#import "ZHNTabbarAnimateManager.h"
#import "ZHNMagicPushTransition.h"
#import "ZHNPresentFakePushTransition.h"
#import "ZHNDismissFakePopTransition.h"
#import "UIViewController+ZHNCosmosNavibarAlpha.h"
#import "UINavigationController+ZHNCosmosNavibarAlpha.h"
#import "ZHNTimer.h"

@interface ZHNMagicTransitionBaseViewController ()
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *percentInteractionTransition;
@property (nonatomic,assign) CGFloat fromNavigationBarAlpha;
@property (nonatomic,assign) CGFloat toNavigationBarAlpha;
@property (nonatomic,assign) BOOL isShowTabbar;
@property (nonatomic,strong) ZHNTimer *transitionTimer;
@property (nonatomic,strong) UINavigationController *zhn_naviController;
@end

@implementation ZHNMagicTransitionBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgeGesturePanAction:)];
    edgeGesture.edges = UIRectEdgeLeft;
    self.panControllPopGesture = edgeGesture;
    [self.view addGestureRecognizer:edgeGesture];
    
    // While scroll to pop use `self.navigationController` will get value nil
    self.zhn_naviController = self.navigationController;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.zhn_navibarAlpha = self.zhn_navibarAlpha;
    [self reloadNavigationDalegate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.presentingViewController) {
        if (self.navigationController.childViewControllers.count == 1) {
            UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
            self.navigationItem.leftBarButtonItem = dismissItem;
            [ZHNThemeManager zhn_extraNightHandle:^{
                dismissItem.tintColor = [ZHNThemeManager zhn_getThemeColor];
            } dayHandle:^{
            }];
        }
    }
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadNavigationDalegate {
    self.panControllPopGesture.enabled = YES;
    self.navigationController.delegate = self;
}

#pragma mark - target action
- (void)edgeGesturePanAction:(UIScreenEdgePanGestureRecognizer *)gesture {
    // Fix bug
    if (self.navigationController.childViewControllers.count == 1) {
        return;
    }
    
    CGFloat percent = 0;
    percent = ([gesture locationInView:self.view].x + K_SCREEN_WIDTH + KMagicTransitionDelta) / K_SCREEN_WIDTH;
    percent = MIN(1.0, MAX(0.0, percent));
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.percentInteractionTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.percentInteractionTransition updateInteractiveTransition:percent];
            if (self.isShowTabbar) {
                [ZHNTabbarAnimateManager translateWithPercent:percent];
            }
            CGFloat alpha = (self.toNavigationBarAlpha - self.fromNavigationBarAlpha) * percent + self.fromNavigationBarAlpha;
            self.zhn_naviController.zhn_navibarAlpha = alpha;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGFloat min = self.presentingViewController ? 0.4 : 0.15;
            if (percent > min) {
                [self p_finishInteractiveTransitionWithStartPercent:percent];
                
//                If use `[self.percentInteractionTransition finishInteractiveTransition]` animate time is to fast.
//                [self.percentInteractionTransition finishInteractiveTransition];
                
                self.zhn_naviController.zhn_navibarAlpha = self.toNavigationBarAlpha;
                if (self.isShowTabbar) {
                    [ZHNTabbarAnimateManager showAnimate];
                }
            }else {
                [self.percentInteractionTransition cancelInteractiveTransition];
                [UIView animateWithDuration:KMagicTransitionAnimateDuration * percent animations:^{
                    self.zhn_naviController.zhn_navibarAlpha = self.fromNavigationBarAlpha;
                }];
                [ZHNTabbarAnimateManager hideAnimate];
                self.percentInteractionTransition = nil;
            }
        }
            break;
        default:
            break;
    }
}

- (void)p_finishInteractiveTransitionWithStartPercent:(CGFloat)startPercent {
    NSInteger repeatCount = 100;
    CGFloat animateTime = 0.2;
    CGFloat repeatTime = animateTime/repeatCount;
    __block CGFloat delta = (1 - startPercent)/(CGFloat)repeatCount;
    __block CGFloat currentPercent = startPercent;
    @weakify(self);
    self.transitionTimer = [ZHNTimer zhn_timerWIthTimeInterval:repeatTime repeats:YES handler:^{
        @strongify(self);
        currentPercent += delta;
        [self.percentInteractionTransition updateInteractiveTransition:currentPercent];
    }];
    [self.transitionTimer fire];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.transitionTimer invalidate];
        self.transitionTimer = nil;
        [self.percentInteractionTransition finishInteractiveTransition];
        self.percentInteractionTransition = nil;
    });
}

#pragma mark - delegate
// PUSH POP
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if([animationController isKindOfClass:[ZHNMagicPopTransition class]]){
        return self.percentInteractionTransition;
    }else{
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (![toVC isKindOfClass:[ZHNMagicTransitionBaseViewController class]] || ![fromVC isKindOfClass:[ZHNMagicTransitionBaseViewController class]]) {
        return nil;
    }
    // cache alpha for animate
    self.fromNavigationBarAlpha = fromVC.zhn_navibarAlpha;
    self.toNavigationBarAlpha = toVC.zhn_navibarAlpha;
    self.isShowTabbar = !toVC.hidesBottomBarWhenPushed;
    // pop or push
    if (operation == UINavigationControllerOperationPop) {
        return [[ZHNMagicPopTransition alloc]init];
    }else if (operation == UINavigationControllerOperationPush) {
        return [[ZHNMagicPushTransition alloc]init];
    }else {
        return nil;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Navibar
    if (animated) {
        [UIView animateWithDuration:0.34 animations:^{
            self.zhn_naviController.zhn_navibarAlpha = viewController.zhn_navibarAlpha;
        }];
    }else {
        self.zhn_naviController.zhn_navibarAlpha = viewController.zhn_navibarAlpha;
    }
    // Tabbar
    if (viewController.hidesBottomBarWhenPushed) {
        [ZHNTabbarAnimateManager hideAnimate];
    }else {
        [ZHNTabbarAnimateManager showAnimate];
    }
}
@end
