//
//  ZHNSafariLoginForCookieManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZHNSafariLoginSuccessHandle)();
typedef void(^ZHNSafariLoginFalureHandle)();
@interface ZHNWeiBoUserCookieManager : NSObject
+ (void)zhn_queryWeiboUserCookieWithUserName:(NSString *)userName
                                    password:(NSString *)password
                                     success:(ZHNSafariLoginSuccessHandle)success
                                     failure:(ZHNSafariLoginFalureHandle)failure;
@end

/////////////////////////////////////////////////////
@interface ZHNSafariPreloginResult : NSObject
@property (nonatomic,copy) NSString *pubkey;
@property (nonatomic,copy) NSString *nonce;
@property (nonatomic,copy) NSString *servertime;
@property (nonatomic,copy) NSString *retcode;
@property (nonatomic,copy) NSString *rsakv;
@property (nonatomic,copy) NSString *isOpenlock;
@property (nonatomic,copy) NSString *pcid;
@property (nonatomic,copy) NSString *exectime;
@end

/////////////////////////////////////////////////////
@interface ZHNSafariLoginTicketModel : NSObject
@property (nonatomic,assign) NSInteger retcode;
@property (nonatomic,copy) NSString *ticket;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,strong) NSArray <NSString *> *crossDomainUrlList;
@end
