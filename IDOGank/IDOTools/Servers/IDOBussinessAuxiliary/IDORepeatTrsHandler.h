//
//  IDORepeatTrsHandler.h
//  IDOGank
//
//  Created by 卓勇 on 2017/12/8.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "IDOBussinessCaller.h"
#import "IDODeviceInfo.h"

/**
 重复交易信息处理
 */
@interface IDORepeatTrsHandler : NSObject

/** 是否需要校验重复交易 */
@property (nonatomic, assign) BOOL isNeedCheckRepeatTrs;

/** 是否是重复交易 */
@property (nonatomic, assign) BOOL isRepeatTrs;

/** 交易id */
@property (nonatomic, copy) NSString *transactionId;

/** 交易参数MD5值 */
@property (nonatomic, copy) NSString *trsParametersMd5;

/** 交易时间 */
@property (nonatomic, strong) NSDate *trsDate;

/**
 重复交易处理
 
 @param caller caller
 @return IDORepeatTrsHandler
 */
+ (IDORepeatTrsHandler *)repeatTrsHandler:(IDOBussinessCaller *)caller;

/**
 把交易信息写入文件中
 
 @param trsDataModel trsDataModel
 */
+ (void)saveRepeatTrsInfo:(IDORepeatTrsHandler *)trsDataModel;

@end
