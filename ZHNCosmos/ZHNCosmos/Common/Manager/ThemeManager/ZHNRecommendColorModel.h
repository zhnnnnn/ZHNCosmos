//
//  ZHNRecommendColorModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KDefaultThemeColorHexString @"D93E45"
@interface ZHNRecommendColorModel : NSObject
/**
 recommend color hex string
 */
@property (nonatomic,copy) NSString *hexString;

/**
 is theme color
 */
@property (nonatomic,assign) BOOL isThemeColor;

/**
 PrimaryKey
 */
@property (nonatomic,assign) int localID;

/**
 cache recommend theme color if not exhist
 */
+ (void)initializeRecommendThemeColorIfNeed;

/**
 get recommend color model array

 @return model array
 */
+ (NSArray <ZHNRecommendColorModel *> *)recommendColorModelArray;
@end
