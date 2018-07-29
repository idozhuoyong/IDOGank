//
//  IDOProjectDefine.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

/**
 *  存放当前工程专用的宏定义
 *
 *  上线检查事项：
 *
 */
#ifndef IDOProjectDefine_h
#define IDOProjectDefine_h

#pragma mark - 环境配置
/************************************************************************
 *
 *  开发环境    MODEL_DEBUG
 *  测试环境    MODEL_TEST
 *  准生产环境  MODEL_QUASIPRODUCTION
 *  发布环境    MODEL_RELEASE
 *
 ***********************************************************************/
#ifdef DEBUG
//#define MODEL_DEBUG
#define MODEL_TEST
//#define MODEL_QUASIPRODUCTION
//#define MODEL_RELEASE
#else
#define MODEL_RELEASE
#endif

#pragma mark - 配置服务端IP
/************************************************************************
 *
 *  配置服务端IP
 *
 ***********************************************************************/
#if defined (MODEL_DEBUG)
// 开发环境
#define SERVER_IP @"http://gank.io"

#elif defined (MODEL_TEST)
// 测试环境
#define SERVER_IP @"http://gank.io"

#elif defined (MODEL_QUASIPRODUCTION)
// 准生产环境
#define SERVER_IP @"http://gank.io"

#elif defined (MODEL_RELEASE)
// 生产环境
#define SERVER_IP @"http://gank.io"

#endif

#pragma mark - URL配置
/************************************************************************
 *
 *  配置服务端前缀
 *
 ***********************************************************************/
#define SERVER_PREFIX @"api/"
#define SERVER_URL [NSString stringWithFormat:@"%@/%@", SERVER_IP, SERVER_PREFIX]


#pragma mark - 开关
/************************************************************************
 *
 *  开关
 *
 ***********************************************************************/
//#define KIsCheckProxySetting // 代理检测开关
//#define KIsCheckCretSHA1TouchID // 服务器证书SHA-1指纹检测开关
//#define KIsOpenRepeatTrsFlag // 5分钟内重复交易提示开关

#pragma mark - 常用方法
/************************************************************************
 *
 *  常用方法
 *
 ***********************************************************************/
#define KDOCUMENT_FOLDER(fileName) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName])
#define KPageId(pageObj) ([NSString stringWithFormat:@"%@-%ld", NSStringFromClass([pageObj class]), (long)pageObj.hash])
#define KContext [IDOContext sharedInstance]


#endif /* IDOProjectDefine_h */
