//
//  IDOBussinessTransaction.m
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOBussinessTransaction.h"

@interface IDOBussinessTransaction ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, strong) IDOBussinessCaller *caller; // 交易信息的载体

@end

@implementation IDOBussinessTransaction

+ (instancetype)createRequestWithCaller:(IDOBussinessCaller *)caller {
    IDOBussinessTransaction *bussinessTransaction = [[IDOBussinessTransaction alloc] init];
    bussinessTransaction.caller = caller;
    return bussinessTransaction;
}

#pragma mark - 发送交易
/**
 发送POST交易
 
 @param uploadProgress uploadProgress
 @param success success
 @param failure failure
 */
- (void)sendPOSTWithProgress:(void (^)(NSProgress *uploadProgress))uploadProgress
                     success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                     failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    // 获取URL
    NSString *urlString = [self getUrlWithBaseUrl:self.caller.baseUrl transactionId:self.caller.transactionId parameters:self.caller.parameters];
    
    // 上送参数
    NSDictionary *parameters = [self processingParametersWithCaller:self.caller];
    
    // 重置请求为默认配置
    [[IDOHTTPRequestManager sharedHTTPSessionManager] configDefaultHTTPSessionManager];
    
    // 发送交易
    self.sessionDataTask = [[IDOHTTPRequestManager sharedHTTPSessionManager] sendPOST:urlString parameters:parameters progress:uploadProgress success:success failure:failure];
    
    // 交易发送完成
    KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－POST请求发送完成－－－－－－－－－－－－－－\n%@\n\n－交易参数\n%@\n－－－－－－－－－－－－－请求发送完成－－－－－－－－－－－－－－－\n", self.caller.transactionId, urlString, parameters);
}

/**
 发送GET交易
 
 @param downloadProgress downloadProgress
 @param success success
 @param failure failure
 */
- (void)sendGETWithProgress:(void (^)(NSProgress *downloadProgress))downloadProgress
                    success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                    failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    // 获取URL
    NSString *urlString = [self getUrlWithBaseUrl:self.caller.baseUrl transactionId:self.caller.transactionId parameters:self.caller.parameters];
    
    // 上送参数
    NSDictionary *parameters = [self processingParametersWithCaller:self.caller];
    
    // 重置请求为默认配置
    [[IDOHTTPRequestManager sharedHTTPSessionManager] configDefaultHTTPSessionManager];
    
    // 发送交易
    self.sessionDataTask = [[IDOHTTPRequestManager sharedHTTPSessionManager] sendGET:urlString parameters:parameters progress:downloadProgress success:success failure:failure];
    
    // 交易发送完成
    KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－GET请求发送完成－－－－－－－－－－－－－－\n%@\n\n－交易参数\n%@\n－－－－－－－－－－－－－请求发送完成－－－－－－－－－－－－－－－\n", self.caller.transactionId, urlString, parameters);
}

#pragma mark - cancel method
/**
 取消交易
 */
- (void)cancel {
    if (self.sessionDataTask) {
        [self.sessionDataTask cancel];
    }
}

#pragma mark - tool method
#pragma mark 对上送参数进行处理
/**
 *  对上送参数进行处理
 *
 *  @param caller caller
 *
 *  @return 处理后的参数
 */
- (NSDictionary *)processingParametersWithCaller:(IDOBussinessCaller *)caller {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:caller.transactionParameters];

    [dict setDictionary:caller.transactionCommonParameters];
    
    return dict;
}

#pragma mark 获取URL地址
/**
 *  获取URL地址
 *
 *  @param baseUrl baseUrl
 *  @param transactionId 交易id
 *  @param parameters 公共的URL地址参数
 *
 *  @return url地址
 */
- (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl transactionId:(NSString *)transactionId parameters:(NSDictionary *)parameters {
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
    [urlString appendString:transactionId];

    BOOL isFirst = YES;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [parameters allKeys]) {
            NSString *paramter = @"";

            if (isFirst) {
                paramter = [NSString stringWithFormat:@"?%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                isFirst = NO;
            } else {
                paramter = [NSString stringWithFormat:@"&%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }

            [urlString appendString:paramter];
        }
    }

    return urlString;
}

@end
