//
//  IDOBussinessCheckCaller.h
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOBussinessCaller.h"

/**
 *  交易校验
 */
@interface IDOBussinessCheckCaller : NSObject

#pragma mark - 对交易参数进行校验
/**
 *  对交易参数进行校验
 *
 *  @param caller 交易参数
 *
 *  @return YES(校验通过) / NO(校验未通过)
 */
+ (BOOL)checkTransactionValue:(IDOBussinessCaller *)caller;

#pragma mark - check proxy setting
/**
 代理设置检测
 
 @param urlString 检测地址
 @return YES(设置了代理)/NO(没设置代理)，默认NO
 */
+ (BOOL)checkProxySetting:(NSString *)urlString;

@end
