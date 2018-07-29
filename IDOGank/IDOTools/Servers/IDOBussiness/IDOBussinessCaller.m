//
//  IDOBussinessCaller.m
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOBussinessCaller.h"

@implementation IDOBussinessCaller

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.transactionType = IDOQueryTransactionType; /** 交易类型 */
        self.activityMode = IDOActivityModeCanBackButCanNotCancel; /** 活动指示器类型 */
        self.errorMaskingType = IDOErrorNOMasking; /** 错误信息屏蔽方式 */
        
        self.isShowActivityIndicator = YES;  /** 是否显示活动指示器 */
        self.activityIndicatorText = @"正在加载...";  /** 活动指示器文字 */
        self.activityWrapView = [[UIApplication sharedApplication].windows firstObject]; /** 活动指示器的容器 */
        
        self.pageId = @""; /** 调用页面id */
        self.callerId = 0; /** 交易ID『用于一个页面发送相同参数的交易』 */
        
        self.baseUrl = @""; /** 交易公共地址 */
        self.transactionId = @""; /** 调用详细地址 */
        self.parameters = [NSMutableDictionary dictionary]; /** URL地址后面的参数 */
        
        self.transactionParameters = [NSMutableDictionary dictionary]; /** 交易参数 */
        self.transactionCommonParameters = [NSMutableDictionary dictionary]; /** 交易公共参数 */
        
        self.transactionCheckParameters = [NSMutableDictionary dictionary]; /** 辅助校验参数 */
        
        self.sessionDataTask = nil; /** 交易的请求 */
       
        self.isSuccess = NO;  /** 交易是否成功 */
        
        /** 交易响应结果 */
        self.responseObject = nil;
        self.error = nil;
        
        /** json对象类 */
        self.modelClass = nil;
        /** json对象 */
        self.modelObj = nil;
    }
    
    return self;
}

@end
