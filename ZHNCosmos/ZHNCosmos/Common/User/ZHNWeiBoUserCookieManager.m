//
//  ZHNSafariLoginForCookieManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNWeiBoUserCookieManager.h"
#import "NSString+timeInterval.h"
#import "NSString+ZHNBase64.h"
#import "NSString+substring.h"
#import "ZHNRSAManager.h"
#import "ZHNUserMetaDataModel.h"

@implementation ZHNWeiBoUserCookieManager
+ (void)zhn_queryWeiboUserCookieWithUserName:(NSString *)userName password:(NSString *)password success:(ZHNSafariLoginSuccessHandle)success failure:(ZHNSafariLoginFalureHandle)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:@"openapi" forKey:@"entry"];
    [params zhn_safeSetObjetct:@"sinaSSOController.preloginCallBack" forKey:@"callback"];
    [params zhn_safeSetObjetct:[userName zhn_Base64Encoded] forKey:@"su"];
    [params zhn_safeSetObjetct:@"mod" forKey:@"rsakt"];
    [params zhn_safeSetObjetct:@"ssologin.js(v1.4.18)" forKey:@"client"];
    [params zhn_safeSetObjetct:[NSString zhn_getCurrentTimeInterval] forKey:@"_"];
    [ZHNNETWROK get:@"https://login.sina.com.cn/sso/prelogin.php" params:params responseType:ZHNResponseTypeHTTP success:^(id result, NSURLSessionDataTask *task) {
        NSString *resultString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSString *jsonString = [resultString zhn_subStringFromChar:@"(" toChar:@")"];
        ZHNSafariPreloginResult *preloginResult = [ZHNSafariPreloginResult yy_modelWithJSON:jsonString];
        NSString *message = [NSString stringWithFormat:@"%@\t%@\n%@",preloginResult.servertime,preloginResult.nonce,password];
        NSString *encryptString = [ZHNRSAManager zhn_encryptString:message withRSAModString:preloginResult.pubkey];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params zhn_safeSetObjetct:@"openapi" forKey:@"entry"];
        [params zhn_safeSetObjetct:@(1) forKey:@"gateway"];
        [params zhn_safeSetObjetct:@"" forKey:@"from"];
        [params zhn_safeSetObjetct:@(0) forKey:@"savestate"];
        [params zhn_safeSetObjetct:@(1) forKey:@"useticket"];
        [params zhn_safeSetObjetct:@"" forKey:@"pagerefer"];
        [params zhn_safeSetObjetct:@(1800) forKey:@"ct"];
        [params zhn_safeSetObjetct:@(1) forKey:@"s"];
        [params zhn_safeSetObjetct:@(1) forKey:@"vsnf"];
        [params zhn_safeSetObjetct:@"" forKey:@"vsnval"];
        [params zhn_safeSetObjetct:@"" forKey:@"door"];
        [params zhn_safeSetObjetct:@"3KeSKP" forKey:@"appkey"];
        [params zhn_safeSetObjetct:[userName zhn_Base64Encoded] forKey:@"su"];
        [params zhn_safeSetObjetct:@"miniblog" forKey:@"service"];
        [params zhn_safeSetObjetct:preloginResult.servertime forKey:@"servertime"];
        [params zhn_safeSetObjetct:preloginResult.nonce forKey:@"nonce"];
        [params zhn_safeSetObjetct:@"rsa2" forKey:@"pwencode"];
        [params zhn_safeSetObjetct:preloginResult.rsakv forKey:@"rsakv"];
        [params zhn_safeSetObjetct:encryptString forKey:@"sp"];
        [params zhn_safeSetObjetct:@"375*667" forKey:@"sr"];
        [params zhn_safeSetObjetct:@"UTF-8" forKey:@"encoding"];
        [params zhn_safeSetObjetct:@(2) forKey:@"cdult"];
        [params zhn_safeSetObjetct:@"weibo.com" forKey:@"domain"];
        [params zhn_safeSetObjetct:@"1199" forKey:@"prelt"];
        [params zhn_safeSetObjetct:@"TEXT" forKey:@"returntype"];
        
        NSString *URL = [NSString stringWithFormat:@"https://login.sina.com.cn/sso/login.php?client=ssologin.js(v1.4.18)&_=%@",[NSString zhn_getCurrentTimeInterval]];
        [ZHNNETWROK post:URL params:params responseType:ZHNResponseTypeHTTP success:^(id result, NSURLSessionDataTask *task) {
            NSString *resultString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            ZHNSafariLoginTicketModel *tickModel = [ZHNSafariLoginTicketModel yy_modelWithJSON:resultString];
            if (tickModel.retcode == 0) {
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:URL]];
                NSString *cookieString = @"";
                for (NSHTTPCookie *cookie in cookies) {
                    cookieString = [NSString stringWithFormat:@"%@%@=%@;",cookieString,cookie.name,cookie.value];
                }
                [ZHNUserMetaDataModel updateDisplayUserCookie:cookieString];
                if (success) {
                    success();
                }
            }else {
                if (failure) {
                    failure();
                }
            }
        } failure:^(NSError *error, NSURLSessionDataTask *task) {
            if (failure) {
                failure();
            }
        }];
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        if (failure) {
            failure();
        }
    }];
}

+ (NSString *)hexStringFromString:(NSString *)string{
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil]) {
      hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    }
    return hexStr;
}
@end

/////////////////////////////////////////////////////
@implementation ZHNSafariPreloginResult
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isOpenlock":@"is_openlock",
             };
}
@end

/////////////////////////////////////////////////////
@implementation ZHNSafariLoginTicketModel

@end

