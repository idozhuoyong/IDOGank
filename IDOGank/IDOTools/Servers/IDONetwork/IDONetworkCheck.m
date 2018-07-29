//
//  IDONetworkCheck.m
//  IDOGank
//
//  Created by 卓勇 on 2017/2/26.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDONetworkCheck.h"
#import "Reachability.h"

@interface IDONetworkCheck () {
    Reachability *_reachability;
}

@property (nonatomic, copy) void(^networkReachabilityStatusBlock)(IDONetworkStatus status);

@end

@implementation IDONetworkCheck

+ (instancetype)sharedInstance {
    static IDONetworkCheck *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 *  监听网络状态
 *
 *  说明：可在updateNetworkStatus方法中定制对网络状态发生改变做出的响应
 *
 *  注意：在调用的页面销毁的时候需要调用取消网络监听方法
 */
- (void)listeningNetworkState {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetworkStatus) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    // 第一次手动调用
    [self updateNetworkStatus];
}

/**
 *  取消网络监听
 */
- (void)cancelListeningNetworkState {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  判断网络是否可达
 *
 *  @return YES(网络可达)/NO(网络不可达)
 *
 *  说明：此处判断网络状态依据的是SERVER_IP
 */
- (BOOL)isExistenceNetwork {
    return [self isExistenceNetworkByUrl:@"www.baidu.com"];
}

/**
 *  判断指定主机是否可达
 *
 *  @param url 需要判断的地址
 *
 *  @return YES(网络可达)/NO(网络不可达)
 */
- (BOOL)isExistenceNetworkByUrl:(NSString *)url {
    BOOL isExistenceNetwork = NO;
    
    Reachability *reachability = [Reachability reachabilityWithHostName:[[NSURL URLWithString:url] host]];
    
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}

/**
 *  网络状态改变的监听方法
 *
 *  说明：在此方法中可定制对网络状态改变的处理
 */
- (void)updateNetworkStatus {
    switch ([_reachability currentReachabilityStatus]) {
        case NotReachable: {
            NSLog(@"不可达的网络(未连接)");
            if (self.networkReachabilityStatusBlock) {
                self.networkReachabilityStatusBlock(IDONotReachable);
            }
        }
            break;
        case ReachableViaWWAN: {
            NSLog(@"2G,3G,4G...的网络");
            if (self.networkReachabilityStatusBlock) {
                self.networkReachabilityStatusBlock(IDOReachableViaWWAN);
            }
        }
            break;
        case ReachableViaWiFi: {
            NSLog(@"wifi的网络");
            if (self.networkReachabilityStatusBlock) {
                self.networkReachabilityStatusBlock(IDOReachableViaWiFi);
            }
        }
            break;
        default:
            break;
    }
}

/**
 *  网络状态发生改变
 *
 *  @param block block
 */
- (void)setReachabilityStatusChangeBlock:(nullable void (^)(IDONetworkStatus status))block {
    self.networkReachabilityStatusBlock = block;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
