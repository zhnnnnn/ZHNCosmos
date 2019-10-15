//
//  ZHNNetworkManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#define ZHNNETWROK [ZHNNetworkManager shareInstance]
typedef NS_ENUM(NSInteger,ZHNResponseType) {
    ZHNResponseTypeJSON,
    ZHNResponseTypeHTTP
};
typedef void (^ZHNNetworkSuccessHandle) (id result, NSURLSessionDataTask *task);
typedef void (^ZHNNetworkFailureHandle) (NSError *error, NSURLSessionDataTask *task);
@interface ZHNNetworkManager : NSObject
/**
 Create manager

 @return manager
 */
+ (instancetype)shareInstance;

/**
 Start monitor network
 */
- (void)startMonitorNetworkType;

/**
 Judge is wifi ?

 @return isWifi
 */
- (BOOL)isWIFI;

/**
 Set request cookie

 @param cookie cookie
 */
- (void)zhn_setRequestCookie:(NSString *)cookie;


- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(id)params 
                 responseType:(ZHNResponseType)responseType
                      success:(ZHNNetworkSuccessHandle)success
                      failure:(ZHNNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(id)params
                  responseType:(ZHNResponseType)responseType
                       success:(ZHNNetworkSuccessHandle)success
                       failure:(ZHNNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)HEAD:(NSString *)url
                        params:(id)params
                  responseType:(ZHNResponseType)responseType
                       success:(ZHNNetworkSuccessHandle)success
                       failure:(ZHNNetworkFailureHandle)failure;
@end
