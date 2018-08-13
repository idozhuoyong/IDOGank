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

@end
