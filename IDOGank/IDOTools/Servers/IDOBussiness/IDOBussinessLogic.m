//
//  IDOBussinessLogic.m
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOBussinessLogic.h"

@interface IDOBussinessLogic ()

@property (nonatomic, strong) NSMutableDictionary *runningTransactions;

@end

@implementation IDOBussinessLogic

#pragma mark - init method
/**
 单例

 */
+ (instancetype)sharedInstance {
    static IDOBussinessLogic *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 初始化交易队列
        self.runningTransactions = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

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
                   failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    
    // 网络不通
    if (![[IDONetworkCheck sharedInstance] isExistenceNetworkByUrl:caller.baseUrl]) {
        KNetWorkLog(@"网络不通...");
        
        NSURLSessionDataTask *task = nil;
        NSError *error = [NSError errorWithDomain:KIDONetworkError_Domain code:KIDONetworkError_NetworkNotConnect userInfo:nil];
        
        // 进行失败回调
        if (failure) {
            failure(task, error);
        }
        return;
    }
    
    // 重复交易，队列中有当前交易
    if ([self.runningTransactions objectForKey:caller.pageId]) {
        // 存在页面的队列
        // 取出当前页面的交易队列
        NSMutableArray *pageRunningTransactions = [NSMutableArray arrayWithArray:[self.runningTransactions objectForKey:caller.pageId]];
        
        // 遍历队列，进行重复交易判断
        for (IDOBussinessTransaction *bt in pageRunningTransactions) {
            if ([bt.caller.pageId isEqualToString:caller.pageId] &&
                [bt.caller.transactionId isEqualToString:caller.transactionId] &&
                [bt.caller.transactionParameters isEqualToDictionary:caller.transactionParameters] &&
                bt.caller.callerId == caller.callerId) {
                // 重复交易，队列中有当前交易
                KNetWorkLog(@"重复交易，队列中有当前交易...");
                
                NSURLSessionDataTask *task = nil;
                NSError *error = [NSError errorWithDomain:KIDONetworkError_Domain code:KIDONetworkError_RepeatTransaction userInfo:nil];
                
                // 进行失败回调
                if (failure) {
                    failure(task, error);
                }
                return;
            }
        }
    }
    
    // 创建请求
    IDOBussinessTransaction *bussinessTransaction = [IDOBussinessTransaction createRequestWithCaller:caller];
    
    // 把请求加入到队列中
    if ([self.runningTransactions objectForKey:caller.pageId]) {
        NSMutableArray *pageRunningTransactions = [NSMutableArray arrayWithArray:[self.runningTransactions objectForKey:caller.pageId]];
        [pageRunningTransactions addObject:bussinessTransaction];
        [self.runningTransactions setObject:pageRunningTransactions forKey:caller.pageId];
    } else {
        [self.runningTransactions setObject:[NSMutableArray arrayWithObject:bussinessTransaction] forKey:caller.pageId];
    }
    
    // 发送请求
    [bussinessTransaction sendPOSTWithProgress:uploadProgress success:success failure:failure];
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
                  success:(void (^)(NSURLSessionDataTask *task, id responseData))success
                  failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    
    // 网络不通
    if (![[IDONetworkCheck sharedInstance] isExistenceNetworkByUrl:caller.baseUrl]) {
        KNetWorkLog(@"网络不通...");
        
        NSURLSessionDataTask *task = nil;
        NSError *error = [NSError errorWithDomain:KIDONetworkError_Domain code:KIDONetworkError_NetworkNotConnect userInfo:nil];

        // 进行失败回调
        if (failure) {
            failure(task, error);
        }
        return;
    }
    
    // 重复交易，队列中有当前交易
    if ([self.runningTransactions objectForKey:caller.pageId]) {
        // 存在页面的队列
        // 取出当前页面的交易队列
        NSMutableArray *pageRunningTransactions = [NSMutableArray arrayWithArray:[self.runningTransactions objectForKey:caller.pageId]];
        
        // 遍历队列，进行重复交易判断
        for (IDOBussinessTransaction *bt in pageRunningTransactions) {
            if ([bt.caller.pageId isEqualToString:caller.pageId] &&
                [bt.caller.transactionId isEqualToString:caller.transactionId] &&
                [bt.caller.transactionParameters isEqualToDictionary:caller.transactionParameters] &&
                bt.caller.callerId == caller.callerId) {
                // 重复交易，队列中有当前交易
                KNetWorkLog(@"重复交易，队列中有当前交易...");
                
                NSURLSessionDataTask *task = nil;
                NSError *error = [NSError errorWithDomain:KIDONetworkError_Domain code:KIDONetworkError_RepeatTransaction userInfo:nil];

                // 进行失败回调
                if (failure) {
                    failure(task, error);
                }
                return;
            }
        }
    }
    
    // 创建请求
    IDOBussinessTransaction *bussinessTransaction = [IDOBussinessTransaction createRequestWithCaller:caller];
    
    // 把请求加入到队列中
    if ([self.runningTransactions objectForKey:caller.pageId]) {
        NSMutableArray *pageRunningTransactions = [NSMutableArray arrayWithArray:[self.runningTransactions objectForKey:caller.pageId]];
        [pageRunningTransactions addObject:bussinessTransaction];
        [self.runningTransactions setObject:pageRunningTransactions forKey:caller.pageId];
    } else {
        [self.runningTransactions setObject:[NSMutableArray arrayWithObject:bussinessTransaction] forKey:caller.pageId];
    }
    
    // 发送请求
    [bussinessTransaction sendGETWithProgress:downloadProgress success:success failure:failure];
}

#pragma mark - 从队列中移除交易
/**
 移除单个交易

 @param caller 需要移除的交易的载体
 */
- (void)removeTransaction:(IDOBussinessCaller *)caller {
    
    if (caller) {
        // 取出当前页面的交易队列
        NSMutableArray *pageRunningTransactions = [self.runningTransactions objectForKey:caller.pageId];
        
        for (int i = 0; i < pageRunningTransactions.count; i++) {
            IDOBussinessTransaction *bt = [pageRunningTransactions objectAtIndex:i];
            
            if ([bt.caller.pageId isEqualToString:caller.pageId] &&
                [bt.caller.transactionId isEqualToString:caller.transactionId] &&
                [bt.caller.transactionParameters isEqualToDictionary:caller.transactionParameters] &&
                bt.caller.callerId == caller.callerId) {
                // 取消当前交易
                [bt cancel];
                
                // 从队列中删除
                [pageRunningTransactions removeObjectAtIndex:i];
                
                // 当前页面的队列是否还有数据？没有，从整个队列中删除；有，把新的当前页面队列添加到整个队列中
                if ([pageRunningTransactions count] == 0) {
                    [self.runningTransactions removeObjectForKey:caller.pageId];
                } else {
                    [self.runningTransactions setObject:pageRunningTransactions forKey:caller.pageId];
                }
                
                break;
            }
        }
    }
}

/**
 移除整个页面的交易

 @param pageId 需要移除的交易页面ID
 */
- (void)removePageAllTransaction:(NSString *)pageId {
    
    if (pageId) {
        
        // 取出当前页面的交易队列
        NSMutableArray *pageRunningTransactions = [self.runningTransactions objectForKey:pageId];
        
        for (int i = 0; i < pageRunningTransactions.count; i++) {
            
            IDOBussinessTransaction *bt = [pageRunningTransactions objectAtIndex:i];
            [bt cancel]; // 取消具体交易
        }
        
        // 删除交易队列
        [self.runningTransactions removeObjectForKey:pageId];
    }
}

/**
 移除队列中所有交易
 */
- (void)removeAllTransaction {
    
    for (NSString *key in [self.runningTransactions allKeys]) {
        
        NSMutableArray *pageRunningTransactions = [self.runningTransactions objectForKey:key];
        
        for (int i = 0; i < pageRunningTransactions.count; i++) {
            
            IDOBussinessTransaction *bt = [pageRunningTransactions objectAtIndex:i];
            [bt cancel]; // 取消具体交易
        }
        
        // 删除交易队列
        [self.runningTransactions removeObjectForKey:key];
    }
}


@end
