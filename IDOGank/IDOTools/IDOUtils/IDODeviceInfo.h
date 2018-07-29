//
//  IDODeviceInfo.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDODeviceInfo : NSObject
/**
 *  对字符串进行MD5
 *
 *  @param str 需要MD5的字符串
 *
 *  @return MD5之后的字符串
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  获取文件的MD5值
 *
 *  @param path 文件路径
 *
 *  @return 文件的MD5值 获取失败时返回nil
 */
+ (NSString *)fileMD5:(NSString*)path;

/**
 *  获取设备的mac地址
 *
 *  @return 成功：2C:F0:EE:25:F2:D4 / 失败：NULL
 */
+ (NSString *)getMacAddress;

/**
 *  获取设备ip地址
 *
 *  @return 成功：192.168.1.103 / 失败：NULL
 */
+ (NSString *)getIPAddress;

/**
 *  获取设备公网ip地址
 *
 *  @return 成功：218.64.77.171 / 失败：NULL
 */
+ (NSString *)getPublicIPAddress;


/**
 *  设备是否越狱
 *
 *  @return YES(越狱) / NO(未越狱)
 */
+ (BOOL)isJailBroken; // 判断设备是否越狱

/**
 *  获取设备的UUIDString
 *
 *  @return UUIDString
 */
+ (NSString *)getUUIDString;

/**
 *  获取设备的唯一标识(利用钥匙串)
 *
 *  @return 设备的唯一标识
 */
+ (NSString *)getDeviceUniquelyIdentify;

/**
 *  获取资源文件的MD5值
 *
 *  @return 资源文件的MD5值
 */
+ (NSString *)resourceFileMD5;

/**
 *  获取设备型号
 *  说明：
 *      @"iPhone", @"iPod touch"
 *
 *  @return 设备型号
 */

+(NSString *)getDeviceModle;

/**
 *  获取设备系统版本信息
 *  说明
 *      @"iOS 4.0"
 *
 *  @return 设备系统版本信息
 */

+(NSString *)getDeviceSystemInfo;

/**
 获取 appVersion
 
 @return appVersion
 */
+ (NSString *)getAppVersion;

@end
