//
//  IDOKeyChain.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//
//  https://github.com/v2panda/PDKeyChain

#import "IDOKeyChain.h"

#define KGroupAccessString ([NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]])

@implementation IDOKeyChain

/**
 存储信息到「keyChain」

 @param obj obj
 @param key key
 */
+ (void)keyChainSetObject:(nullable id)obj forKeyedSubscript:(id _Nullable)key {
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:KGroupAccessString];
    if (!tempDic) {
        tempDic = [NSMutableDictionary dictionary];
    }
    [tempDic setObject:obj forKey:key];
    [self save:KGroupAccessString data:tempDic];
}


/**
 从「KeyChain」中读取存储的信息

 @param key key
 @return 获取到信息
 */
+ (id _Nullable )keyChainObjectForKey:(nonnull id)key{
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:KGroupAccessString];
    if (!tempDic) {
        return nil;
    }
    return [tempDic objectForKey:key];
}

/**
 从「KeyChain」中删除指定「key」对应的信息

 @param key key
 */
+ (void)keyChainDeleteForKey:(nonnull id)key {
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:KGroupAccessString];
    if (!tempDic) {
        [self keyChainDeleteAll];
    } else {
        [tempDic removeObjectForKey:key];
        [self save:KGroupAccessString data:tempDic];
    }
}

/**
 从「KeyChain」删除所有信息
 */
+ (void)keyChainDeleteAll {
    [self delete:KGroupAccessString];
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


@end
