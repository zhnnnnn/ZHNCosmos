//
//  ZHNUserMetaDataModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNUserMetaDataModel.h"

@implementation ZHNUserMetaDataModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"accessToken":@"access_token"
             };
}

+ (NSString *)getPrimaryKey {
    return @"uid";
}

- (void)addUser {
    for (ZHNUserMetaDataModel *model in [ZHNUserMetaDataModel searchWithWhere:nil]) {
        model.isDisplay = NO;
        [model updateToDB];
    }
    self.isDisplay = YES;
    [self saveToDB];
}

- (void)deleteUserMetaData {
    [self deleteUserMetaData];
    ZHNUserMetaDataModel *model = [[ZHNUserMetaDataModel searchWithWhere:nil] lastObject];
    model.isDisplay = YES;
    [model updateToDB];
}

+ (void)updateDisplayUserDetail:(ZHNTimelineUser *)userDetail {
    ZHNUserMetaDataModel *metaModel = [self displayUserMetaData];
    metaModel.userDetail = userDetail;
    [metaModel updateToDB];
}

+ (void)updateDisplayUserCookie:(NSString *)cookie {
    ZHNUserMetaDataModel *model = [self displayUserMetaData];
    model.webUserCookie = cookie;
    [model updateToDB];
}

+ (ZHNUserMetaDataModel *)displayUserMetaData {
    NSDictionary *params = @{@"isDisplay":@(YES)};
    return [[ZHNUserMetaDataModel searchWithWhere:params]firstObject];
}

+ (NSArray<ZHNUserMetaDataModel *> *)addedUsers {
    return [ZHNUserMetaDataModel searchWithWhere:nil];
}
@end
