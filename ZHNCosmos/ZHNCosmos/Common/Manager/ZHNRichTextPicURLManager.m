//
//  ZHNRichTextPicURLManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRichTextPicURLManager.h"
#import "ZHNCosmosUserManager.h"

@implementation ZHNRichTextPicURLManager
+ (void)zhn_getDefaultPicURLWithKeyURL:(NSString *)keyURL success:(ZHNRictTextPicURLGetSusccess)success failure:(ZHNRictTextPicURLGetFailue)failure {
    ZHNUserMetaDataModel *userMetaData = [ZHNCosmosUserManager zhn_displayUserMetaData];
    [ZHNNETWROK zhn_setRequestCookie:userMetaData.webUserCookie];
    [ZHNNETWROK get:keyURL params:nil responseType:ZHNResponseTypeHTTP success:^(id result, NSURLSessionDataTask *task) {
        NSString *htmlStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if (!htmlStr) {
            if (failure) {
                failure();
            }
            return;
        }
        NSRegularExpression *picRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=src=\").*?(?=\">)" options:kNilOptions error:NULL];
        NSArray *picArray = [picRegex matchesInString:htmlStr options:kNilOptions range:NSMakeRange(0, htmlStr.length)];
        if (picArray.count == 1) {
            NSTextCheckingResult *regular = [picArray firstObject];
            NSString *picURL = [htmlStr substringWithRange:regular.range];
            if (success) {
                success(picURL);
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
}
@end
