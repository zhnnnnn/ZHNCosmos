//
//  ZHNRichTextPicURLManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/7.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZHNRictTextPicURLGetSusccess)(NSString *imageURL);
typedef void(^ZHNRictTextPicURLGetFailue)();
@interface ZHNRichTextPicURLManager : NSObject
+ (void)zhn_getDefaultPicURLWithKeyURL:(NSString *)keyURL
                               success:(ZHNRictTextPicURLGetSusccess)success
                               failure:(ZHNRictTextPicURLGetFailue)failure;
@end
