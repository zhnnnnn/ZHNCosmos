//
//  ZHNCosmosEditingBaseViewController.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNEditingBaseViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *activeModelArray;
@property (nonatomic,strong) NSMutableArray *nactiveModelArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *headerTitleArray;
@property (nonatomic,copy) NSArray *footerTitleArray;
- (void)zhn_tabviewCell:(UITableViewCell *)cell statusIntitalWithindexPath:(NSIndexPath *)indexPath;
- (BOOL)zhn_clickSaveExtraHandleIfSuccessEndEditing;
@end

////////////////////////////////////////////////////////
@interface ZHNEditingCell : UITableViewCell

@end
