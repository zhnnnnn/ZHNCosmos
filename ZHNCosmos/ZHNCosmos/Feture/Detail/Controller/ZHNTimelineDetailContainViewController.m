//
//  ZHNTimelineDetailViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineDetailContainViewController.h"
#import "ZHNTimelineDetailToolView.h"
#import "ZHNTimelineLikeController.h"
#import "ZHNCommentsViewController.h"
#import "ZHNTransmitViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNDetailBasicModel.h"
static CGFloat const KToolHeight = 40;
@interface ZHNTimelineDetailContainViewController ()<ZHNJellyMagicSwitchDelegate,UIScrollViewDelegate,ZHNTimelineDetailToolViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ZHNTimelineDetailToolView *toolView;
@property (nonatomic,strong) ZHNTimelineLikeController *likeController;
@property (nonatomic,strong) ZHNTransmitViewController *transmitController;
@property (nonatomic,strong) ZHNCommentsViewController *commentsController;
@property (nonatomic,strong) ZHNDetailBasicModel *detailBasic;
@end

@implementation ZHNTimelineDetailContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Normal status
    self.zhn_navibarAlpha = 0;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.panControllPopGesture];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(NormalViewBG);
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, K_statusBar_height, self.view.width, self.view.height - K_statusBar_height);
   
    // Transimit controller
    ZHNTransmitViewController *transmitController = [[ZHNTransmitViewController alloc]init];
    [self addChildViewController:transmitController];
    transmitController.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:transmitController.view];
    self.transmitController = transmitController;
    
    // Like adn detail controller
    ZHNTimelineLikeController *likeController = [[ZHNTimelineLikeController alloc]init];
    likeController.layout = [ZHNTimelineLayoutModel zhn_layoutWithStatusModel:self.status layoutType:ZHNTimelineLayoutTypeDetail];;
    [self addChildViewController:likeController];
    likeController.view.frame = CGRectMake(K_SCREEN_WIDTH, 0, self.scrollView.width, self.scrollView.height);
    [self.scrollView addSubview:likeController.view];
    self.likeController = likeController;
   
    // Comments controller
    ZHNCommentsViewController *commentsController = [[ZHNCommentsViewController alloc]init];
    [self addChildViewController:commentsController];
    commentsController.view.frame = CGRectMake(K_SCREEN_WIDTH * 2, 0, self.scrollView.width, self.scrollView.height);
    [self.scrollView addSubview:commentsController.view];
    self.commentsController = commentsController;
   
    // ToolView
    [self.view addSubview:self.toolView];
    CGFloat extraH = IS_IPHONEX ? K_tabbar_safeArea_height : 0;
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(extraH + KToolHeight);
    }];
    
    // TableView contentinset init
    likeController.tableView.contentInset = UIEdgeInsetsMake(0, 0, extraH + KToolHeight, 0);
    transmitController.tableNode.contentInset = UIEdgeInsetsMake(0, 0, extraH + KToolHeight + K_statusBar_height, 0);
    commentsController.tableNode.contentInset = transmitController.tableNode.contentInset;
    
    // StatusID init
    transmitController.statuID = self.status.statusID;
    commentsController.statuID = self.status.statusID;
    
    // Default offset
    CGFloat defaultOffsetx = (self.defaultType * K_SCREEN_WIDTH);
    CGFloat defaultOffsety = self.scrollView.contentOffset.y;
    self.scrollView.contentOffset = CGPointMake(defaultOffsetx, defaultOffsety);
    self.toolView.switcher.currentSelectIndex = self.defaultType;
    
    // First show controller init Data
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self p_showingControllerForType:self.defaultType] zhn_detailBeginInitData];
    });
    
    // Load detail basic datas
    [self p_loadBasicDatas];
}

#pragma mark - delegate
- (void)jellyMagicSwitch:(ZHNJellyMagicSwitch *)magicSwitch selectIndex:(NSInteger)index {
    CGFloat offsetX = index * K_SCREEN_WIDTH;
    [self.scrollView setContentOffset:CGPointMake(offsetX, self.scrollView.contentOffset.y) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self p_showingControllerForType:index] zhn_detailBeginInitData];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollPerent = scrollView.contentOffset.x/(2 * K_SCREEN_WIDTH);
    self.toolView.switcher.switchPercent = scrollPerent;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / K_SCREEN_WIDTH);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self p_showingControllerForType:index] zhn_detailBeginInitData];
    });
}

- (void)toolViewClickToPopController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - pravite methods
- (UIViewController <ZHNDetailInitDataProtocol>*)p_showingControllerForType:(ZHNDefaultShowType)showType {
    UIViewController <ZHNDetailInitDataProtocol> *firstShowController;
    switch (showType) {
        case ZHNDefaultShowTypeTransmit:
            firstShowController = self.transmitController;
            break;
        case ZHNDefaultShowTypeDetail:
            firstShowController = self.likeController;
            break;
        case ZHNDefaultShowTypeComments:
            firstShowController = self.commentsController;
            break;
    }
    return firstShowController;
}

- (void)p_loadBasicDatas {
    ZHNUserMetaDataModel *displayData = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:displayData.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@(self.status.statusID) forKey:@"ids"];
    @weakify(self);
    [ZHNNETWROK get:@"https://api.weibo.com/2/statuses/count.json" params:params responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
        @strongify(self);
        self.detailBasic = [[NSArray yy_modelArrayWithClass:[ZHNDetailBasicModel class] json:result] firstObject];
        self.likeController.detailBasic = self.detailBasic;
        self.toolView.detailBasic = self.detailBasic;
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
    }];
}

#pragma mark - getters
- (ZHNTimelineDetailToolView *)toolView {
    if (_toolView == nil) {
        _toolView = [[ZHNTimelineDetailToolView alloc]init];
        _toolView.switcher.delegate = self;
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(K_SCREEN_WIDTH * 3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
@end
