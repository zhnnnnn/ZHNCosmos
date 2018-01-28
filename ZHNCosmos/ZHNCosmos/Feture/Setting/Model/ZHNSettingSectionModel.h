//
//  ZHNSettingSectionModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNSettingCellModel.h"

static CGFloat const KHeaderFooterLabelPadding = 20;
@interface ZHNSettingSectionModel : NSObject
@property (nonatomic,copy) NSString *headDesc;
@property (nonatomic,copy) NSString *footDesc;
@property (nonatomic,copy) NSString *DBConfigName;
@property (nonatomic,copy) NSArray <ZHNSettingCellModel *> *cellModelArray;

// normal
+ (instancetype)normalModelWithHeadDesc:(NSString *)headDesc
                       footDesc:(NSString *)footDesc
          sectionCellModelArray:(NSArray *)cellModelArray;

// checkmark cell
+ (instancetype)checkmarkModelWithHeadDesc:(NSString *)headDesc
                          footDesc:(NSString *)footDesc
                      dbConfigName:(NSString *)dbConfigName
             sectionCellModelArray:(NSArray *)cellModelArray;


- (CGFloat)headerHeight;

- (CGFloat)footerHeight;

+ (CGFloat)heightWithString:(NSString *)string;
@end
