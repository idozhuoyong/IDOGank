//
//  IDOValueCheck.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 存放常用的校验规则 YES(校验通过)/NO(未通过)
 */
@interface IDOValueCheck : NSObject

+ (BOOL)matchString:(NSString *)string withRegular:(NSRegularExpression *)regular;

#pragma mark - 身份证校验
/**
 身份证校验
 
 @param idCardString idCardString
 @return YES/NO
 */
+ (BOOL)checkIDCardNumber:(NSString *)idCardString;

#pragma mark - 手机号校验
/**
 手机号校验
 
 @param phoneNumberString phoneNumberString
 @return YES/NO
 */
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumberString;

#pragma mark - 卡号校验
/**
 卡号校验
 
 @param accountNumber 银行卡号
 @return YES/NO
 */
+ (BOOL)checkAccountNumber:(NSString*)accountNumber;

#pragma mark - 网银用户名校验
/**
 网银用户名校验
 
 @param userName 网银用户名
 @return YES/NO
 */
+ (BOOL)checkUserName:(NSString*)userName;

#pragma mark - 登录密码校验
/**
 登录密码校验
 
 @param password 登录密码
 @return YES/NO
 */
+ (BOOL)checkLoginPassword:(NSString*)password;

@end
