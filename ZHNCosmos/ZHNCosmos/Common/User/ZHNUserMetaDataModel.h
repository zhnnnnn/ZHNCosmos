//
//  ZHNUserMetaDataModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineModel.h"

@interface ZHNUserMetaDataModel : NSObject
@property (nonatomic,assign) BOOL isDisplay;
@property (nonatomic,assign) unsigned long long uid;
@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *webUserCookie;
@property (nonatomic,strong) ZHNTimelineUser *userDetail;
- (void)addUser;
- (void)deleteUserMetaData;
+ (void)updateDisplayUserCookie:(NSString *)cookie;
+ (void)updateDisplayUserDetail:(ZHNTimelineUser *)userDetail;
+ (ZHNUserMetaDataModel *)displayUserMetaData;
+ (NSArray <ZHNUserMetaDataModel *>*)addedUsers;
@end
