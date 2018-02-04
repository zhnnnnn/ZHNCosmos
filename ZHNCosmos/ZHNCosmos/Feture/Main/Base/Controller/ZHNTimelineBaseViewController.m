//
//  SecondViewController.m
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/19.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineBaseViewController.h"
#import "YYModel.h"
#import "ZHNTimelineModel.h"
#import "ZHNStatusHelper.h"
#import "ZHNNetworkManager.h"
#import "RACSignal+statusMapping.h"
#import "ZHNStatusCell.h"
#import "ZHNNightVersionChangeTransitionManager.h"
#import "ZHNPhotoBrowser.h"
#import "ZHNPhotoItem.h"
#import "NSString+imageQuality.h"
#import "ZHNVideoPlayerManager.h"
#import <SafariServices/SafariServices.h>
#import "ZHNSafariViewController.h"
#import "UITableView+ZHNVerticalScrollIndicator.h"
#import "ZHNRichTextPicURLManager.h"
#import "ZHNScrollingNavigationController.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"
#import "ZHNRefreshHeader.h"
#import "ZHNRefreshFooter.h"
#import "UIViewController+showExpandNavibar.h"
#import "ZHNTimelineStatusConfigReloadObserver.h"
#import "ZHNSearchedTimelineViewController.h"
#import "ZHNHomePageViewController.h"
#import "ZHNTimelineDetailContainViewController.h"
#import "UITableView+ZHNStatusChangePreload.h"
#import "ZHNOrdinaryCacheManager.h"
#import "ZHNAlert.h"
#import "ZHNTabbarItemNotificationManager.h"

@interface ZHNTimelineBaseViewController ()

@end

@implementation ZHNTimelineBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 1;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // Initialize refresh header footer scroll indicator
    [self initializeRefreshHeader];
    [self initializeRefreshFooter];
    [self initializeScrollIndicator];
    
    // Reload statues
    @weakify(self);
    [[[RACObserve(self, self.layoutArray) filter:^BOOL(NSArray *array) {
        return (array.count > 0);
    }]
    take:1]
    subscribeNext:^(id x) {
        @strongify(self);
        [self p_observeToReloadRichTextConfig];
    }];
    
    // Add user success. Reload data
    [ZHNCosmosUserManager zhn_userAddSuccessWithResponseObject:self action:^{
        @strongify(self);
        self.layoutArray = nil;
        [[self loadDataWithType:ZHNfetchDataTypeLoadCache] subscribeNext:^(id x) {
        }];
    }];
    
    // Click tabbar item to reload data
    [ZHNTabbarItemNotificationManager tabbarObserveToReloadStatuesWithController:self handle:^{
        @strongify(self);
        [(ZHNScrollingNavigationController *)self.navigationController showNavbarWithAnimate:YES duration:0.1];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(ZHNScrollingNavigationController *)self.navigationController  followScrollViewWithScrollableView:self.tableView naviBarScrollingType:ZHNNavibarScrollingTypeScrollingLikeSafari delay:5 scrollSpeedFactor:2 followers:nil];
    [(ZHNScrollingNavigationController *)self.navigationController setIgnoreRefreshPulling:YES];
}

#pragma mark - public methods
- (void)initializeRefreshHeader {
    @weakify(self);
    ZHNRefreshHeader *header = [ZHNRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self loadDataWithType:ZHNfetchDataTypeLoadLatest]
         subscribeCompleted:^{
         }];
    }];
    self.tableView.mj_header = header;
}

- (void)initializeRefreshFooter {
    @weakify(self);
    ZHNRefreshFooter *footer = [ZHNRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self loadDataWithType:ZHNfetchDataTypeLoadMore]
         subscribeCompleted:^{
         }];
    }];
    self.tableView.mj_footer = footer;
}

- (void)initializeScrollIndicator {
    @weakify(self);
    self.extraThemeColorChangeHandle = ^{
        @strongify(self);
        [self.tableView zhn_showCustomScrollIndicatorWithoriginalDelegate:self indicatorColor:[ZHNThemeManager zhn_getThemeColor]];
    };
}

- (NSString *)requestURL {
    return nil;
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    return nil;
}

- (Class)cacheModelCalss {
    return nil;
}

- (NSInteger)everyRequestMaxCount {
    return 0;
}

- (ZHNResponseType)requestResponseType {
    return ZHNResponseTypeJSON;
}

- (NSArray *)requestResultArrayMapKeyOrderArray {
    return @[@"statuses"];
}

- (NSArray *)requestStatuesMapkeyOrderArray {
    return nil;
}

- (void)fetchedDataProcessing:(NSArray *)fetchedLatoutArray fetchDataType:(ZHNfetchDataType)fetchType {
    switch (fetchType) {
        case ZHNfetchDataTypeLoadCache:
        case ZHNfetchDataTypeLoadLatest:
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:fetchedLatoutArray];
            [tempArray addObjectsFromArray:self.layoutArray];
            self.layoutArray = [tempArray copy];
        }
            break;
        case ZHNfetchDataTypeLoadMore:
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.layoutArray];
            [tempArray addObjectsFromArray:fetchedLatoutArray];
            self.layoutArray = [tempArray copy];
        }
            break;
    }
}

- (unsigned long long)currentMaxIDForFetchDataType:(ZHNfetchDataType)fetchDataType {
    unsigned long long maxID = 0;
    switch (fetchDataType) {
        case ZHNfetchDataTypeLoadMore:
        {
            maxID = [ZHNOrdinaryCacheManager zhn_maxIDForCachedClass:[self cacheModelCalss]];
        }
            break;
        default:
            break;
    }
    return maxID;
}

- (unsigned long long)currentSinceIDForFetchDataType:(ZHNfetchDataType)fetchDataType {
    unsigned long long sinceID = 0;
    switch (fetchDataType) {
        case ZHNfetchDataTypeLoadLatest:
        {
            ZHNTimelineLayoutModel *minLayout = [self.layoutArray firstObject];
            sinceID = minLayout.statusID;
        }
            break;
        default:
            break;
    }
    return sinceID;
}

- (RACSignal *)loadDataWithType:(ZHNfetchDataType)fetchDataType {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
        Class cacheModelClass = [self cacheModelCalss];
        NSString *requestURL = [self requestURL];
        NSArray *mapKeyArray = [self requestResultArrayMapKeyOrderArray];
        NSArray *statusMapKeyArray = [self requestStatuesMapkeyOrderArray];
        ZHNResponseType responseType = [self requestResponseType];
        NSDictionary *requestParams = [self requestParamsWithFetchDataType:fetchDataType];
        [[[[[ZHNNETWROK getTimelineStatusWithType:fetchDataType cacheModelClass:cacheModelClass requestUrl:requestURL requestParams:requestParams requsetResponse:responseType resultArrayMapKeyArray:mapKeyArray requestStatusMapKeyArray:statusMapKeyArray]
        replayLazily]
        subscribeOn:scheduler]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(ZHNFetchTimelineDataMetaData *metaData) {
             @strongify(self)
             NSArray *layouts = metaData.layouts;
             if (layouts.count == 0) {
                 [self.tableView.mj_header endRefreshing];
                 [self.tableView.mj_footer endRefreshing];
                 return;
             }
            
             if (layouts.count >= [self everyRequestMaxCount]) {
                self.tableView.mj_footer.hidden = NO;
             }
            
             // Datasource update
             [self fetchedDataProcessing:layouts fetchDataType:fetchDataType];
             
             // Show hud
             NSInteger insertCount = layouts.count;
             if (insertCount > 0 && metaData.dataType == ZHNTimelineDataTypeNet && cacheModelClass == [ZHNHomeTimelineLayoutCacheModel class]) {
                 [ZHNHudManager showSuccess:[NSString stringWithFormat:@"更新%lu条新微博",insertCount]];
             }
             
            // Relad cell
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [subscriber sendCompleted];
         } error:^(NSError *error) {
             @strongify(self);
             [ZHNHudManager showError:@"数据加载失败~"];
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
             [subscriber sendError:error];
         }];
        return nil;
    }];
}

- (void)manualObserveReloadTimelineRichText {
    @weakify(self);
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        [self manualReloadTimelineRichText];
    };
    self.extraThemeColorChangeHandle = ^{
        @strongify(self);
        [self manualReloadTimelineRichText];
    };
    [ZHNThemeManager zhn_observeToReloadRichTextConfigWithObserver:self handle:^{
        @strongify(self);
        [self manualReloadTimelineRichText];
    }];
}


- (void)manualReloadTimelineRichText {
    @weakify(self);
    [self.tableView zhn_preloadWithLoadPreferenceCount:10 controller:self dataArrayKey:NSStringFromSelector(@selector(layoutArray))];

    [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:self.layoutArray];
        return nil;
    }]
    formatterRichTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]]
    layout]
    subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]]
    deliverOnMainThread]
    subscribeNext:^(NSArray *layouts) {
        @strongify(self);
         self.layoutArray = layouts;
     }];
}

#pragma mark - delegate
#pragma mark - tableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNTimelineLayoutModel *layout = self.layoutArray[indexPath.row];
    return layout.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNStatusCell *cell = [ZHNStatusCell zhn_statusCellWithTableView:tableView];
    cell.layout = self.layoutArray[indexPath.row];
    return cell;
}

#pragma mark - DZNEmptyDataSet datasource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blank_data_placeholder"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - event
- (void)zhn_routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self zhn_responderRouterWithName:eventName userInfo:userInfo];
}

- (NSDictionary *)zhn_currentEventStrategy {
    return @{KCellTapPicAction:[self zhn_createInvocationWithSelector:@selector(cellTapPicWithInfo:)],
             KCellTapVideoAction:[self zhn_createInvocationWithSelector:@selector(cellTapVideoWithInfo:)],
             KCellRichTextTapAtAction:[self zhn_createInvocationWithSelector:@selector(cellRichTextTapAtWithInfo:)],
             KCellRichTextTapPicURLAction:[self zhn_createInvocationWithSelector:@selector(cellRichTextTapPicWithInfo:)],
             KCellRichTextTapTopicAction:[self zhn_createInvocationWithSelector:@selector(cellRichTextTapTopicWithInfo:)],
             KCellRichTextTapNormalURLAction:[self zhn_createInvocationWithSelector:@selector(cellTapNormalURLWithInfo:)],
             KCellTapAvatarOrUsernameAction:[self zhn_createInvocationWithSelector:@selector(cellTapAvatarOrUsernameWithInfo:)],
             KCellToSeeStatusDetailAction:[self zhn_createInvocationWithSelector:@selector(cellToSeeStatusDetailWithInfo:)],
             KCellTapToSearchWordAction:[self zhn_createInvocationWithSelector:@selector(cellTapToSearch:)]
             };
}

// events
- (void)cellTapToSearch:(NSDictionary *)info {
    NSString *searchWord = info[KCellTapToSearchWordKey];
    ZHNSearchedTimelineViewController *seachedController = [[ZHNSearchedTimelineViewController alloc]init];
    seachedController.searchKeyword = searchWord;
    [self.navigationController pushViewController:seachedController animated:YES];
}

- (void)cellTapPicWithInfo:(NSDictionary *)info {
    NSInteger index = [[info objectForKey:KCellTapPicIndexKey] integerValue];
    NSArray *pics = [info objectForKey:KCellTapPicPhotosKey];
    NSArray *picMetedatas = [info objectForKey:KCellTapPicMeteDatas];
    NSMutableArray *photoItems = [NSMutableArray array];
    [picMetedatas enumerateObjectsUsingBlock:^(ZHNTimelinePicMetaData *meteData, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = pics[idx];
        ZHNPhotoItem *item = [ZHNPhotoItem zhn_photoItemWithImageView:imageView placeholder:[UIImage imageNamed:@"placeholder_image"] imageUrlStr:meteData.picUrl livePhotoMovUrlStr:meteData.livePhotoMovUrl];
        [photoItems addObject:item];
    }];
    ZHNPhotoBrowser *browser = [ZHNPhotoBrowser zhn_photoBrowserWithPhotoItems:photoItems currentIndex:index];
    [browser showFromViewController:self browserWillShowHandle:^{
        [self zhn_showExpandNavibarIfNeed];
    } browserWillDismissHandle:nil];
}

- (void)cellRichTextTapPicWithInfo:(NSDictionary *)info {
    NSString *picURL = info[KCellRichTextTapPicURLKey];
    UIImageView *fakeforImageView = info[KCellRichTextTapPicURLForAnimateViewKey];
    ZHNPhotoItem *item = [ZHNPhotoItem zhn_photoItemWithImageView:fakeforImageView placeholder:[UIImage imageNamed:@"placeholder_image"] imageUrlStr:picURL livePhotoMovUrlStr:nil];
    ZHNPhotoBrowser *browser = [ZHNPhotoBrowser zhn_photoBrowserWithPhotoItems:@[item] currentIndex:0];
    [browser showFromViewController:self browserWillShowHandle:^{
        [self zhn_showExpandNavibarIfNeed];
    } browserWillDismissHandle:^{
        fakeforImageView.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [fakeforImageView removeFromSuperview];
        });
    }];
}

- (void)cellTapVideoWithInfo:(NSDictionary *)info {
    if ([ZHNVideoPlayerManager shareManager].isPlayerShowing) {
        [ZHNAlert zhn_showAlertWithMessage:@"是否替换正在播放的视频" CancleTitle:@"取消" cancleAction:nil confirmTitle:@"确定" confirmAction:^{
            ZHNTimelineURL *videoURLMetaData = [info objectForKey:KCellTapVideoURLMetaDataKey];
            UIView *view = [info objectForKey:KCellTapVideoVideoViewKey];
            BOOL remove = [[info objectForKey:KCellTapVideoNeedRemoveFromViewKey] boolValue];
            [[ZHNVideoPlayerManager shareManager] zhn_playerForURLMetaData:videoURLMetaData fromView:view showAnimateStart:^{
                if (remove) {
                    [view removeFromSuperview];
                }
            } hideAnimateEnd:nil];
        }];
    }else {
        ZHNTimelineURL *videoURLMetaData = [info objectForKey:KCellTapVideoURLMetaDataKey];
        UIView *view = [info objectForKey:KCellTapVideoVideoViewKey];
        BOOL remove = [[info objectForKey:KCellTapVideoNeedRemoveFromViewKey] boolValue];
        [[ZHNVideoPlayerManager shareManager] zhn_playerForURLMetaData:videoURLMetaData fromView:view showAnimateStart:^{
            if (remove) {
                [view removeFromSuperview];
            }
        } hideAnimateEnd:nil];
    }
}

- (void)cellTapNormalURLWithInfo:(NSDictionary *)info {
    ZHNTimelineURL *urlMetaData = [info objectForKey:KCellRichTextTapNormalURLMetaDataKey];
    if (urlMetaData.urlLong) {
        ZHNSafariViewController *safariController = [[ZHNSafariViewController alloc]initWithURL:[NSURL URLWithString:urlMetaData.urlLong]];
        [self presentViewController:safariController animated:YES completion:nil];
    }
}

- (void)cellRichTextTapTopicWithInfo:(NSDictionary *)info {
    NSString *topicKeyword = [info objectForKey:KCellRichTextTapTopicKeywordKey];
    ZHNSearchedTimelineViewController *seachedController = [[ZHNSearchedTimelineViewController alloc]init];
    seachedController.searchKeyword = topicKeyword;
    [self.navigationController pushViewController:seachedController animated:YES];
}

- (void)cellRichTextTapAtWithInfo:(NSDictionary *)info {
    NSString *name = [info objectForKey:KCellRichTextTapAtKeywordKey];
    if ([self.homePageHostUser.name isEqualToString:name]) {
        [self p_shakeToNotice];
        return;
    }
    ZHNHomePageViewController *homePageController = [[ZHNHomePageViewController alloc]init];
    homePageController.userScreenName = name;
    [self.navigationController pushViewController:homePageController animated:YES];
}

- (void)cellTapAvatarOrUsernameWithInfo:(NSDictionary *)info {
    ZHNTimelineUser *user = [info objectForKey:KCellTapAvatarOrUsernameUserModelKey];
    if (user.userID == self.homePageHostUser.userID) {
        [self p_shakeToNotice];
        return;
    }
    ZHNHomePageViewController *homePageController = [[ZHNHomePageViewController alloc]init];
    homePageController.homepageUser = user;
    [self.navigationController pushViewController:homePageController animated:YES];
}

- (void)cellToSeeStatusDetailWithInfo:(NSDictionary *)info {
    ZHNTimelineStatus *status = [info objectForKey:KCellToSeeStatusDetailStatusKey];
    ZHNDefaultShowType defaultType = [[info objectForKey:KCellToSeeStatusDetailDefaultTypeKey] integerValue];
    ZHNTimelineDetailContainViewController *detailController = [[ZHNTimelineDetailContainViewController alloc]init];
    detailController.status = status;
    detailController.defaultType = defaultType;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - pravite methods
- (void)p_observeToReloadRichTextConfig {
    @weakify(self);
    [[[ZHNTimelineStatusConfigReloadObserver shareInstance] 
      zhn_observeReloadCachedTimelineLayoutsWithCacheModelClass:[self cacheModelCalss]
      controller:self dataArrayKey:NSStringFromSelector(@selector(layoutArray))] subscribeNext:^(NSString *key) {
        @strongify(self);
        [self.tableView zhn_preloadWithLoadPreferenceCount:5 controller:self dataArrayKey:NSStringFromSelector(@selector(layoutArray))];
    }];
}

- (void)p_shakeToNotice {
    UIView *view =  [UIApplication sharedApplication].keyWindow.rootViewController.view;
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-3];
    shake.toValue = [NSNumber numberWithFloat:3];
    shake.duration = 0.05;
    shake.autoreverses = YES;
    shake.repeatCount = 3;
    [view.layer addAnimation:shake forKey:@"shakeAnimation"];
}

#pragma mark - getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.panGestureRecognizer.cancelsTouchesInView = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
        _tableView.estimatedRowHeight = 0;// Warning.... iOS11 estimatedRowHeight default is 'UITableViewAutomaticDimension' if u call `reloadRowsAtIndexPaths` method, tablview offset will change unordered. Set it to `0` will slove this.
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}
@end

