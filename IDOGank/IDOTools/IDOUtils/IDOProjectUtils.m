//
//  IDOProjectUtils.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOProjectUtils.h"
#import "FFToast.h"

@implementation IDOProjectUtils

#pragma mark - 弹窗
/**
 显示一个信息（显示在屏幕顶部）
 
 @param message 内容
 */
+ (void)showUpInfoWithMessage:(NSString *)message {
    [self showUpInfoWithTitle:nil message:message];
}

/**
 显示一个信息（显示在屏幕顶部）
 
 @param titleString 标题
 @param message 内容
 */
+ (void)showUpInfoWithTitle:(NSString *)titleString message:(NSString *)message {
    FFToast *toast = [[FFToast alloc] initToastWithTitle:titleString message:message iconImage:[UIImage ido_imageNamed:@"icon_fftoast_info"]];
    toast.toastType = FFToastTypeInfo;
    toast.duration = 5;
    [toast show:^{}];
}



@end
