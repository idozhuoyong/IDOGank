//
//  IDOValueCheck.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOValueCheck.h"

@implementation IDOValueCheck

#pragma mark - 身份证校验
/**
 身份证校验
 
 @param idCardString idCardString
 @return YES/NO
 */
+ (BOOL)checkIDCardNumber:(NSString *)idCardString {
    
    if (idCardString.length < 18) {
        
        // 15位身份证号校验
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{7}((0[1-9])||(1[0-2]))((0[1-9])||(1\\d)||(2\\d)||(3[0-1]))\\d{3}$" options:0 error:nil];
        return [self matchString:idCardString withRegular:regular];
        
    } else {
        
        // 18位身份证号校验
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{5}[1-9]\\d{3}((0[1-9])||(1[0-2]))((0[1-9])||(1\\d)||(2\\d)||(3[0-1]))\\d{3}([0-9]||X)$" options:0 error:nil];
        return [self matchString:idCardString withRegular:regular];
        
    }
}

#pragma mark - 手机号校验
/**
 手机号校验
 
 @param phoneNumberString phoneNumberString
 @return YES/NO
 */
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumberString {
    
    if (phoneNumberString.length != 11) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 卡号校验
/**
 卡号校验
 
 @param accountNumber 银行卡号
 @return YES/NO
 */
+ (BOOL)checkAccountNumber:(NSString*)accountNumber {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"^[0-9\\-]{1,32}$" options:0 error:nil];
    return [self matchString:accountNumber withRegular:regular];
}

#pragma mark - 网银用户名校验
/**
 网银用户名校验
 
 @param userName 网银用户名
 @return YES/NO
 */
+ (BOOL)checkUserName:(NSString*)userName {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"^([0-9\\_\\-]*[a-zA-Z]+[a-zA-Z0-9\\_\\-]*)$" options:0 error:nil];
    return [self matchString:userName withRegular:regular];
}

#pragma mark - 登录密码校验
/**
 登录密码校验
 
 @param password 登录密码
 @return YES/NO
 */
+ (BOOL)checkLoginPassword:(NSString*)password {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"^(?![a-zA-Z]+$)(?![0-9]+$)[0-9a-zA-Z]{6,20}$" options:0 error:nil];
    return [self matchString:password withRegular:regular];
}



#pragma mark - tools
+ (BOOL)matchString:(NSString *)string withRegular:(NSRegularExpression *)regular {
    
    NSTextCheckingResult *match = [regular firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    if (match) {
        NSRange matchRange = [match range];
        if (matchRange.length == [string length]) {
            return YES;
        }
    }
    return NO;
}

@end

