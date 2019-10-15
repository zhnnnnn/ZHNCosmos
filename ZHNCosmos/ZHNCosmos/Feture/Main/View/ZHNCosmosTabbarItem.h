//
//  ZHNCosmosTabbarItem.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHNTabbarItemNormalTypeClickBlock)();
typedef void(^ZHNTabbarItemSelectedTypeClickBlcok)();

@interface ZHNCosmosTabbarItem : UIView
@property (nonatomic,assign) BOOL isNeedDealAction;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,copy) NSString *tabbarItemName;
@property (nonatomic,copy) ZHNTabbarItemNormalTypeClickBlock selectAction;
@property (nonatomic,copy) ZHNTabbarItemSelectedTypeClickBlcok reloadAction;
- (void)deselect;
- (void)select;
- (void)noAnimateSelect;
@end
