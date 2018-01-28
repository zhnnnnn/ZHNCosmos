//
//  ZHNStatusCell.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineLayoutModel.h"
#import "ZHNStatusBaseCell.h"

@class ZHNStatusCell;
@protocol ZHNStatusCellDelegate <NSObject>
@optional
- (void)ZHNStatusCell:(ZHNStatusCell *)cell longPressUserName:(NSString *)userName;
- (void)ZHNStatusCell:(ZHNStatusCell *)cell clickUserName:(NSString *)userName;
@end

@interface ZHNStatusCell : ZHNStatusBaseCell
@property (nonatomic,strong) ZHNTimelineLayoutModel *layout;
@property (nonatomic,weak) id <ZHNStatusCellDelegate> delegate;
- (void)reloadCellRichTextConfig;
+ (ZHNStatusCell *)zhn_statusCellWithTableView:(UITableView *)tableView;
@end
