//
//  IDONetworkCheck.h
//  IDOGank
//
//  Created by 卓勇 on 2017/2/26.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    IDONotReachable = 0,
    IDOReachableViaWiFi,
    IDOReachableViaWWAN
} IDONetworkStatus;

/**
 *  网咯校验类
 *
 *  说明：此类依赖「Reachability」文件
 *
 */
@interface IDONetworkCheck : NSObject

+ (instancetype _Nullable )sharedInstance;

/**
 *  监听网络状态
 *
 *  注意：在调用的页面销毁的时候需要调用取消网络监听方法
 */
- (void)listeningNetworkState;

/**
 *  取消网络监听
 */
- (void)cancelListeningNetworkState;

/**
 *  判断网络是否可达
 *
 *  @return YES(网络可达)/NO(网络不可达)
 *
 *  说明：此处判断网络状态依据的是「www.baidu.com」
 */
- (BOOL)isExistenceNetwork;

/**
 *  判断指定主机是否可达
 *
 *  @param url 需要判断的地址
 *
 *  @return YES(网络可达)/NO(网络不可达)
 */
- (BOOL)isExistenceNetworkByUrl:(NSString *_Nonnull)url;


/**
 *  网络状态发生改变
 *
 *  @param block block
 */
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(IDONetworkStatus status))block;


@end
