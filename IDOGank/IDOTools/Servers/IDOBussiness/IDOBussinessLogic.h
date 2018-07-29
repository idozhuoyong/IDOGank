//
//  IDOBussinessLogic.h
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOBussiness.h"

@interface IDOBussinessLogic : NSObject

#pragma mark - init method
/**
 单例
 */
+ (instancetype)sharedInstance;

#pragma mark - 发送交易
/**
 发送POST交易
 
 @param caller 交易信息载体
 @param uploadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
- (void)sendPOSTWithCaller:(IDOBussinessCaller *)caller
                  progress:(void (^)(NSProgress * uploadProgress))uploadProgress
                   success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 发送GET交易
 
 @param caller 交易信息载体
 @param downloadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
- (void)sendGETWithCaller:(IDOBussinessCaller *)caller
                 progress:(void (^)(NSProgress * downloadProgress))downloadProgress
                  success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                  failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

#pragma mark - 从队列中移除交易
/**
 移除单个交易
 
 @param caller 需要移除的交易的载体
 */
- (void)removeTransaction:(IDOBussinessCaller *)caller;

/**
 移除整个页面的交易
 
 @param pageId 需要移除的交易页面ID
 */
- (void)removePageAllTransaction:(NSString *)pageId;

/**
 移除队列中所有交易
 */
- (void)removeAllTransaction;


@end
