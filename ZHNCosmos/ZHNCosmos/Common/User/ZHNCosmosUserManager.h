//
//  ZHNCosmosUserManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNUserMetaDataModel.h"
typedef void (^ZHNLoginSuccessHandle)();
typedef void (^ZHNLoginFailureHandle)();
@interface ZHNCosmosUserManager : NSObject
/**
 Add user. (cantain 1.ocauth2.0 get accesstoken 2.simulation web weibo login to get cookie then use web api to get status)

 @param name user name
 @param password user password
 @param success success handle
 @param failure failure handle
 */
+ (void)zhn_addUserWithUserName:(NSString *)name
                       password:(NSString *)password
                        success:(ZHNLoginSuccessHandle)success
                        failure:(ZHNLoginFailureHandle)failure;


/**
 If add user success do something. such reload data

 @param responser responser to do something
 @param action action
 */
+ (void)zhn_userAddSuccessWithResponseObject:(NSObject *)responser
                                      action:(void(^)())action;

/**
 Get user detail status.(`uid`,`screenname` only need to set 1)

 @param uid user uid
 @param screenName user screenname
 @param success success handle
 @param failure failure handle
 */
+ (void)zhn_getUserDetailStatusWithUid:(unsigned long long)uid
                            screenName:(NSString *)screenName
                               success:(ZHNNetworkSuccessHandle)success
                               failure:(ZHNNetworkFailureHandle)failure;

/**
 Get current display user metadata

 @return user metadata
 */
+ (ZHNUserMetaDataModel *)zhn_displayUserMetaData;
@end
