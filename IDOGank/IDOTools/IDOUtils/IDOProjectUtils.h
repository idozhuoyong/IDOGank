//
//  IDOProjectUtils.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 存放依赖于工程的工具方法
 */
@interface IDOProjectUtils : NSObject

#pragma mark - 弹窗
/**
 显示一个信息（显示在屏幕顶部）
 
 @param message 内容
 */
+ (void)showUpInfoWithMessage:(NSString *)message;

/**
 显示一个信息（显示在屏幕顶部）
 
 @param titleString 标题
 @param message 内容
 */
+ (void)showUpInfoWithTitle:(NSString *)titleString message:(NSString *)message;

@end
