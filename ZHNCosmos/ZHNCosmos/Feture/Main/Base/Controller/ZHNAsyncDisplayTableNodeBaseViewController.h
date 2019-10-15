//
//  ZHNTimelineCommentsViewController.h
//  AsyncDisplayWeibo
//
//  Created by zhn on 2018/1/11.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineBaseViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ZHNDetailInitDataProtocol.h"

@interface ZHNAsyncDisplayTableNodeBaseViewController : ZHNTimelineBaseViewController<ASTableDelegate,ASTableDataSource,ZHNDetailInitDataProtocol>
@property (nonatomic,assign) unsigned long long  statuID;
@property (nonatomic,assign) unsigned long long maxID;
@property (nonatomic,strong) NSMutableArray *statusArray;
@property (nonatomic,strong) ASTableNode *tableNode;
- (NSArray <NSString *> *)gooeyMenuTitles;

// Request data
- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray;
- (RACSignal *)displayTableNode_formatterDataArrat:(NSArray *)dataArray;
- (Class)displayTableNode_dataClass;
- (NSArray *)displayTableNode_specialMapJsonArrayWithResult:(id)result;

// If need cache data
- (BOOL)displayTableNode_needCache;

// Result subject. Get unconventional data to display view
@property (nonatomic,strong) RACSubject *requestResultSubject;

- (unsigned long long)currentMaxIDForFetchDataType:(ZHNfetchDataType)fetchDataType;
- (unsigned long long)currentSinceIDForFetchDataType:(ZHNfetchDataType)fetchDataType;

// Load data
- (void)displayTableNode_loadDataType:(ZHNfetchDataType)fetchDateType;

// Fix reload flash
- (void)tableNodeDisplayCell:(ASCellNode *)cellNode indexpath:(NSIndexPath *)indexPath;
@end
