//
//  IDOHTTPSessionManager.m
//  IDOGank
//
//  Created by 卓勇 on 2017/11/24.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOHTTPSessionManager.h"
#import <netdb.h>
#import <arpa/inet.h>
#import "IDOBase64.h"

@interface IDOHTTPSessionManager ()

@end

@implementation IDOHTTPSessionManager

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    [super URLSession:session didReceiveChallenge:challenge completionHandler:completionHandler];
    
    if (challenge != nil) {
        NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
        SecTrustRef trust = [protectionSpace serverTrust];
        NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];

        if (protectionSpace != nil && trust != nil && credential != nil) {
            // 从域名获取ip地址
            /*
            NSString *host = [protectionSpace host]; // 域名, e.g, ebank.ghbank.com.cn
            struct hostent* host_entry ;
            @try{
                host_entry = gethostbyname([host UTF8String]);
                char *ip = inet_ntoa(*((struct in_addr *)host_entry->h_addr_list[0]));
                NSString* ipAddressString = [NSString stringWithUTF8String:ip];
                NSLog(@"ipAddressString=%@", ipAddressString);
            } @catch (NSException * e) {
                NSLog(@"ip地址获取失败");
            }
            */
            SecCertificateRef serverCert;
            if (SecTrustGetCertificateCount(trust) > 0) {
                serverCert = SecTrustGetCertificateAtIndex(trust, 0);
            } else {
                serverCert = NULL;
            }
            
            // 证书摘要
            /*
            CFStringRef certSummary = SecCertificateCopySubjectSummary(serverCert);
            NSString* summaryString = [[NSString alloc] initWithString:(__bridge NSString*)certSummary];
            CFRelease(certSummary);
            NSLog(@"certSummary:%@",summaryString); // e.g, ebank.ghbank.com.cn
            */
            
            // 证书公钥
            @try {
                SecKeyRef secKeyRef = SecTrustCopyPublicKey(trust);
                KDebugLog(@"%@", secKeyRef);
                
                //NSString *tempString = [NSString stringWithFormat:@"%@", secKeyRef];
                //tempString = [[IDOCommonUtils trimString:[[[[tempString componentsSeparatedByString:@"modulus:"] ido_safeObjectAtIndex:1] componentsSeparatedByString:@","] ido_safeObjectAtIndex:0]] uppercaseString];
                //KDebugLog(@"%@", tempString);
                 
                NSData *tempData = [self publicKeyBitsFromSecKey:secKeyRef];
                //KDebugLog(@"%@", tempData);
                
                // 模数
                NSString *tempString2 = [[self stringFromData:[self getPublicKeyMod:tempData]] uppercaseString];
                KDebugLog(@"%@", tempString2);
                
                // 指数
                NSString *tempString3 = [[self stringFromData:[self getPublicKeyExp:tempData]] uppercaseString];
                KDebugLog(@"%@", tempString3);
                
                
                //if ([tempString2 containsString:tempString]) {
                //    KDebugLog(@"哈哈哈哈");
                //} else {
                //    KDebugLog(@"呵呵呵呵");
                //}
            } @catch(NSException *e) {
                
            }
            
            // 证书指纹SHA-1值
            @try {
                CFDataRef certData = SecCertificateCopyData(serverCert);
                NSData *summaryData = [[NSData alloc] initWithData:(__bridge NSData*)certData];
                NSString *sha1String = [[[IDOBase64 decode:[summaryData ido_stringBySHA1ThenBase64Encoding]] description] uppercaseString];
                sha1String = [sha1String stringByReplacingOccurrencesOfString:@" " withString:@""];
                sha1String = [sha1String stringByReplacingOccurrencesOfString:@"<" withString:@""];
                sha1String = [sha1String stringByReplacingOccurrencesOfString:@">" withString:@""];
                NSLog(@"sha1String:%@", sha1String);
                //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@""];
                CFRelease(certData);
            } @catch (NSException *e) {
                NSLog(@"服务器证书指纹SHA-1值获取失败");
            }
        }
    }
}


#pragma mark - 参考『https://github.com/DullDevil/RSADemo.git』
static NSString * const kTransfromIdenIdentifierPublic = @"kTransfromIdenIdentifierPublic";
- (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)givenKey {
    
    NSData *peerTag = [kTransfromIdenIdentifierPublic dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus sanityCheck = noErr;
    NSData * keyBits = nil;
    
    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
    [queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    [queryKey setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
    [queryKey setObject:@YES forKey:(__bridge id)kSecReturnData];
    
    
    
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
    if (sanityCheck == errSecSuccess) {
        keyBits = CFBridgingRelease(result);
        
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    
    return keyBits;
}

//公钥指数
- (NSData *)getPublicKeyExp:(NSData *)pk {
    
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    iterator += mod_size;
    
    iterator++; // TYPE - bit stream exp
    int exp_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, exp_size)];
}

//模数
- (NSData *)getPublicKeyMod:(NSData *)pk {
    if (pk == NULL) return NULL;
    
    int iterator = 0;
    
    iterator++; // TYPE - bit stream - mod + exp
    [self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
    
    iterator++; // TYPE - bit stream mod
    int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
    
    return [pk subdataWithRange:NSMakeRange(iterator, mod_size)];
}

- (int)derEncodingGetSizeFrom:(NSData*)buf at:(int*)iterator {
    const uint8_t* data = [buf bytes];
    int itr = *iterator;
    int num_bytes = 1;
    int ret = 0;
    
    if (data[itr] > 0x80) {
        num_bytes = data[itr] - 0x80;
        itr++;
    }
    
    for (int i = 0 ; i < num_bytes; i++) ret = (ret * 0x100) + data[itr + i];
    
    *iterator = itr + num_bytes;
    return ret;
}

- (NSString *)stringFromData:(NSData *)data {
    return  [[[[data description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
              stringByReplacingOccurrencesOfString: @">" withString: @""]
             stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
