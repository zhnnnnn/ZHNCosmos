//
//  ZHNHomePageViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNHomePageViewController.h"
#import "ZHNUserAllTimelineViewController.h"
#import "ZHNUserMoreTimelineViewController.h"
#import "ZHNHomePageHeaderView.h"
#import "ZHNHomePageNavibar.h"
#import "ZHNHomePageHeadPlaceHolder.h"
#import "UIView+ZHNSnapchot.h"

#define KPulldifferential 1.1
#define KheaderHeight (self.headerView.headerFullHeight)
#define KConentInset (KheaderHeight - K_statusBar_height)
#define KSwitcherPadding (self.headerView.switcherPadding)
#define KSiwtcherHeight (self.headerView.switcherHeight)
#define KSwitcherToolHeight (KSwitcherPadding * 2 + KSiwtcherHeight)
#define KTableContentHeight ((K_SCREEN_HEIGHT - KSwitcherToolHeight - K_Navibar_height) * KPulldifferential)
#define KScrollMaxY (KheaderHeight - KSwitcherToolHeight - K_Navibar_height)
#define KFancyBackImageHeight (KheaderHeight - 40)
#define KHeaderCurveHeight (self.headerView.curveHeight)

@interface ZHNHomePageViewController ()<ZHNJellyMagicSwitchDelegate,UIScrollViewDelegate,ZHNHomepageUserTimelineScrollDelegate,UINavigationControllerDelegate,ZHNHomePageNavibarDelegate>
@property (nonatomic,strong) ZHNHomePageNavibar *naviBar;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) ZHNHomePageHeaderView *headerView;
@property (nonatomic,strong) ZHNHomePageHeadPlaceHolder *headerPlaceholder;
@property (nonatomic,strong) ZHNUserAllTimelineViewController *allController;
@property (nonatomic,strong) ZHNUserMoreTimelineViewController *moreController;
@property (nonatomic,assign) CGRect scrollOriginalFrame;
@property (nonatomic,assign) CGFloat allOffsetY;
@property (nonatomic,assign) CGFloat moreOffsetY;
@end

@implementation ZHNHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 0;
    [self.contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.panControllPopGesture];

    // Header Data
    @weakify(self);
    [ZHNCosmosUserManager zhn_userAddSuccessWithResponseObject:self action:^{
        @strongify(self);
        self.headerView.type = ZHNHomePageTypeMine;
        self.naviBar.homepageType = ZHNHomePageTypeMine;
        ZHNTimelineUser *user = [ZHNUserMetaDataModel displayUserMetaData].userDetail;
        [self p_initTimelineStatusWithUserModel:user];
    }];
    
    // TableView data
    if (self.homepageUser) {// have user model
        self.headerView.type = ZHNHomePageTypeOther;
        self.naviBar.homepageType = ZHNHomePageTypeOther;
        [self p_initTimelineStatusWithUserModel:self.homepageUser];
    }else if (self.userScreenName) {// Only username
        self.headerView.type = ZHNHomePageTypeOther;
        self.naviBar.homepageType = ZHNHomePageTypeOther;
        self.headerView.name = self.userScreenName;
        [self p_setupUI];
        [ZHNCosmosUserManager zhn_getUserDetailStatusWithUid:0 screenName:self.userScreenName success:^(id result, NSURLSessionDataTask *task) {
            ZHNTimelineUser *user = [ZHNTimelineUser yy_modelWithDictionary:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self p_initTimelineStatusWithUserModel:user];
            });
        } failure:^(NSError *error, NSURLSessionDataTask *task) {
        }];
    }else {// mine
        self.headerView.type = ZHNHomePageTypeMine;
        self.naviBar.homepageType = ZHNHomePageTypeMine;
        ZHNTimelineUser *user = [ZHNUserMetaDataModel displayUserMetaData].userDetail;
        [self p_initTimelineStatusWithUserModel:user];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITableView *tableView = self.contentScrollView.contentOffset.x == 0 ? self.allController.tableView :  self.moreController.tableView;
    [self homepageTableViewDidScroll:tableView];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentScrollView]) {
        CGFloat percent = scrollView.contentOffset.x / K_SCREEN_WIDTH;
        self.headerView.timelineTypeSwitcher.switchPercent = percent;

        CGFloat currentOffsetY = (self.moreOffsetY - self.allOffsetY) * percent + self.allOffsetY;
        [self p_transitionSubViewWithOffsetY:currentOffsetY];
    }
}

- (void)homepageTableViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.allController.tableView]) {
        CGFloat offsety = scrollView.contentOffset.y;
        self.allOffsetY = [self p_transitionSubViewWithOffsetY:offsety];
    }
    
    if ([scrollView isEqual:self.moreController.tableView]) {
        CGFloat offsety = scrollView.contentOffset.y;
        self.moreOffsetY = [self p_transitionSubViewWithOffsetY:offsety];
    }
}

- (void)jellyMagicSwitch:(ZHNJellyMagicSwitch *)magicSwitch selectIndex:(NSInteger)index {
    CGFloat offsetx = index * K_SCREEN_WIDTH;
    [self.contentScrollView setContentOffset:CGPointMake(offsetx, self.contentScrollView.contentOffset.y) animated:YES];
}

- (void)ZHNHomepageNavibarClickPopController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - pravite methods
- (CGFloat)p_transitionSubViewWithOffsetY:(CGFloat)offsety {
    // Navibar avator trans percent
    if (self.headerView.avatorStartTransHeight > 0){
        CGFloat avatorPercent = ((offsety + K_Navibar_height) - self.headerView.avatorStartTransHeight) / (self.headerView.avatorEndTransHeight - self.headerView.avatorStartTransHeight);
        avatorPercent = avatorPercent > 1 ? 1 : avatorPercent;
        avatorPercent = avatorPercent < 0 ? 0 : avatorPercent;
        [self.naviBar zhn_avatarMagicTransWithPercent:avatorPercent];
    }

    // Navibar name trans percent
    if (self.headerView.nameStartTransHeight > 0) {
        CGFloat namePercent = ((offsety + K_Navibar_height) - self.headerView.nameStartTransHeight) / (self.headerView.nameEndTransHeight - self.headerView.nameStartTransHeight);
        namePercent = namePercent > 1 ? 1 : namePercent;
        namePercent = namePercent < 0 ? 0 : namePercent;
        [self.naviBar zhn_nameLabelMagicTransWithPercent:namePercent];
    }
    
    // Blur
    if (offsety > KScrollMaxY) {
        offsety = KScrollMaxY;
    }
    CGFloat blurPercent = offsety / ((KheaderHeight - KHeaderCurveHeight) - K_Navibar_height);
    blurPercent = blurPercent > 1 ? 1 : blurPercent;
    blurPercent = blurPercent < 0 ? 0 : blurPercent;
    
    // Position
    self.contentScrollView.y = -offsety * KPulldifferential;
    self.headerView.y = -offsety;
    
    // Extra change
    [self.headerPlaceholder zhn_fantasyChangeWithOffsetY:offsety
                                   imageOriginalHeight:KFancyBackImageHeight
                                      imageBlurPercent:blurPercent];
    [self.headerView zhn_fantasyChangeWithPercent:blurPercent];
    return offsety;
}

- (void)p_setupUI {
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
    self.view.clipsToBounds = YES;
    // Header placeholder
    [self.view addSubview:self.headerPlaceholder];
    self.headerPlaceholder.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, KFancyBackImageHeight);
    // Content scrollView
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT + KheaderHeight);
    self.contentScrollView.contentSize = CGSizeMake(K_SCREEN_WIDTH * 2, 0);
    self.scrollOriginalFrame = self.contentScrollView.frame;
    // All timeline contoller
    self.allController.view.frame = CGRectMake(0, KConentInset, K_SCREEN_WIDTH, KTableContentHeight);
    [self addChildViewController:self.allController];
    self.allController.delegate = self;
    [self.contentScrollView addSubview:self.allController.view];
    // More timeline controller
    self.moreController.view.frame = CGRectMake(K_SCREEN_WIDTH, KConentInset, self.allController.view.width, self.allController.view.height);
    [self addChildViewController:self.moreController];
    self.moreController.delegate = self;
    [self.contentScrollView addSubview:self.moreController.view];
    // Header view
    [self.view addSubview:self.headerView];
    self.headerView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, KheaderHeight);
    // Fake navigation bar
    [self.view addSubview:self.naviBar];
    self.naviBar.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_Navibar_height);
    [self.naviBar zhn_observePlaceholder:self.headerPlaceholder];
}

- (void)p_initTimelineStatusWithUserModel:(ZHNTimelineUser *)user {
    self.allController.homePageHostUser = user;
    self.moreController.homePageHostUser = user;
    ZHNUserMetaDataModel *displayUser = [ZHNUserMetaDataModel displayUserMetaData];
    if (displayUser.uid == user.userID) {// Mine
        self.allController.uid = user.userID;
        self.moreController.uid = user.userID;
        self.headerView.type = ZHNHomePageTypeMine;
        [self p_initializeViewStatuesWithUserDetailModel:user];
        [self.allController initializeLayoutsWithCachesIfHave];
        [self.moreController initializeLayoutsWithCachesIfHave];
        [self p_setupUI];
    }else {// Other
        [self p_initializeViewStatuesWithUserDetailModel:user];
        [self p_setupUI];
        self.allController.uid = user.userID;
        self.moreController.uid = user.userID;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.allController.tableView.mj_header beginRefreshing];
            [self.moreController.tableView.mj_header beginRefreshing];
        });
    }
}

- (void)p_initializeViewStatuesWithUserDetailModel:(ZHNTimelineUser *)userDetail {
    self.headerView.userDetail = userDetail;
    [self.headerPlaceholder.imageView yy_setImageWithURL:[NSURL URLWithString:userDetail.coverImagePhone] placeholder:[UIImage imageNamed:@"LEWIS_MARNELL"]];
    self.naviBar.name = userDetail.name;
    self.naviBar.avatarURLStr = userDetail.profileImageUrl;
}

#pragma mark - getters
- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.alwaysBounceHorizontal = YES;
    }
    return _contentScrollView;
}

- (ZHNHomePageHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[ZHNHomePageHeaderView alloc]init];
        _headerView.timelineTypeSwitcher.delegate = self;
    }
    return _headerView;
}

- (ZHNHomePageHeadPlaceHolder *)headerPlaceholder {
    if (_headerPlaceholder == nil) {
        _headerPlaceholder = [[ZHNHomePageHeadPlaceHolder alloc]init];
        _headerPlaceholder.imageView.image = [UIImage imageNamed:@"LEWIS_MARNELL"];
    }
    return _headerPlaceholder;
}

- (ZHNHomePageNavibar *)naviBar {
    if (_naviBar == nil) {
        _naviBar = [ZHNHomePageNavibar loadView];
        _naviBar.delegate = self;
    }
    return _naviBar;
}

- (ZHNUserAllTimelineViewController *)allController {
    if (_allController == nil) {
        _allController = [[ZHNUserAllTimelineViewController alloc]init];
    }
    return _allController;
}

- (ZHNUserMoreTimelineViewController *)moreController {
    if (_moreController == nil) {
        _moreController = [[ZHNUserMoreTimelineViewController alloc]init];
    }
    return _moreController;
}
@end
