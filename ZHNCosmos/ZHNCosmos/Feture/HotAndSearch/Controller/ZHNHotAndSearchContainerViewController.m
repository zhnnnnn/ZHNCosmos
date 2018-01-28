//
//  ZHNHotAndSearchViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotAndSearchContainerViewController.h"
#import "ZHNJellyMagicSwitch.h"
#import "ZHNHotTimelineViewController.h"
#import "ZHNHotTopicViewController.h"
#import "ZHNHotSearchViewController.h"
#import "ZHNScrollingNavigationController.h"
#import "ZHNSearchDot.h"
#import "ZHNSearchHistoryTableView.h"
#import "ZHNUserSearchViewController.h"
#import "ZHNTimelineSearchViewController.h"

static NSString *const KSwitcherNormalTitleColorKey = @"KSwitcherNormalTitleColorKey";
static NSString *const KSwitcherSelectTitleColorKey = @"KSwitcherSelectTitleColorKey";
static NSString *const KSwitcherSlierColor = @"KSwitcherSlierColor";
static NSString *const KSwitcherBoderColor = @"KSwitcherBoderColor";

@interface ZHNHotAndSearchContainerViewController ()<UIScrollViewDelegate,ZHNJellyMagicSwitchDelegate,UIScrollViewDelegate,ZHNSearchHistoryTableViewDelegate,ZHNSearchDotDelegate>
@property (nonatomic,strong) ZHNSearchDot *searchDot;
@property (nonatomic,strong) ZHNSearchHistoryTableView *historyTableView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ZHNJellyMagicSwitch *scrollSwitcher;
@property (nonatomic,strong) ZHNHotTimelineViewController *hotTimelineController;
@property (nonatomic,strong) ZHNHotTopicViewController *hotTopicController;
@property (nonatomic,strong) ZHNHotSearchViewController *hotSearchController;
@property (nonatomic,strong) UIView *currentContentScrollView;
@end

@implementation ZHNHotAndSearchContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initNavibarTitleView];
    [self p_addChildControllers];
    [self p_initScrollNavibar];
    [self p_initHistoryTableView];
    [self p_initSearchDot];
}

#pragma mark - delegate
#pragma mark - switcher delegate
- (void)jellyMagicSwitch:(ZHNJellyMagicSwitch *)magicSwitch selectIndex:(NSInteger)index {
    CGFloat offsetX = index * self.view.width;
    CGPoint offset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];

    // Fit scroll navibar
    [self p_updateCurrentScrollViewWithIndex:index];
    
    // End search enditing
    [self.searchDot zhn_endSearchEditing];
}
#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percent = scrollView.contentOffset.x/(2 * self.view.width);
    self.scrollSwitcher.switchPercent = percent;
    
    if (scrollView.contentOffset.x > K_SCREEN_WIDTH) {
        [self.searchDot zhn_animateHide];
    }else {
        [self.searchDot zhn_animateShow];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.scrollView]) {
        [(ZHNScrollingNavigationController *)self.navigationController showNavbarWithAnimate:YES duration:0.1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.scrollView]) {
        NSInteger index = (NSInteger)scrollView.contentOffset.x / scrollView.width;
        [self p_updateCurrentScrollViewWithIndex:index];
    }
}
#pragma mark - history delegate
- (void)ZHNSearchHoistoryTableViewCilickToSearchWord:(NSString *)keyWord {
    [self p_searchForWord:keyWord];
}

- (void)ZHNSearchHoistoryTableViewScrollToDismiss {
    [self.searchDot zhn_endSearchEditing];
}

- (void)ZHNSearchDotClickKeyboardSearhKeyWithSearchWord:(NSString *)searchWord {
    [self.historyTableView addSearchWord:searchWord];
    [self p_searchForWord:searchWord];
}

#pragma mark - pravite methods
- (void)p_searchForWord:(NSString *)searchWord {
    [self.searchDot zhn_endSearchEditing];
    switch (self.searchDot.searchType) {
        case ZHNSearchTypeUser:
        {
            ZHNUserSearchViewController *userController = [[ZHNUserSearchViewController alloc]init];
            userController.searchWord = searchWord;
            [self.navigationController pushViewController:userController animated:YES];
        }
            break;
        case ZHNSearchTypeTimeline:
        {
            ZHNTimelineSearchViewController *timelineController = [[ZHNTimelineSearchViewController alloc]init];
            timelineController.searchWord = searchWord;
            [self.navigationController pushViewController:timelineController animated:YES];
        }
            break;
    }
}

- (void)p_initNavibarTitleView {
    NSDictionary *colorDict = [self p_switcherColorDict];
    self.scrollSwitcher = [ZHNJellyMagicSwitch zhn_normalJellyMagicSwitchWithTitleArray:@[@"热门搜索",@"热门话题",@"热门微博"] titleFont:[UIFont systemFontOfSize:15] normalTitleColor:colorDict[KSwitcherNormalTitleColorKey] selectTitleColor:colorDict[KSwitcherSelectTitleColorKey] sliderColor:colorDict[KSwitcherSlierColor] backgroundColor:[UIColor clearColor]];
    self.scrollSwitcher.layer.borderColor = [colorDict[KSwitcherBoderColor] CGColor];
    self.scrollSwitcher.layer.borderWidth = 1;
    self.scrollSwitcher.frame = CGRectMake(0, 0, 250, 35);
    self.scrollSwitcher.contentPadding = 3;
    self.scrollSwitcher.delegate = self;
    self.navigationItem.titleView = self.scrollSwitcher;
    
    @weakify(self);
    self.extraThemeColorChangeHandle = ^{
        @strongify(self);
        [self p_reloadSwitcherColor];
    };

    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        [self p_reloadSwitcherColor];
    };
}

- (void)p_addChildControllers {
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(K_SCREEN_WIDTH * 3, 0);
    
    ZHNHotSearchViewController *searchController = [[ZHNHotSearchViewController alloc]init];
    self.hotSearchController = searchController;
    [self addChildViewController:searchController];
    [self.scrollView addSubview:searchController.view];
    searchController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    ZHNHotTopicViewController *topicController = [[ZHNHotTopicViewController alloc]init];
    self.hotTopicController = topicController;
    [self addChildViewController:topicController];
    [self.scrollView addSubview:topicController.view];
    topicController.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    
    ZHNHotTimelineViewController *timelineController = [[ZHNHotTimelineViewController alloc]init];
    self.hotTimelineController = timelineController;
    [self addChildViewController:timelineController];
    [self.scrollView addSubview:timelineController.view];
    timelineController.view.frame = CGRectMake(self.view.width * 2, 0, self.view.width, self.view.height);
    timelineController.tableView.contentInset = UIEdgeInsetsMake(K_Navibar_height, 0, 0, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_updateCurrentScrollViewWithIndex:0];
    });
}

- (void)p_initScrollNavibar {
    self.currentContentScrollView  = self.hotSearchController.tableNode.view;
    [(ZHNScrollingNavigationController *)self.navigationController setIgnoreRefreshPulling:NO];
}

- (void)p_initHistoryTableView {
    [self.view addSubview:self.historyTableView];
    self.historyTableView.frame = CGRectMake(0, K_Navibar_height, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - K_Navibar_height);
}

- (void)p_initSearchDot {
    [self.view addSubview:self.searchDot];
}

- (void)p_updateCurrentScrollViewWithIndex:(NSInteger)index {
    if (index == 0) {
        self.currentContentScrollView = self.hotSearchController.tableNode.view;
    }
    if (index == 1) {
        self.currentContentScrollView = self.hotTopicController.tableNode.view;
    }
    if (index == 2) {
        self.currentContentScrollView = self.hotTimelineController.tableView;
    }
}

- (NSDictionary *)p_switcherColorDict {
    __block UIColor *normalTitleColor;
    __block UIColor *selectTitleColor;
    __block UIColor *sliderColor;
    __block UIColor *boderColor;
    [ZHNThemeManager zhn_extraNightHandle:^{
        normalTitleColor = [ZHNThemeManager zhn_getThemeColor];
        selectTitleColor = [UIColor whiteColor];
        sliderColor = [ZHNThemeManager zhn_getThemeColor];
        boderColor = [ZHNThemeManager zhn_getThemeColor];
    } dayHandle:^{
        normalTitleColor = [UIColor whiteColor];
        selectTitleColor = [ZHNThemeManager zhn_getThemeColor];
        sliderColor = [UIColor whiteColor];
        boderColor = [UIColor whiteColor];
    }];
    return @{KSwitcherBoderColor:boderColor,
             KSwitcherSlierColor:sliderColor,
             KSwitcherSelectTitleColorKey:selectTitleColor,
             KSwitcherNormalTitleColorKey:normalTitleColor};
}

- (void)p_reloadSwitcherColor {
    NSDictionary *colorDict = [self p_switcherColorDict];
    [self.scrollSwitcher reloadSwitcherAppearanceWithBackgroundColor:[UIColor clearColor] sliderColor:colorDict[KSwitcherSlierColor] normalTitleColor:colorDict[KSwitcherNormalTitleColorKey] selectTitleColor:colorDict[KSwitcherSelectTitleColorKey]];
    self.scrollSwitcher.layer.borderColor = [colorDict[KSwitcherBoderColor] CGColor];
}
#pragma mark - setters
- (void)setCurrentContentScrollView:(UIView *)currentContentScrollView {
    _currentContentScrollView = currentContentScrollView;
     [(ZHNScrollingNavigationController *)self.navigationController  followScrollViewWithScrollableView:currentContentScrollView naviBarScrollingType:ZHNNavibarScrollingTypeScrollingAll delay:30 scrollSpeedFactor:2 followers:nil];
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (ZHNSearchDot *)searchDot {
    if (_searchDot == nil) {
        _searchDot = [ZHNSearchDot zhn_searchDotWithRelevanceHistoryTableView:self.historyTableView];
        _searchDot.delegate = self;
    }
    return _searchDot;
}

- (ZHNSearchHistoryTableView *)historyTableView {
    if (_historyTableView == nil) {
        _historyTableView = [[ZHNSearchHistoryTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _historyTableView.historyDelegate = self;
    }
    return _historyTableView;
}
@end
