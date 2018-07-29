//
//  IDOHTTPRequestManager.m
//  IDOGank
//
//  Created by 卓勇 on 2017/11/24.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOHTTPRequestManager.h"

/**
 AFNetworking参数说明
 
 【1】AFSecurityPolicy类：
    1.AFSSLPinningMode:
        AFSSLPinningModeNone,   代表客户端无条件地信任服务器端返回的证书
        AFSSLPinningModePublicKey,  代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行（校验公钥）
        AFSSLPinningModeCertificate, 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行（校验公钥和私钥）
    2.allowInvalidCertificates 客户端是否信任非法证书
    3.pinnedCertificates    用来校验服务器返回证书的证书。默认情况下，AFNetworking会自动寻找在mainBundle的根目录下所有的.cer文件并保存在pinnedCertificates数组里，以校验服务器返回的证书。
    4.validatesDomainName   是指是否校验在证书中的domain这一个字段。每个证书都会包含一个DomainName, 它可以是一个IP地址，一个域名或者一端带有通配符的域名。如*.google.com, www.google.com 都可以成为这个证书的DomainName。设置validatesDomainName=YES将严格地保证其安全性。
 
 【2】AFURLRequestSerialization
    1.AFHTTPRequestSerializer
        这种请求的请求参数格式：foo=bar&baz[]=1&baz[]=2&baz[]=3
    2.AFJSONRequestSerializer
        这种请求的请求参数格式：{"foo": "bar", "baz": [1,2,3]}
 
 【3】AFURLResponseSerialization
    1.AFHTTPResponseSerializer
        以二进制格式返回数据
    2.AFJSONResponseSerializer
        以json格式返回数据
 */
@interface IDOHTTPRequestManager ()

@property (nonatomic, strong) IDOHTTPSessionManager *manager;

@end

@implementation IDOHTTPRequestManager

#pragma mark - init method
/**
 请求单例
 
 @return self
 */
+ (instancetype)sharedHTTPSessionManager {
    static IDOHTTPRequestManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IDOHTTPRequestManager alloc] init];
        sharedManager.manager = [IDOHTTPSessionManager manager];
        [sharedManager configDefaultHTTPSessionManager];
    });
    
    return sharedManager;
}

/**
 配置默认请求信息
 */
- (void)configDefaultHTTPSessionManager {
    // 设置请求数据和返回数据格式
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置请求头信息
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [_manager.requestSerializer setValue:[NSString stringWithFormat:@"%@/%@", [infoDictionary objectForKey:@"CFBundleName"], [infoDictionary objectForKey:@"CFBundleVersion"]] forHTTPHeaderField:@"User-Agent"];
    [_manager.requestSerializer setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    [_manager.requestSerializer setValue:@"text/mobilejson" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:@"application/json, application/stream" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    
    // 设置编码格式
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // 设置超时时间
    _manager.requestSerializer.timeoutInterval = 30;
    
    // 开启Cookie
    _manager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    // 开启HTTP管道，可降低请求加载时间
    _manager.requestSerializer.HTTPShouldUsePipelining = YES;
    
    // 设置SSL信息
    // 1. 验证证书信息
    //_manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]; // 证书信息
    //_manager.securityPolicy.allowInvalidCertificates = NO; // 是否允许无效证书
    //_manager.securityPolicy.validatesDomainName = YES; // 是否验证域名
    //NSData *cerData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nccbank" ofType:@"cer"]];
    //_manager.securityPolicy.pinnedCertificates = [NSSet setWithObjects:cerData, nil];
    
    // 2. 验证公钥
    //_manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]; // 验证公钥
    //_manager.securityPolicy.allowInvalidCertificates = NO; // 是否允许无效证书
    //_manager.securityPolicy.validatesDomainName = YES; // 是否验证域名
    //NSData *cerData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nccbank" ofType:@"cer"]];
    //_manager.securityPolicy.pinnedCertificates = [NSSet setWithObjects:cerData, nil];
    
    // 3. 只允许有效证书
    //_manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; // 无条件信任服务端证书
    //_manager.securityPolicy.allowInvalidCertificates = NO; // 是否允许无效证书
    //_manager.securityPolicy.validatesDomainName = YES; // 是否验证域名
    
    // 4. 允许所有证书
    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; // 无条件信任服务端证书
    _manager.securityPolicy.allowInvalidCertificates = YES; // 是否允许无效证书
    _manager.securityPolicy.validatesDomainName = NO; // 是否验证域名
}

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
                           failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    NSURLSessionDataTask *sessionDataTask = [_manager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
    return sessionDataTask;
}

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
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure {
    NSURLSessionDataTask *sessionDataTask = [_manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
    return sessionDataTask;
}

#pragma mark - cancel method
/**
 取消所有网络请求
 */
- (void)cancel {
    [[_manager operationQueue] cancelAllOperations];
}
@end
