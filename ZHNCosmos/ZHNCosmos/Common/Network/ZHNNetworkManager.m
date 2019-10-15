//
//  ZHNNetworkManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNNetworkManager.h"
#import "RealReachability.h"
#import "ZHNHudManager.h"

@interface ZHNNetworkManager()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic,strong) AFHTTPResponseSerializer *httpResponseSerializer;
@end

@implementation ZHNNetworkManager
+ (instancetype)shareInstance {
    static ZHNNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNNetworkManager alloc]init];
        manager.sessionManager = [AFHTTPSessionManager manager];
    });
    return manager;
}

- (void)zhn_setRequestCookie:(NSString *)cookie {
    [self.sessionManager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
}

- (NSURLSessionDataTask *)get:(NSString *)url params:(id)params responseType:(ZHNResponseType)responseType success:(ZHNNetworkSuccessHandle)success failure:(ZHNNetworkFailureHandle)failure {
    [self p_configResponseForType:responseType];
    return [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable    responseObject) {
            if (success) {
                success(responseObject,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error,task);
            }
        }];
}

- (NSURLSessionDataTask *)post:(NSString *)url params:(id)params responseType:(ZHNResponseType)responseType success:(ZHNNetworkSuccessHandle)success failure:(ZHNNetworkFailureHandle)failure {
    [self p_configResponseForType:responseType];
    return [self.sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error,task);
            }
        }];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)url params:(id)params responseType:(ZHNResponseType)responseType success:(ZHNNetworkSuccessHandle)success failure:(ZHNNetworkFailureHandle)failure {
    [self p_configResponseForType:responseType];
    return [self.sessionManager HEAD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
        if (success) {
            success(nil,task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error,task);
        }
    }];
}

- (void)p_configResponseForType:(ZHNResponseType)type {
    switch (type) {
        case ZHNResponseTypeJSON:
            self.sessionManager.responseSerializer = self.jsonResponseSerializer;
            break;
        case ZHNResponseTypeHTTP:
            self.sessionManager.responseSerializer = self.httpResponseSerializer;
            break;
    }
}

#pragma mark - getters
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (_jsonResponseSerializer == nil) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFHTTPResponseSerializer *)httpResponseSerializer {
    if (_httpResponseSerializer == nil) {
        _httpResponseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _httpResponseSerializer;
}


#pragma mark - network state
- (void)startMonitorNetworkType {
    [GLobalRealReachability startNotifier];
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:kRealReachabilityChangedNotification object:nil]
      distinctUntilChanged]
     subscribeNext:^(NSNotification *notification) {
         RealReachability *reachability = (RealReachability *)notification.object;
         ReachabilityStatus status = [reachability currentReachabilityStatus];
         NSString *state;
         BOOL isReachable = YES;
         BOOL isNeeNotice = YES;
         switch (status) {
             case RealStatusNotReachable:
             {
                 state = @"网络已断开";
                 isReachable = NO;
             }
                 break;
             case RealStatusViaWiFi:
             {
                 state = @"已切换到 WIFI";
             }
                 break;
             case RealStatusViaWWAN:
             {
                 WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
                 if (accessType == WWANType2G)
                 {
                     state = @"已切换到 2G";
                 }
                 else if (accessType == WWANType3G)
                 {
                     state = @"已切换到 3G";
                 }
                 else if (accessType == WWANType4G)
                 {
                     state = @"已切换到 4G";
                 }
             }
                 break;
             default:
             {
                 isNeeNotice = NO;
             }
                 break;
         }
         
         if (isNeeNotice) {
             if (isReachable) {
                 [ZHNHudManager showWarning:state];
             }else {
                 [ZHNHudManager showError:state];
             }
         }
    }];
}

- (BOOL)isWIFI {
    if ([GLobalRealReachability currentReachabilityStatus] == RealStatusViaWiFi) {
        return YES;
    }else {
        return NO;
    }
}
@end
