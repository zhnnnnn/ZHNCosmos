//
//  ZHNArchivedDataRootObject.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNArchivedDataRootObject.h"

@implementation ZHNArchivedDataRootObject
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
@end
