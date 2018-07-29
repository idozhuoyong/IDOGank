//
//  IDOBase64.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/19.
//  Copyright © 2018年 激情工作室. All rights reserved.
//
//  Original Source Code is donated by Cyrus
//  Public Domain License
//  http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <Foundation/Foundation.h>

@interface IDOBase64 : NSObject

+ (void)initialize;

+ (NSString *)encode:(const uint8_t *)input length:(NSInteger) ength;

+ (NSString *)encode:(NSData *)rawBytes;

+ (NSData *)decode:(const char *)string length:(NSInteger)inputLength;

+ (NSData *)decode:(NSString *)string;

@end


// ************************************
@interface NSData (IDOBase64)

- (NSString *)ido_stringBySHA1ThenBase64Encoding;

@end


@interface NSString (IDOBase64)

- (NSString *)ido_stringBySHA1ThenBase64Encoding;

@end
