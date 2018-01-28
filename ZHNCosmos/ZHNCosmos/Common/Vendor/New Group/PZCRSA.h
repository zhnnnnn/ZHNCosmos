//
//  PZCRSA.h
//  
//
//  Created by peter on 15/7/2.
//  Copyright (c) 2015年 XXXX. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    NSString  *keyValue = @"30818902818100ADDC2B26BBA0E8BC8D532444656E367FD28924B5CB992728B87AB7DF09BA4043259AA8DF42D53D75CBF671DC617053BA5260CEEB42386431C3C3837C02AF5D8C665FB42F2F0949445133AEACE2DDE00CD8562D65978A6E057A3F18A63B0086E83A9A16A77C5F459ECCFD41D9E58ACF890B22E49428E9ADD21DD1A483E46AD3C10203010001";
    NSData    *keyData = [PZMessageUtils hexToBytes:keyValue];
    PZCRSA *rsa = [[PZCRSA alloc] initWithPubKey:keyData];
    
    NSData *result = [rsa encryptWithData:[PZMessageUtils hexToBytes:plainText]];
*/
@interface PZCRSA : NSObject {
    SecKeyRef publicKey;
    size_t maxPlainLen;
}
- (instancetype)initWithPubKey:(NSData *)data ;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;

@end
