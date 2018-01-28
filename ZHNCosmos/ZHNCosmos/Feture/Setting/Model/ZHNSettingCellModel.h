//
//  ZHNSettingCellModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZHNSettingSelctBlock)();
@interface ZHNSettingCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign) UITableViewCellAccessoryType type;
@property (nonatomic,copy) ZHNSettingSelctBlock selectBlock;
// for checkmark
@property (nonatomic,assign) int ifSelectConfigValue;

// normal cell
+ (ZHNSettingCellModel *)normalModelWtiTitle:(NSString *)title
                                detail:(NSString *)detail
                              cellType:(UITableViewCellAccessoryType)cellType
                          selectAction:(ZHNSettingSelctBlock)selectAction;

// checkmark cell
+ (ZHNSettingCellModel *)checkMarkModelWithTitle:(NSString *)title
                              ifSelctConfigValue:(int)ifSelctConfigValue;
@end
