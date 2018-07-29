//
//  IDOBussinessTransaction.h
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOBussiness.h"

@interface IDOBussinessTransaction : NSObject

@property (readonly, nonatomic, strong) IDOBussinessCaller *caller; // 交易信息的载体

+ (instancetype)createRequestWithCaller:(IDOBussinessCaller *)caller;

#pragma mark - 发送交易
/**
 发送POST交易

 @param uploadProgress uploadProgress
 @param success success
 @param failure failure
 */
- (void)sendPOSTWithProgress:(void (^)(NSProgress *uploadProgress))uploadProgress
                     success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 发送GET交易

 @param downloadProgress downloadProgress
 @param success success
 @param failure failure
 */
- (void)sendGETWithProgress:(void (^)(NSProgress *downloadProgress))downloadProgress
                    success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                    failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;


#pragma mark - cancel method
/**
 取消交易
 */
- (void)cancel;

@end
