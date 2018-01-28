//
//  ZHNRSAManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNRSAManager.h"
#import "PZCRSA.h"
#import "NSString+ZHNBase64.h"

@implementation ZHNRSAManager
//This method reference from http://codefunny.github.io/blog/2015/07/04/ios-rsa/  http://www.jianshu.com/p/25803dd9527d
+ (NSString *)zhn_publicKeyWithModString:(NSString *)mod {
    NSString *after02Tag = @"0203010001";
    NSString *fitMod = [NSString stringWithFormat:@"00%@",mod];
    
    NSInteger count = fitMod.length/2;
    NSString *hexLength = [NSString stringWithFormat:@"%02lX", (long)count];
    
    NSString *before02Tag = @"0281";
    before02Tag = [NSString stringWithFormat:@"%@%@",before02Tag,hexLength];
    
    NSString *before30Tag = @"3081";
    NSString *key = [NSString stringWithFormat:@"%@%@%@",before02Tag,fitMod,after02Tag];
    NSInteger keyCount = key.length/2;
    NSString *kexHexLength = [NSString stringWithFormat:@"%02lX", (long)keyCount];
    before30Tag = [NSString stringWithFormat:@"%@%@",before30Tag,kexHexLength];
    
    key = [NSString stringWithFormat:@"%@%@",before30Tag,key];
    return key;
}

+ (NSString *)zhn_encryptString:(NSString *)string withRSAModString:(NSString *)modStr {
    NSString *publicKey = [self zhn_publicKeyWithModString:modStr];
    NSData *keyData = [self hexToBytes:publicKey];
    PZCRSA *rsa = [[PZCRSA alloc] initWithPubKey:keyData];
    NSData *encryptData = [rsa encryptWithString:string];
    NSUInteger capacity = encryptData.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = encryptData.bytes;
    NSInteger i;
    for (i = 0; i < encryptData.length; ++i) {
        [sbuf appendFormat:@"%02lx", (unsigned long)buf[i]];
    }
    return sbuf;
}

+ (NSData *)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
