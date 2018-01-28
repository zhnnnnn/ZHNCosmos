//
//  ZHNSearchDot.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/25.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHNSearchDotDelegate
- (void)ZHNSearchDotClickKeyboardSearhKeyWithSearchWord:(NSString *)searchWord;
@end

typedef NS_ENUM(NSInteger,ZHNSearchType) {
    ZHNSearchTypeUser,
    ZHNSearchTypeTimeline
};

@interface ZHNSearchDot : UIView
// Begin end search
- (void)zhn_beginSearchEditing;
- (void)zhn_endSearchEditing;
// Show hide dot
- (void)zhn_animateShow;
- (void)zhn_animateHide;
// instance dot
+ (instancetype)zhn_searchDotWithRelevanceHistoryTableView:(UITableView *)historyView;
// search type
@property (nonatomic,assign,readonly) ZHNSearchType searchType;
// delegate
@property (nonatomic,weak) id <ZHNSearchDotDelegate> delegate;
@end
