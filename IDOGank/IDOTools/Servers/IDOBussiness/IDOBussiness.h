//
//  IDOBussiness.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#ifndef IDOBussiness_h
#define IDOBussiness_h

#import "IDONetworkCheck.h"
#import "IDOHTTPRequestManager.h"
#import "IDOBussinessCaller.h"
#import "IDOBussinessTransaction.h"
#import "IDOBussinessLogic.h"

#pragma mark - 日志打印相关
/**
 日志打印相关
 */
#ifdef DEBUG
#define KNetWorkLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define NSLog(...) {}
#define KNetWorkLog( s, ... )
#endif

#pragma mark - 错误信息列表
/************************************************************************
 *
 *错误信息列表
 *
 ***********************************************************************/
#define KIDONetworkError_Domain @"com.ido.KIDONetworkErrorDomain"

#define KIDONetworkError_NetworkNotConnect 0x10000 // 网络未连接
#define KIDONetworkError_RepeatTransaction 0x10001 // 重复交易

#pragma mark - 强引用转弱引用
/**
 强引用转弱引用
 */
//#define KWeakSelf __weak typeof(self) __weakSelf = self;
//#define KStrongSelf __strong typeof(self) __strongSelf = __weakSelf;
//#define weakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
//#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* IDOBussiness_h */
