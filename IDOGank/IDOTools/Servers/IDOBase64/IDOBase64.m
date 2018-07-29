//
//  IDOBase64.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/19.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import "base64.h"

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static char decodingTable[128];

@interface IDOBase64 ()

@end

@implementation IDOBase64


+ (void)initialize {
    if (self == [IDOBase64 class]) {
        memset(decodingTable, 0, ArrayLength(decodingTable));
        for (NSInteger i = 0; i < ArrayLength(encodingTable); i++) {
            decodingTable[encodingTable[i]] = i;
        }
    }
}


+ (NSString*)encode:(const uint8_t *)input length:(NSInteger)length {
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    encodingTable[(value >> 18) & 0x3F];
        output[index + 1] =                    encodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding] ;
}


+ (NSString *)encode:(NSData *)rawBytes {
    return [self encode:(const uint8_t*) rawBytes.bytes length:rawBytes.length];
}


+ (NSData *)decode:(const char *)string length:(NSInteger)inputLength {
    if ((string == NULL) || (inputLength % 4 != 0)) {
        return nil;
    }
    
    while (inputLength > 0 && string[inputLength - 1] == '=') {
        inputLength--;
    }
    
    NSInteger outputLength = inputLength * 3 / 4;
    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
    uint8_t* output = data.mutableBytes;
    
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < inputLength) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
        char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
        }
    }
    
    return data;
}


+ (NSData *)decode:(NSString*)string {
    return [self decode:[string cStringUsingEncoding:NSUTF8StringEncoding] length:string.length];
}

@end

// ************************************
static NSString *newSHA1String(const char *bytes, size_t length) {
    uint8_t md[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(bytes, (unsigned int)length, md);
    
    size_t buffer_size = ((sizeof(md) * 3 + 2) / 2);
    
    char *buffer =  (char *)malloc(buffer_size);
    
    int len = b64_ntop(md, CC_SHA1_DIGEST_LENGTH, buffer, buffer_size);
    
    if (len == -1) {
        free(buffer);
        return nil;
    } else{
        return [[NSString alloc] initWithBytesNoCopy:buffer length:len encoding:NSASCIIStringEncoding freeWhenDone:YES];
    }
}

@implementation NSData (IDOBase64)

- (NSString *)ido_stringBySHA1ThenBase64Encoding {
    return newSHA1String(self.bytes, self.length);
}

@end


@implementation NSString (IDOBase64)

- (NSString *)ido_stringBySHA1ThenBase64Encoding {
    return newSHA1String(self.UTF8String, self.length);
}

@end
