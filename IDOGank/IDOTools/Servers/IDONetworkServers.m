//
//  IDONetworkServers.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDONetworkServers.h"
#import "IDOBussiness.h"
#import "IDOBussinessActivityIndicator.h"
#import "IDOBussinessCheckCaller.h"

@interface IDONetworkServers ()

@property (nonatomic, strong) IDOBussinessCaller *caller;
@property (nonatomic, copy) void(^uploadProgressBlock)(NSProgress *uploadProgress);
@property (nonatomic, copy) void(^successBlock)(IDOBussinessCaller *caller);
@property (nonatomic, copy) void(^failureBlock)(IDOBussinessCaller *caller);

@property (nonatomic, strong) IDOBussinessActivityIndicator *bussinessActivityIndicator;

@end

@implementation IDONetworkServers

#pragma mark - 从队列中移除交易
/**
 移除单个交易
 
 @param caller 需要移除的交易的载体
 */
+ (void)removeTransaction:(IDOBussinessCaller *)caller {
    [[IDOBussinessLogic sharedInstance] removeTransaction:caller];
}

/**
 移除整个页面的交易
 
 @param pageId 需要移除的交易页面ID
 */
+ (void)removePageAllTransaction:(NSString *)pageId {
    [[IDOBussinessLogic sharedInstance] removePageAllTransaction:pageId];
}

/**
 移除队列中所有交易
 */
+ (void)removeAllTransaction {
    [[IDOBussinessLogic sharedInstance] removeAllTransaction];
}


#pragma mark - 创建交易载体
/**
 创建默认交易载体

 @param wrapObj 交易所在的容器对象
 @return caller
 */
+ (IDOBussinessCaller *)createDefaultCallerWithWrapObj:(NSObject *)wrapObj {
    IDOBussinessCaller *caller = [[IDOBussinessCaller alloc] init];
    
    // 默认的公共参数可在此配置
    caller.pageId = KPageId(wrapObj);
    caller.baseUrl = SERVER_URL;
    
    return caller;
}

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
                   failure:(void (^)(IDOBussinessCaller *caller))failure {
    
    if (![IDOBussinessCheckCaller checkTransactionValue:caller]) {
        // 参数校验失败
        return;
    }
    
    if ([IDOBussinessCheckCaller checkProxySetting:caller.baseUrl]) {
        // 设置了代理
        [IDOProjectUtils showUpInfoWithMessage:@"检测到您的手机使用了网络代理，为了保证您的资金安全，请关闭手机网络代理"];
        return;
    }
    
    [[[[self class] alloc] init] sendPOSTWithCaller:caller progress:uploadProgress success:success failure:failure];
}

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
                  failure:(void (^)(IDOBussinessCaller *caller))failure {
    
    if (![IDOBussinessCheckCaller checkTransactionValue:caller]) {
        // 参数校验失败
        return;
    }
    
#ifdef KIsCheckProxySetting
    if ([IDOBussinessCheckCaller checkProxySetting:caller.baseUrl]) {
        // 设置了代理
        [IDOProjectUtils showUpInfoWithMessage:@"检测到您的手机使用了网络代理，为了保证您的资金安全，请关闭手机网络代理"];
        return;
    }
#endif
    
    [[[[self class] alloc] init] sendGETWithCaller:caller progress:downloadProgress success:success failure:failure];
}

#pragma mark
/**
 发送POST交易
 
 @param caller 交易信息载体
 @param uploadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
- (void)sendPOSTWithCaller:(IDOBussinessCaller *)caller
                  progress:(void (^)(NSProgress * uploadProgress))uploadProgress
                   success:(void (^)(IDOBussinessCaller *caller))success
                   failure:(void (^)(IDOBussinessCaller *caller))failure {
    
    self.caller = caller;
    self.uploadProgressBlock = uploadProgress;
    self.successBlock = success;
    self.failureBlock = failure;

    // 遮罩层
    self.bussinessActivityIndicator = [[IDOBussinessActivityIndicator alloc] init];
    [self.bussinessActivityIndicator showActivityIndicatorView:self.caller];
    self.bussinessActivityIndicator.bussinessCancelClickBlock = ^(IDOBussinessCaller *caller) {
        // 从队列中移除交易
        [[IDOBussinessLogic sharedInstance] removeTransaction:caller];
    };
    
    // 发送交易
    [[IDOBussinessLogic sharedInstance] sendPOSTWithCaller:self.caller progress:self.uploadProgressBlock success:^(NSURLSessionDataTask *task, id responseData) {
        KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－交易请求成功－－－－－－－－－－－－－－\n%@\n－－－－－－－－－－－－－－－－－－－－－－－－－－－\n\n", self.caller.transactionId, responseData);

        [self onSeccessProccessing:task data:responseData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－交易请求失败－－－－－－－－－－－－－－\n%@\n\n%@\n－－－－－－－－－－－－交易请求结束－－－－－－－－－－－－－－\n", self.caller.transactionId, error.localizedDescription, error);
        
        [self onFailureProccessing:task error:error];
    }];
}

/**
 发送GET交易
 
 @param caller 交易信息载体
 @param downloadProgress 进度
 @param success 成功block
 @param failure 失败block
 */
- (void)sendGETWithCaller:(IDOBussinessCaller *)caller
                 progress:(void (^)(NSProgress * downloadProgress))downloadProgress
                  success:(void (^)(IDOBussinessCaller *caller))success
                  failure:(void (^)(IDOBussinessCaller *caller))failure {
    
    self.caller = caller;
    self.uploadProgressBlock = downloadProgress;
    self.successBlock = success;
    self.failureBlock = failure;
    
    // 遮罩层
    self.bussinessActivityIndicator = [[IDOBussinessActivityIndicator alloc] init];
    [self.bussinessActivityIndicator showActivityIndicatorView:self.caller];
    self.bussinessActivityIndicator.bussinessCancelClickBlock = ^(IDOBussinessCaller *caller) {
        // 从队列中移除交易
        [[IDOBussinessLogic sharedInstance] removeTransaction:caller];
    };
    
    // 发送交易
    [[IDOBussinessLogic sharedInstance] sendGETWithCaller:self.caller progress:self.uploadProgressBlock success:^(NSURLSessionDataTask *task, id responseData) {
        KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－交易请求成功－－－－－－－－－－－－－－\n%@\n－－－－－－－－－－－－－－－－－－－－－－－－－－－\n\n", self.caller.transactionId, responseData);
        
        [self onSeccessProccessing:task data:responseData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        KNetWorkLog(@"\n\n%@\n－－－－－－－－－－－－交易请求失败－－－－－－－－－－－－－－\n%@\n\n%@\n－－－－－－－－－－－－交易请求结束－－－－－－－－－－－－－－\n", self.caller.transactionId, error.localizedDescription, error);
        
        [self onFailureProccessing:task error:error];
    }];
}

#pragma mark - 请求响应处理
- (void)onSeccessProccessing:(NSURLSessionDataTask *)task data:(id)responseData {
    // 对请求成功进行数据处理
    NSDictionary *responseObject = nil;
    
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        responseObject = [NSDictionary dictionaryWithDictionary:responseData];
    } else {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    }
    
    if (responseObject != nil) {
        // json格式数据
        if (SUCCESS_CODE == [[responseObject objectForKey:RETURN_CODE] boolValue]) {
            // 后台返回成功数据
            self.caller.sessionDataTask = task;
            self.caller.error = nil;
            self.caller.isSuccess = YES;
            self.caller.responseObject = [NSDictionary dictionaryWithDictionary:responseObject];
            
            // json 转 对象模型
            if (self.caller.modelClass) {
                self.caller.modelObj = [self.caller.modelClass ido_objectWithKeyValues:self.caller.responseObject];
            }
            
            // 对成功的信息进行处理
            [self transactionSeccessInfoProccessing:self.caller];
            
            // 进行成功回调
            if (self.successBlock) {
                self.successBlock(self.caller);
            }
        } else {
            // 后台返回失败数据
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setObject:RETURN_ERRORCODE_DATA_ERROR forKey:RETURN_ERRORCODE];
            [tempDict setObject:responseData forKey:RETURN_JSONERROE];

            self.caller.sessionDataTask = task;
            self.caller.error = nil;
            self.caller.isSuccess = NO;
            self.caller.responseObject = [NSDictionary dictionaryWithDictionary:tempDict];

            // 对失败的信息进行处理
            [self transactionFailureInfoProccessing:self.caller];

            // 进行失败回调
            if (self.failureBlock) {
                self.failureBlock(self.caller);
            }
        }
    } else {
        // 后台返回的不是 json 格式数据
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:RETURN_ERRORCODE_DATA_ERROR forKey:RETURN_ERRORCODE];
        [tempDict setObject:responseData forKey:RETURN_JSONERROE];

        self.caller.sessionDataTask = task;
        self.caller.error = nil;
        self.caller.isSuccess = NO;
        self.caller.responseObject = [NSDictionary dictionaryWithDictionary:tempDict];
        
        // 对失败的信息进行处理
        [self transactionFailureInfoProccessing:self.caller];
        
        // 进行失败回调
        if (self.failureBlock) {
            self.failureBlock(self.caller);
        }
    }
    
    // 关闭遮罩
    if (self.bussinessActivityIndicator) {
        [self.bussinessActivityIndicator hideAnimated];
    }
    
    // 从队列中移除交易
    [[IDOBussinessLogic sharedInstance] removeTransaction:self.caller];
}

- (void)onFailureProccessing:(NSURLSessionDataTask *)task error:(NSError *)error {
    // 对请求失败进行数据处理
    NSMutableDictionary *responseObject = [NSMutableDictionary dictionary];
    
    if (-1001 == error.code) {
        // 交易请求超时
        [responseObject setObject:RETURN_ERRORCODE_REQUEST_IMTOUT forKey:RETURN_ERRORCODE];
        [responseObject setObject:error.localizedDescription forKey:RETURN_JSONERROE];
    } else if ([KIDONetworkError_Domain isEqualToString:error.domain]) {
        // 自定义的错误
        switch (error.code) {
            case KIDONetworkError_NetworkNotConnect: {
                // 网络未连接
                [responseObject setObject:RETURN_ERRORCODE_NotConnected forKey:RETURN_ERRORCODE];
                [responseObject setObject:@"网络未连接" forKey:RETURN_JSONERROE];
            }
                break;
            case KIDONetworkError_RepeatTransaction: {
                // 重复交易
                [responseObject setObject:RETURN_ERRORCODE_RepeatTransaction forKey:RETURN_ERRORCODE];
                [responseObject setObject:@"重复交易" forKey:RETURN_JSONERROE];
            }
                break;
            default:
                break;
        }
    } else {
        // 其他错误
        [responseObject setObject:RETURN_ERRORCODE_OTHER_CODE forKey:RETURN_ERRORCODE];
        [responseObject setObject:error.localizedDescription forKey:RETURN_JSONERROE];
    }
    
    self.caller.sessionDataTask = task;
    self.caller.error = error;
    self.caller.isSuccess = NO;
    self.caller.responseObject = [NSDictionary dictionaryWithDictionary:responseObject];
    
    // 对失败的信息进行处理
    [self transactionFailureInfoProccessing:self.caller];
    
    // 进行失败回调
    if (self.failureBlock) {
        self.failureBlock(self.caller);
    }
    
    // 关闭遮罩
    if (self.bussinessActivityIndicator) {
        [self.bussinessActivityIndicator hideAnimated];
    }
    
    // 从队列中移除交易
    [[IDOBussinessLogic sharedInstance] removeTransaction:self.caller];
}

#pragma mark - 结果处理
/**
 对交易的成功信息进行处理

 @param caller caller
 */
- (void)transactionSeccessInfoProccessing:(IDOBussinessCaller *)caller {
    
}

/**
 对交易的错误信息进行处理

 @param caller caller
 */
- (void)transactionFailureInfoProccessing:(IDOBussinessCaller *)caller {
    if (IDOErrorMaskingAll == caller.errorMaskingType) {
        // 屏蔽全部错误信息，到具体交易中处理
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:caller.responseObject];
        [mutableDictionary setObject:@"1" forKey:RETURN_ERROR_Masking_FLAG];
        caller.responseObject = [NSDictionary dictionaryWithDictionary:mutableDictionary];
        return;
    }
    
    if ([RETURN_ERRORCODE_RepeatTransaction isEqualToString:[caller.responseObject objectForKey:RETURN_ERRORCODE]]) {
        // 重复交易
        KDebugLog(@"重复交易");
        
    } else if ([RETURN_ERRORCODE_NotConnected isEqualToString:[caller.responseObject objectForKey:RETURN_ERRORCODE]]) {
        // 未联网
        [IDOProjectUtils showUpInfoWithMessage:[caller.responseObject objectForKey:RETURN_JSONERROE]];
        
    } else if ([RETURN_ERRORCODE_REQUEST_IMTOUT isEqualToString:[caller.responseObject objectForKey:RETURN_ERRORCODE]]) {
        // 交易超时
        [IDOProjectUtils showUpInfoWithMessage:@"请求超时..."];
        
    } else if ([RETURN_ERRORCODE_OTHER_CODE isEqualToString:[caller.responseObject objectForKey:RETURN_ERRORCODE]]) {
        
        // 请求失败 - 其他错误
        if (caller.error.code == -999) {
            // Error Domain=NSURLErrorDomain Code=-999 "已取消"
        } else {
            [IDOProjectUtils showUpInfoWithMessage:[caller.responseObject objectForKey:RETURN_JSONERROE]];
        }
        
    } else if ([RETURN_ERRORCODE_DATA_ERROR isEqualToString:[caller.responseObject objectForKey:RETURN_ERRORCODE]]) {
        // 未返回json数据 需要在这里处理图片流数据
        [IDOProjectUtils showUpInfoWithMessage:@"返回数据格式有误..."];
        
    } else {
        // 后台抛出了错误码
        if (IDOErrorMaskingPart == caller.errorMaskingType) {
            // 屏蔽部分错误信息，已处理交易超时等错误信息，其余到具体交易中处理
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:caller.responseObject];
            [mutableDictionary setObject:@"1" forKey:RETURN_ERROR_Masking_FLAG];
            caller.responseObject = [NSDictionary dictionaryWithDictionary:mutableDictionary];
        } else {
            [IDOProjectUtils showUpInfoWithMessage:[caller.responseObject objectForKey:RETURN_JSONERROE]];
        }
    }
}

- (void)dealloc {
    KNetWorkLog(@"%@销毁了...", [self class]);
}

@end
