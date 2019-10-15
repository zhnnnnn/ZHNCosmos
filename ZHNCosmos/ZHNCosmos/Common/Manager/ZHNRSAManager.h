//
//  ZHNRSAManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNRSAManager : NSObject
/**
 Create RSA public key with mod (default exp 10001)

 @param mod mod string
 */
+ (NSString *)zhn_publicKeyWithModString:(NSString *)mod;

/**
 encrypt string with RSA public key mod string (default exp 10001)

 @param string need encrypt string
 @param modStr public key mod string
 @return enctypted string
 */
+ (NSString *)zhn_encryptString:(NSString *)string withRSAModString:(NSString *)modStr;
@end
