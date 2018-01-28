//
//  ZHNSearchHistoryTableView.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHNSearchHistoryTableViewDelegate
- (void)ZHNSearchHoistoryTableViewScrollToDismiss;
- (void)ZHNSearchHoistoryTableViewCilickToSearchWord:(NSString *)keyWord;
@end

@interface ZHNSearchHistoryTableView : UITableView
- (void)addSearchWord:(NSString *)searchWord;
@property (nonatomic,weak) id <ZHNSearchHistoryTableViewDelegate> historyDelegate;
@end

/////////////////////////////////////////////////////
@interface ZHNSearchHistoryModel : NSObject
@property (nonatomic,copy) NSString *searhWord;
@end
