//
//  ZHNCosmosLoginManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosUserManager.h"
#import <WebKit/WebKit.h>
#import "NSString+ZHNURLParams.h"
#import "ZHNUserMetaDataModel.h"
#import "ZHNWeiBoUserCookieManager.h"

@interface ZHNCosmosUserManager()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *password;// better to encrypt
@property (nonatomic,copy) ZHNLoginSuccessHandle successHandle;
@property (nonatomic,copy) ZHNLoginFailureHandle failueHandle;
@end

@implementation ZHNCosmosUserManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNCosmosUserManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNCosmosUserManager alloc]init];
    });
    return manager;
}

+ (ZHNUserMetaDataModel *)zhn_displayUserMetaData {
    return [ZHNUserMetaDataModel displayUserMetaData];
}

+ (void)zhn_addUserWithUserName:(NSString *)name password:(NSString *)password success:(ZHNLoginSuccessHandle)success failure:(ZHNLoginFailureHandle)failure {
    ZHNCosmosUserManager *manager = [ZHNCosmosUserManager shareManager];
    manager.webView = [[WKWebView alloc]init];
    manager.webView.navigationDelegate = manager;
    manager.name = name;
    manager.password = password;
    manager.successHandle = success;
    manager.failueHandle = failure;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://passport.weibo.cn/signin/login?client_id=2781539112&redirect_uri=http://kittenyang.com&display=sdk&action=login&offcialMobile=true&rf=1&version=003143000&sso_type=1&scope=direct_messages_write,direct_messages_read,friendships_groups_read,friendships_groups_write"]];
    [manager.webView loadRequest:request];
}

+ (void)zhn_userAddSuccessWithResponseObject:(NSObject *)responser action:(void (^)())action {
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:KUserAddSuccessNotification object:nil]
      takeUntil:responser.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         if (action) {
             action();
         }
     }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView url -- %@",webView.URL.absoluteString);
    if ([webView.URL.absoluteString containsString:@"https://passport.weibo.cn/signin/login"]) {
        NSString *inputName = [NSString stringWithFormat:@"document.getElementById(\"loginName\").value = \"%@\";",self.name];
        NSString *inputPWD = [NSString stringWithFormat:@"document.getElementById(\"loginPassword\").value = \"%@\";",self.password];
        [self.webView evaluateJavaScript:inputName completionHandler:^(id item, NSError * _Nullable error) {
        }];
        [self.webView evaluateJavaScript:inputPWD completionHandler:^(id item, NSError * _Nullable error) {
        }];
        [self.webView evaluateJavaScript:@"document.getElementById(\"loginAction\").click();" completionHandler:^(id item, NSError * _Nullable error) {
        }];
    }else if ([webView.URL.absoluteString containsString:@"https://open.weibo.cn/oauth2/authorize"]) {
        [self.webView evaluateJavaScript:@"document.getElementsByTagName('form')[0].submit();" completionHandler:^(id item, NSError * _Nullable error) {
        }];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *URL = navigationAction.request.URL.absoluteString;
    NSString *prefix = @"http://kittenyang.com/";
    if ([URL hasPrefix:prefix]) {
        NSString *accessToken = [URL zhn_analyticURLForparam:@"access_token"];
        NSString *uid = [URL zhn_analyticURLForparam:@"uid"];
        if (accessToken) {
            ZHNUserMetaDataModel *disPlayerUser = [[ZHNUserMetaDataModel alloc]init];
            disPlayerUser.accessToken = accessToken;
            disPlayerUser.uid = [uid longLongValue];
            disPlayerUser.isDisplay = YES;
            [disPlayerUser saveToDB];
            
            @weakify(self);
            [ZHNWeiBoUserCookieManager zhn_queryWeiboUserCookieWithUserName:self.name password:self.password success:^{
                [ZHNCosmosUserManager zhn_getUserDetailStatusWithUid:disPlayerUser.uid screenName:nil success:^(id result, NSURLSessionDataTask *task) {
                    @strongify(self);
                    ZHNTimelineUser *userDetail = [ZHNTimelineUser yy_modelWithDictionary:result];
                    [ZHNUserMetaDataModel updateDisplayUserDetail:userDetail];
                    [self p_loginSuccess];
                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                    @strongify(self);
                    [self p_loginFilure];
                }];
            } failure:^{
                @strongify(self);
                [self p_loginFilure];
            }];
        }else {
            [self p_loginFilure];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)p_loginFilure {
    if (self.failueHandle) {
        self.failueHandle();
    }
    [self p_releaseStatus];
}

- (void)p_loginSuccess {
    if (self.successHandle) {
        self.successHandle();
    }
    [self p_releaseStatus];
}

+ (void)zhn_getUserDetailStatusWithUid:(unsigned long long)uid screenName:(NSString *)screenName success:(ZHNNetworkSuccessHandle)success failure:(ZHNNetworkFailureHandle)failure {
    ZHNUserMetaDataModel *metaData = [ZHNUserMetaDataModel displayUserMetaData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (screenName) {
        [params zhn_safeSetObjetct:screenName forKey:@"screen_name"];
    }else {
        [params zhn_safeSetObjetct:@(uid) forKey:@"uid"];
    }
    [params zhn_safeSetObjetct:metaData.accessToken forKey:@"access_token"];
    [ZHNNETWROK get:@"https://api.weibo.com/2/users/show.json" params:params responseType:ZHNResponseTypeJSON success:success failure:failure];
}

- (void)p_releaseStatus {
    self.webView = nil;
    self.name = nil;
    self.password = nil;
}
@end
