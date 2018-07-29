//
//  IDOKeyChain.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDOKeyChain : NSObject

/**
 存储信息到「keyChain」
 
 @param obj obj
 @param key key
 */
+ (void)keyChainSetObject:(nullable id)obj forKeyedSubscript:(id _Nullable)key;

/**
 从「KeyChain」中读取存储的信息
 
 @param key key
 @return 获取到信息
 */
+ (id _Nullable )keyChainObjectForKey:(nonnull id)key;

/**
 从「KeyChain」中删除指定「key」对应的信息
 
 @param key key
 */
+ (void)keyChainDeleteForKey:(nonnull id)key;

/**
 从「KeyChain」删除所有信息
 */
+ (void)keyChainDeleteAll;

@end
