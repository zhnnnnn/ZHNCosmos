//
//  ZHNLinkerTypeModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/3.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNArchivedDataRootObject.h"

@interface ZHNLinkerTypeModel : ZHNArchivedDataRootObject
@property (nonatomic,copy) NSString *replaceString;
@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *color;
@end
