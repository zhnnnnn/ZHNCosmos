//
//  ZHNDetailLikeTableViewCell.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/10.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineModel.h"

@interface ZHNDetailLikeTableViewCell : UITableViewCell
+ (ZHNDetailLikeTableViewCell *)zhn_detailLikeCellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZHNTimelineUser *user;
@end
