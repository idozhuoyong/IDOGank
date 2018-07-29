//
//  IDOCryptoFunc.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDOCryptoFunc : NSObject

#pragma mark - 加解密用
/**
 将文本DES加密之后进行Base64 （秘钥为"bundleIdentifier"）
 
 @param text 文本
 @return DES加密之后进行Base64的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 将文本DES加密之后进行Base64
 
 @param text 文本
 @param key 密钥
 @return DES加密之后进行Base64的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString *)key;

/**
 DES加密之后进行Base64的字符串还原为文本 （秘钥为"bundleIdentifier"）
 
 @param base64 DES加密之后进行Base64的字符串
 @return 文本
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

/**
 DES加密之后进行Base64的字符串还原为文本
 
 @param base64 DES加密之后进行Base64的字符串
 @param key 密钥
 @return 文本
 */
+ (NSString *)textFromBase64String:(NSString *)base64 withKey:(NSString *)key;

#pragma mark - DES加解密
#pragma mark DES加密
/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

#pragma mark DES解密
/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

#pragma mark - base64和文件转换
#pragma mark base64格式字符串转换为文本数据
/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

#pragma mark 文本数据转换为base64格式字符串
/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data;


@end
