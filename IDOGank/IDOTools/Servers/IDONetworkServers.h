//
//  IDONetworkServers.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOBussinessCaller.h"

#pragma mark - 接口信息返回标志
/************************************************************************
 *
 *  接口信息返回标志
 *
 ***********************************************************************/
#define SUCCESS_CODE                false
#define RETURN_CODE                 @"error"

#define RETURN_ERRORCODE            @"errorCode"
#define RETURN_JSONERROE            @"jsonError"

#define RETURN_ERRORCODE_DATA_ERROR             @"RETURN_ERRORCODE_DATA_ERROR"              // 未返回 json 数据异常
//#define RETURN_ERRORCODE_Decrypt_AES_ERROR      @"RETURN_ERRORCODE_Decrypt_AES_ERROR"       // 加密报文解密失败

#define RETURN_ERRORCODE_NotConnected           @"RETURN_ERRORCODE_NotConnected"            // 未联网(未发送交易)
#define RETURN_ERRORCODE_RepeatTransaction      @"RETURN_ERRORCODE_RepeatTransaction"       // 重复交易(未发送交易)
#define RETURN_ERRORCODE_REQUEST_IMTOUT         @"RETURN_ERRORCODE_REQUEST_IMTOUT"          // 交易请求超时
#define RETURN_ERRORCODE_OTHER_CODE             @"RETURN_ERRORCODE_OTHER_CODE"              // 其他请求失败

#define RETURN_ERROR_Masking_FLAG   @"RETURN_ERROR_Masking_FLAG" // 错误屏蔽标志

@interface IDONetworkServers : NSObject

#pragma mark - 创建交易载体
/**
 创建默认交易载体
 
 @param wrapObj 交易所在的容器对象
 @return caller
 */
+ (IDOBussinessCaller *)createDefaultCallerWithWrapObj:(NSObject *)wrapObj;

#pragma mark - 发送交易
/**
 发送POST交易
 
 @param caller 交易信息载体
 @param uploadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
+ (void)sendPOSTWithCaller:(IDOBussinessCaller *)caller
                  progress:(void (^)(NSProgress * uploadProgress))uploadProgress
                   success:(void (^)(IDOBussinessCaller *caller))success
                   failure:(void (^)(IDOBussinessCaller *caller))failure;

/**
 发送GET交易
 
 @param caller 交易信息载体
 @param downloadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
+ (void)sendGETWithCaller:(IDOBussinessCaller *)caller
                 progress:(void (^)(NSProgress * downloadProgress))downloadProgress
                  success:(void (^)(IDOBussinessCaller *caller))success
                  failure:(void (^)(IDOBussinessCaller *caller))failure;

#pragma mark - 从队列中移除交易
/**
 移除单个交易
 
 @param caller 需要移除的交易的载体
 */
+ (void)removeTransaction:(IDOBussinessCaller *)caller;

/**
 移除整个页面的交易
 
 @param pageId 需要移除的交易页面ID
 */
+ (void)removePageAllTransaction:(NSString *)pageId;

/**
 移除队列中所有交易
 */
+ (void)removeAllTransaction;

@end
