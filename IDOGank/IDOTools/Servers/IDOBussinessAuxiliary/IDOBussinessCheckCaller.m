//
//  IDOBussinessCheckCaller.m
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOBussinessCheckCaller.h"

@implementation IDOBussinessCheckCaller

#pragma mark - 对交易参数进行校验
/**
 *  对交易参数进行校验
 *
 *  @param caller 交易参数
 *
 *  @return YES(校验通过) / NO(校验未通过)
 */
+ (BOOL)checkTransactionValue:(IDOBussinessCaller *)caller {
    
    return YES;
}

#pragma mark - check proxy setting
/**
 代理设置检测
 
 @param urlString 检测地址
 @return YES(设置了代理)/NO(没设置代理)，默认NO
 */
+ (BOOL)checkProxySetting:(NSString *)urlString {
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:urlString]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    //NSLog(@"\n%@",proxies);
    
    if (proxies.count > 0) {
        NSDictionary *settings = proxies[0];
        //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
        //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
        //NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
        
        if ([((NSString *)kCFProxyTypeNone) isEqualToString:[settings objectForKey:(NSString *)kCFProxyTypeKey]]) {
            NSLog(@"没设置代理");
            return NO;
        } else {
            NSLog(@"设置了代理");
            return YES;
        }
    } else {
        return NO;
    }
}

@end


