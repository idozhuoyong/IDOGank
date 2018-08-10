//
//  IDOCommonDefine.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/19.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

/**
 存放公共的宏定义
 */
#ifndef IDOCommonDefine_h
#define IDOCommonDefine_h

#pragma mark - Frame相关
/**
 Frame相关
 */
#define KUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define KUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define KUIScreenScale (KUIScreenWidth / 375.0)
#define KScale(width) ((width) * KUIScreenScale)

#define KNavtationHeight (44) // (self.navigationController.navigationBar.frame.size.height) // 44
#define KStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 0 ? [[UIApplication sharedApplication] statusBarFrame].size.height : 20) // 20
#define KNavgationAndStateHeight (KNavtationHeight + KStatusBarHeight)
#define KTabBarHeight (self.tabBarController.tabBar.frame.size.height > 0 ? self.tabBarController.tabBar.frame.size.height : 49) // 49

#pragma mark - iOS系统版本相关
/**
 iOS系统版本相关
 */
#define KIOS_VERSION_8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define KIOS_VERSION_9_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define KIOS_VERSION_10_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define KIOS_VERSION_11_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


#pragma mark - 日志打印相关
/**
 日志打印相关
 */
#ifdef DEBUG
#define KDebugLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define NSLog(...) {}
#define KDebugLog( s, ... )
#endif

#pragma mark - 强引用转弱引用
/**
 强引用转弱引用
 */
#define weakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* IDOCommonDefine_h */
