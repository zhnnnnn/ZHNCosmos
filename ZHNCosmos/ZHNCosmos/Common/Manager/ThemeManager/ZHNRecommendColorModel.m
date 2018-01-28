//
//  ZHNRecommendColorModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRecommendColorModel.h"

@implementation ZHNRecommendColorModel
+ (NSString *)getTableName {
    return @"db_ZHNRecommendColorModel";
}

+ (void)initializeRecommendThemeColorIfNeed {
    if (![ZHNThemeManager zhn_getThemeColor]) {
        NSArray *hexColorArrayArray = @[@"#FFCF1B",@"#3A9885",@"#248EE0",@"#424242",KDefaultThemeColorHexString];;
        [hexColorArrayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZHNRecommendColorModel *model = [[ZHNRecommendColorModel alloc]init];
            model.hexString = obj;
            model.isThemeColor = NO;
            if (idx == hexColorArrayArray.count - 1) {
                model.isThemeColor = YES;
            }
            [model saveToDB];
        }];
    }
}

+ (NSArray<ZHNRecommendColorModel *> *)recommendColorModelArray {
   return [ZHNRecommendColorModel searchWithWhere:nil];
}
@end
