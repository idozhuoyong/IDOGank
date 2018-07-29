//
//  IDOHTTPRequestManager.h
//  IDOGank
//
//  Created by 卓勇 on 2017/11/24.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOHTTPSessionManager.h"

@interface IDOHTTPRequestManager : NSObject

@property (readonly, nonatomic, strong) IDOHTTPSessionManager *manager;

#pragma mark - init method
/**
 请求单例
 
 @return self
 */
+ (instancetype)sharedHTTPSessionManager;

/**
 配置默认请求信息
 */
- (void)configDefaultHTTPSessionManager;

#pragma mark - request method
/**
 带进度的 POST 请求
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param uploadProgress 进度block
 @param success 成功block
 @param failure 失败block
 
 @return 请求NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)sendPOST:(NSString *)URLString
                        parameters:(id)parameters
                          progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                           success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                           failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 带进度的 GET 请求
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param downloadProgress 进度block
 @param success 成功block
 @param failure 失败block
 
 @return 请求NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)sendGET:(NSString *)URLString
                       parameters:(id)parameters
                         progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                          success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

#pragma mark - cancel method
/**
 取消所有网络请求
 */
- (void)cancel;

@end
