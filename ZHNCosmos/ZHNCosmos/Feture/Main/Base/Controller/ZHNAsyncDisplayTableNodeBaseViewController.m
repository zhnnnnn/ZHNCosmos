//
//  ZHNTimelineCommentsViewController.m
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNAsyncDisplayTableNodeBaseViewController.h"
#import "ZHNTimelineCommentsCellNode.h"
#import "ZHNTimelineTransmitCellNode.h"
#import "ZHNGooeyMenu.h"
#import "ZHNRefreshHeader.h"
#import "ZHNRefreshFooter.h"
#import "RACSignal+statusMapping.h"
#import "UIView+ZHNSnapchot.h"
#import "NSObject+isDictionary.h"
#import "ZHNScrollingNavigationController.h"

@interface ZHNAsyncDisplayTableNodeBaseViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) ZHNGooeyMenu *gooeyMenu;
@property (nonatomic,strong) NSMutableArray *indexPathesToBeReloaded;
@end

@implementation ZHNAsyncDisplayTableNodeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 1;
    self.panControllPopGesture.enabled = NO;
    [self.view addSubnode:self.tableNode];
    self.tableNode.frame = self.view.bounds;
    
    @weakify(self);
    self.tableNode.view.mj_header = [ZHNRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self displayTableNode_loadDataType:ZHNfetchDataTypeLoadLatest];
    }];
    
    self.tableNode.view.mj_footer = [ZHNRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self displayTableNode_loadDataType:ZHNfetchDataTypeLoadMore];
    }];
    
    self.extraNightVersionChangeHandle = ^{
        @strongify(self);
        self.tableNode.backgroundColor = ZHNCurrentThemeFitColorForkey(CellBG);
        self.tableNode.view.separatorColor = ZHNCurrentThemeFitColorForkey(DetailCellSeparatorColor);
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(ZHNScrollingNavigationController *)self.navigationController  followScrollViewWithScrollableView:self.tableNode.view naviBarScrollingType:ZHNNavibarScrollingTypeScrollingLikeSafari delay:30 scrollSpeedFactor:2 followers:nil];
    [(ZHNScrollingNavigationController *)self.navigationController setIgnoreRefreshPulling:NO];
}


- (void)zhn_detailBeginInitData {
    if (self.didAppeared) {return;}
    self.didAppeared = YES;
    [self.tableNode.view.mj_header beginRefreshing];
}

// Need inheritance
- (void)reloadNavigationDalegate{}
- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray {return nil;}
- (NSArray<NSString *> *)gooeyMenuTitles {return nil;}
- (RACSignal *)displayTableNode_formatterDataArrat:(NSArray *)dataArray {return [RACSignal return:dataArray];}
- (Class)displayTableNode_dataClass {return [ZHNTimelineStatus class];}
- (BOOL)displayTableNode_needCache {return NO;}
- (NSArray *)displayTableNode_specialMapJsonArrayWithResult:(id)result {return nil;}

- (unsigned long long)currentMaxIDForFetchDataType:(ZHNfetchDataType)fetchDataType {
    unsigned long long maxid = 0;
    switch (fetchDataType) {
        case ZHNfetchDataTypeLoadMore:
        {
            maxid = self.maxID;
        }
            break;
        default:
            break;
    }
    return maxid;
}

- (unsigned long long)currentSinceIDForFetchDataType:(ZHNfetchDataType)fetchDataType {
    unsigned long long sinceID = 0;
    switch (fetchDataType) {
        case ZHNfetchDataTypeLoadLatest:
        {
            ZHNTimelineStatus *minStatus = [self.statusArray firstObject];
            sinceID = minStatus.statusID;
        }
            break;
        default:
            break;
    }
    return sinceID;
}

- (void)tableNodeDisplayCell:(ASCellNode *)cellNode indexpath:(NSIndexPath *)indexPath {
    if ([self.indexPathesToBeReloaded containsObject:indexPath]) {
        ASCellNode *oldCellNode = [self.tableNode nodeForRowAtIndexPath:indexPath];
        cellNode.neverShowPlaceholders = YES;
        oldCellNode.neverShowPlaceholders = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cellNode.neverShowPlaceholders = NO;
            [self.indexPathesToBeReloaded removeObject:indexPath];
        });
    }
}

#pragma mark - delegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.statusArray.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNTimelineTransmitCellNode *node = [[ZHNTimelineTransmitCellNode alloc]init];
    return node;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gooeyMenuTitles.count > 0) {
        [self.gooeyMenu showMenu];
    }
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DZNEmptyDataSet datasource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"blank_data_placeholder"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -K_Navibar_height;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)displayTableNode_loadDataType:(ZHNfetchDataType)fetchDateType{
    // load Cache
    if (fetchDateType == ZHNfetchDataTypeLoadCache) {
        self.statusArray = [[self displayTableNode_dataClass] searchWithWhere:nil];
        if (self.statusArray.count > 0) {
            [self.tableNode reloadData];
            return;
        }
    }
    
    // Load net work data
    BOOL needCache = [self displayTableNode_needCache];
    NSString *url = [self requestURL];
    NSDictionary *params = [self requestParamsWithFetchDataType:fetchDateType];
    @weakify(self);
    [ZHNNETWROK get:url params:params responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
        @strongify(self);
        [self.requestResultSubject sendNext:result];
        
        // Cache maxid
        if ([result zhn_isDictionary]) {
            if (result[@"max_id"]) {
                self.maxID = [result[@"max_id"] longLongValue];
            }
        }
        
        // Json to model
        NSArray *addArray = nil;
        if ([self displayTableNode_requestJsonArrayMapKeyArray]) {
            NSArray *keyArray = [self displayTableNode_requestJsonArrayMapKeyArray];
            for (NSString *key in keyArray) {
                result = [result zhn_SJMapKey:key];
            }
            if ([result isKindOfClass:[NSArray class]]) {
                addArray = [NSArray yy_modelArrayWithClass:[self displayTableNode_dataClass] json:result];
            }
        }else {
            addArray = [self displayTableNode_specialMapJsonArrayWithResult:result];
            addArray = [NSArray yy_modelArrayWithClass:[self displayTableNode_dataClass] json:addArray];
        }
        
        // Formatter data
        [[self displayTableNode_formatterDataArrat:addArray]
         subscribeNext:^(id x) {
             // Updata footer hidden if need (weibo api have bug, sometime u set param`s count to `30`,but it will give u u `20+` data though it have enough data)
             if (addArray.count >= [self everyRequestMaxCount] - 10) {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     self.tableNode.view.mj_footer.hidden = NO;
                 });
             }
             
             [self.tableNode.view.mj_header endRefreshing];
             [self.tableNode.view.mj_footer endRefreshing];
             switch (fetchDateType) {
                 case ZHNfetchDataTypeLoadMore:
                 {
                     NSMutableArray *muAddArray = [addArray mutableCopy];
                     if (muAddArray.count > 0) {
                         [muAddArray removeObjectAtIndex:0];
                     }
                     NSMutableArray *indexPaths = [NSMutableArray array];
                     [muAddArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSInteger row = idx + self.statusArray.count;
                         NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
                         [indexPaths addObject:path];
                     }];
                     [self.statusArray addObjectsFromArray:muAddArray];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                     });
                     
                     // Add cache
                     if (needCache) {
                         [[self displayTableNode_dataClass] insertArrayByAsyncToDB:muAddArray];
                     }
                 }
                     break;
                 case ZHNfetchDataTypeLoadLatest:
                 case ZHNfetchDataTypeLoadCache:
                 {
                     self.statusArray = [addArray mutableCopy];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.indexPathesToBeReloaded addObjectsFromArray:[self.tableNode indexPathsForVisibleRows]];
                         [self.tableNode reloadData];
                     });
                     
                     // Add cache
                     if (needCache) {
                         [[self displayTableNode_dataClass] deleteWithWhere:nil];
                         [[self displayTableNode_dataClass] insertArrayByAsyncToDB:self.statusArray];
                     }
                 }
                     break;
                 default:
                     break;
             }
        }];
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        @strongify(self);
        [ZHNHudManager showError:@"获取数据失败~"];
        [self.tableNode.view.mj_header endRefreshing];
        [self.tableNode.view.mj_footer endRefreshing];
    }];
}

#pragma mark - pravite methods
- (CGSize)p_sizeForAttributeText:(NSAttributedString *)attributeText maxWidth:(CGFloat)maxWidth{
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributeText];
    return layout.textBoundingSize;
}

#pragma mark - getters
- (NSMutableArray *)statusArray {
    if (_statusArray == nil) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (ASTableNode *)tableNode {
    if (_tableNode == nil) {
        _tableNode = [[ASTableNode alloc]initWithStyle:UITableViewStylePlain];
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        _tableNode.view.emptyDataSetSource = self;
        _tableNode.view.emptyDataSetDelegate = self;
        _tableNode.view.tableFooterView = [[UIView alloc]init];
    }
    return _tableNode;
}

- (ZHNGooeyMenu *)gooeyMenu {
    if (_gooeyMenu == nil) {
        _gooeyMenu = [[ZHNGooeyMenu alloc]initWithTitleArray:[self gooeyMenuTitles] itemHeight:50 menuColor:[ZHNThemeManager zhn_getThemeColor]];
    }
    return _gooeyMenu;
}

- (NSMutableArray *)indexPathesToBeReloaded {
    if (_indexPathesToBeReloaded == nil) {
        _indexPathesToBeReloaded = [NSMutableArray array];
    }
    return _indexPathesToBeReloaded;
}

- (RACSubject *)requestResultSubject {
    if (_requestResultSubject == nil) {
        _requestResultSubject = [RACSubject subject];
    }
    return _requestResultSubject;
}
@end
