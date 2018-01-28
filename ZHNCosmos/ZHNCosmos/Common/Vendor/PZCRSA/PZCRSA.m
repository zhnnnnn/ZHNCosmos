//
//  PZCRSA.m
//  
//
//  Created by peter on 15/7/2.
//  Copyright (c) 2015年 XXXX. All rights reserved.
//

#import "PZCRSA.h"

@implementation PZCRSA

- (instancetype)initWithPubKey:(NSData *)data {
    if (self = [super init]) {
        publicKey = [self addPublicKey:data];
        maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    }
    
    return self;
}

- (SecKeyRef)addPublicKey:(NSData *)key{
    NSData *data = key;
    if(!data){
        return nil;
    }
    
    NSString *tag = @"what_the_fuck_is_this";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKeyDict = [[NSMutableDictionary alloc] init];
    [publicKeyDict setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKeyDict setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKeyDict);
    
    // Add persistent version of the key to system keychain
    [publicKeyDict setObject:data forKey:(__bridge id)kSecValueData];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKeyDict, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKeyDict removeObjectForKey:(__bridge id)kSecValueData];
    [publicKeyDict removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKeyDict, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

- (NSData *) encryptWithData:(NSData *)content {

    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }

    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];

//    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
    size_t cipherLen = SecKeyGetBlockSize(publicKey);
    void *cipher = malloc(cipherLen);

    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);

    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }

    free(plain);
    free(cipher);

    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc{
    CFRelease(publicKey);
}

@end
