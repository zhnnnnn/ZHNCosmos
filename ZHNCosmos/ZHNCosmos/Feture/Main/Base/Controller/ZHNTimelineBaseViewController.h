//
//  SecondViewController.h
//  ZHNCustomTabbar
//
//  Created by zhn on 2017/9/19.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNMagicTransitionBaseViewController.h"
#import "ZHNNetworkManager+timeline.h"
#import "ZHNCosmosUserManager.h"

@interface ZHNTimelineBaseViewController : ZHNMagicTransitionBaseViewController  <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/**
 Appeared
 */
@property (nonatomic,assign) BOOL didAppeared;

/**
 Content tableView
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 Cell Layout status array
 */
@property (nonatomic,strong) NSArray *layoutArray;

/**
 Homepage controller current User
 */
@property (nonatomic,strong) ZHNTimelineUser *homePageHostUser;

/**
 Initialize Refresh Header
 */
- (void)initializeRefreshHeader;

/**
 Initialize Refresh Footer
 */
- (void)initializeRefreshFooter;

/**
 Initialize ScrollIndicator
 */
- (void)initializeScrollIndicator;

/**
 Load statues

 @param fetchDataType status type
 */
- (RACSignal *)loadDataWithType:(ZHNfetchDataType)fetchDataType;

/**
 Net statues request url string

 @return url string
 */
- (NSString *)requestURL;

/**
 Net statuses request response type

 @return response type
 */
- (ZHNResponseType)requestResponseType;

/**
 Net status request params

 @param type load statues type (`loadlatest`,`loadmore`)
 @return params
 */
- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type;

/**
 Result array map key such as `@[@"1",@"2",@"3"]` 'jsonArray = result['1']['2']['3']'

 @return key array
 */
- (NSArray *)requestResultArrayMapKeyOrderArray;

/**
 Status data map key array such as `requestResultArrayMapKeyOrderArray` get  `[
     {
         'id':123,
         'status':`data`
     },
     {
         'id':123,
         'status':`data`
     }
 ]`

 @return key array
 */
- (NSArray *)requestStatuesMapkeyOrderArray;

/**
 How to processing the fetched data array

 @param fetchedLatoutArray data array
 @param fetchType fetched data type
 */
- (void)fetchedDataProcessing:(NSArray *)fetchedLatoutArray fetchDataType:(ZHNfetchDataType)fetchType;

/**
 Manual reload timeline rich text
 */
- (void)manualObserveReloadTimelineRichText;
- (void)manualReloadTimelineRichText;

/**
 Cached model for statues

 @return model class
 */
- (Class)cacheModelCalss;

/**
 Request data max count once time

 @return max count
 */
- (NSInteger)everyRequestMaxCount;

- (unsigned long long)currentSinceIDForFetchDataType:(ZHNfetchDataType)fetchDataType;
- (unsigned long long)currentMaxIDForFetchDataType:(ZHNfetchDataType)fetchDataType;
@end

