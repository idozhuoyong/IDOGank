//
//  IDODeviceInfo.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDODeviceInfo.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "IDOKeyChain.h"

//判断是否越狱的字段
static const char* jailbreak_apps[] =
{
    "/Applications/Cydia.app",
    "/Applications/limera1n.app",
    "/Applications/greenpois0n.app",
    "/Applications/blackra1n.app",
    "/Applications/blacksn0w.app",
    "/Applications/redsn0w.app",
    "/Applications/Absinthe.app",
    NULL,
};

@implementation IDODeviceInfo

/**
 *  对字符串进行MD5
 *
 *  @param str 需要MD5的字符串
 *
 *  @return MD5之后的字符串
 */
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *  获取文件的MD5值
 *
 *  @param path 文件路径
 *
 *  @return 文件的MD5值 获取失败时返回nil
 */
+ (NSString *)fileMD5:(NSString*)path {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil )
        return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 1024 ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

/**
 *  获取设备的mac地址
 *
 *  @return 成功：2C:F0:EE:25:F2:D4 / 失败：NULL
 */
+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

/**
 *  获取设备ip地址
 *
 *  @return 成功：192.168.1.103 / 失败：NULL
 */
+ (NSString *)getIPAddress {
    NSString *address = NULL;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

/**
 *  获取设备公网ip地址，此方法需要提前缓存
 *
 *  @return 成功：218.64.77.171 / 失败：NULL
 */
+ (NSString *)getPublicIPAddress {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSURL *urlString = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSMutableString *resultString = [NSMutableString stringWithContentsOfURL:urlString encoding:NSUTF8StringEncoding error:nil];
        // KDebugLog(@"%@", resultString);
        // 218.64.77.171
        // 通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回调或者说是通知主线程刷新，
            if (resultString) {
                [[NSUserDefaults standardUserDefaults] setObject:resultString forKey:@"PublicIPAddress"];
            }
        });
    });
    
    NSString *resultString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PublicIPAddress"];
    if (resultString) {
        return resultString;
    } else {
        return [self getIPAddress];
    }
    
    /*
     NSURL *urlString = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
     NSMutableString *resultString = [NSMutableString stringWithContentsOfURL:urlString encoding:NSUTF8StringEncoding error:nil];
     KDebugLog(@"%@", resultString);
     // var returnCitySN = {"cip": "218.64.77.171", "cid": "360100", "cname": "江西省南昌市"};
     if (resultString) {
     
     NSArray *array = [resultString componentsSeparatedByString:@"\""];
     if (array.count > 3) {
     return array[3];
     }
     return [self getIPAddress];
     } else {
     return [self getIPAddress];
     }
     */
}

/**
 *  设备是否越狱
 *
 *  @return YES(越狱) / NO(未越狱)
 */
+ (BOOL)isJailBroken {
    // Now check for known jailbreak apps. If we encounter one, the device is jailbroken.
    for(int i = 0; jailbreak_apps[i] != NULL; ++i)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_apps[i]]])
        {
            //NSLog(@"isjailbroken: %s", jailbreak_apps[i]);
            return YES;
        }
    }
    // TODO: Add more checks? This is an arms-race we're bound to lose.
    
    return NO;
}

/**
 *  获取设备的UUIDString
 *
 *  @return UUIDString
 */
+ (NSString *)getUUIDString {
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 *  获取设备的唯一标识(利用钥匙串)
 *
 *  @return 设备的唯一标识
 */
+ (NSString *)getDeviceUniquelyIdentify {
    
    NSString *uniquelyIdentifyKey  = @"UniquelyIdentifyKey";
    
    if ([IDOKeyChain keyChainObjectForKey:uniquelyIdentifyKey]) {
        // 钥匙串中存在标识，直接获取并返回
        return [IDOKeyChain keyChainObjectForKey:uniquelyIdentifyKey];
    } else {
        // 钥匙串中不存在标识
        // 存储标识到钥匙串中
        [IDOKeyChain keyChainSetObject:[self getUUIDString] forKeyedSubscript:uniquelyIdentifyKey];
        
        // 防止钥匙串存储异常，这里先判断，然后获取
        if ([IDOKeyChain keyChainObjectForKey:uniquelyIdentifyKey]) {
            return [IDOKeyChain keyChainObjectForKey:uniquelyIdentifyKey];
        } else {
            // 防止钥匙串存储异常，放弃钥匙串持久保持方式
            if ([[NSUserDefaults standardUserDefaults] objectForKey:uniquelyIdentifyKey]) {
                return [[NSUserDefaults standardUserDefaults] objectForKey:uniquelyIdentifyKey];
            } else {
                NSString *uuidString = [self getUUIDString];
                [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:uniquelyIdentifyKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return uuidString;
            }
        }
    }
}

/**
 *  获取资源文件的MD5值
 *
 *  @return 资源文件的MD5值
 */
+ (NSString *)resourceFileMD5
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *md5Str = nil;
    
    [self allMD5fromDirPath:resourcePath withtoMD5Str:&md5Str];
    
    if (nil == md5Str) {
        md5Str = @"";
    }
    
    return md5Str;
}

+ (void)allMD5fromDirPath:(NSString *)dirPath withtoMD5Str:(NSString **)md5Str
{
    NSError *error = nil;
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error];
    
    if (error) {
        return;
    }
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        
        if ([self isFileExistAtPath:fullpath]) {
            if ([filename hasSuffix:@".png"] || [filename hasSuffix:@".jpg"] || [filename hasSuffix:@".wav"] || [filename hasSuffix:@".gif"]) {
                *md5Str = [NSString stringWithFormat:@"%@%@", *md5Str, [self fileMD5:fullpath]];
                *md5Str = [self md5:*md5Str];
            }
        } else {
            [self allMD5fromDirPath:fullpath withtoMD5Str:md5Str];
        }
    }
}

+ (BOOL)isFileExistAtPath:(NSString*)fileFullPath
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

/**
 *  获取设备型号
 *  说明：
 *      @"iPhone", @"iPod touch"
 *
 *  @return 设备型号
 */

+(NSString *)getDeviceModle {
    return [[UIDevice currentDevice] model];
}

/**
 *  获取设备系统版本信息
 *  说明
 *      @"iOS 4.0"
 *
 *  @return 设备系统版本信息
 */

+(NSString *)getDeviceSystemInfo {
    return [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

/**
 获取 appVersion
 
 @return appVersion
 */
+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"]; // app版本
    return appVersion;
}

@end
