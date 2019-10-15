//
//  ZHNSettingSectionModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSettingSectionModel.h"

@implementation ZHNSettingSectionModel
+ (instancetype)normalModelWithHeadDesc:(NSString *)headDesc footDesc:(NSString *)footDesc sectionCellModelArray:(NSArray *)cellModelArray {
    return [self checkmarkModelWithHeadDesc:headDesc footDesc:footDesc dbConfigName:nil sectionCellModelArray:cellModelArray];
}

+ (instancetype)checkmarkModelWithHeadDesc:(NSString *)headDesc footDesc:(NSString *)footDesc dbConfigName:(NSString *)dbConfigName sectionCellModelArray:(NSArray *)cellModelArray {
    ZHNSettingSectionModel *sectionModel = [[ZHNSettingSectionModel alloc]init];
    sectionModel.headDesc = headDesc;
    sectionModel.footDesc = footDesc;
    sectionModel.DBConfigName = dbConfigName;
    sectionModel.cellModelArray = cellModelArray;
    return sectionModel;
}

- (CGFloat)headerHeight {
    return [ZHNSettingSectionModel heightWithString:self.headDesc];
}

- (CGFloat)footerHeight {
    return [ZHNSettingSectionModel heightWithString:self.footDesc];
}

+ (CGFloat)heightWithString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(K_SCREEN_WIDTH - 2 * KHeaderFooterLabelPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height + 15;
}
@end
