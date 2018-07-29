//
//  IDOBussinessCaller.h
//  IDOGank
//
//  Created by 卓勇 on 2017/2/27.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IDOActivityMode) {
    // 不遮蔽导航栏，但不能取消交易的模式
    IDOActivityModeCanBackButCanNotCancel,
    
    // 能取消交易，但遮蔽导航栏的模式
    IDOActivityModeCanCancelButCanNotBack,
    
    // 不遮蔽导航栏，且能取消交易的模式
    IDOActivityModeCanBackAndCanCancel,
    
    // 不能取消交易，且遮蔽导航栏的模式
    IDOActivityModeCanNotBackAndCanNotCancel,
    
    // 自定义加载模式 - 为当前项目添加
    IDOActivityModeCustomActivityView
};


typedef NS_ENUM(NSInteger, IDOTransactionType) {
    // 查询类交易
    IDOQueryTransactionType,
    
    // 资金类交易
    IDOCapitalTransactionType,
    
    // 包含密码的交易(除去资金类)
    IDOPasswordTransactionType,
    
    // 未分类较重要的交易
    IDOImportTransactionType
};

typedef NS_ENUM(NSInteger, IDOErrorMaskingType) {
    // 屏蔽全部错误信息，到具体交易中处理
    IDOErrorMaskingAll,
    
    // 屏蔽部分错误信息，已处理交易超时等错误信息，其余到具体交易中处理
    IDOErrorMaskingPart,
    
    // 不屏蔽错误信息，错误到公共地方处理，默认方式
    IDOErrorNOMasking
};

/**
 交易信息的载体
 */
@interface IDOBussinessCaller : NSObject

/** 交易类型 */
@property (nonatomic, assign) IDOTransactionType transactionType;
/** 活动指示器类型 */
@property (nonatomic, assign) IDOActivityMode activityMode;
/** 错误信息屏蔽方式 */
@property (nonatomic, assign) IDOErrorMaskingType errorMaskingType;

/** 是否显示活动指示器 */
@property (nonatomic, assign) BOOL isShowActivityIndicator;
/** 活动指示器文字 */
@property (nonatomic, copy) NSString *activityIndicatorText;
/** 活动指示器的容器 */
@property (nonatomic, strong) UIView *activityWrapView;

/** 调用页面id */
@property (nonatomic, copy) NSString *pageId;
/** 交易ID『用于一个页面发送相同参数的交易』 */
@property (nonatomic, assign) NSInteger callerId;

/** 交易公共地址 */
@property (nonatomic, copy) NSString *baseUrl;
/** 调用详细地址 */
@property (nonatomic, copy) NSString *transactionId;
/** URL地址后面的参数 */
@property (nonatomic, strong) NSMutableDictionary *parameters;

/** 交易参数 */
@property (nonatomic, strong) NSMutableDictionary *transactionParameters;
/** 交易公共参数 */
@property (nonatomic, strong) NSMutableDictionary *transactionCommonParameters;

/** 辅助校验参数 */
@property (nonatomic, strong) NSMutableDictionary *transactionCheckParameters;

/** 交易的请求 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

/** 交易是否成功 */
@property (nonatomic, assign) BOOL isSuccess;

/** 交易响应结果 */
@property (nonatomic, strong) NSDictionary *responseObject;
@property (nonatomic, strong) NSError *error; 

/** json对象类 */
@property (nonatomic, assign) Class modelClass;
/** json对象 */
@property (nonatomic, strong) NSObject *modelObj;

@end
