//
//  IDOUIAlertView.h
//  IDOUIAlertView
//
//  Created by 卓勇 on 2017/3/29.
//  Copyright © 2017年 idozhuoyong. All rights reserved.
//

/**
 源码出处：https://github.com/wimagguc/ios-custom-alertview
 基于此源码添加了一些方法和属性
 修改后Demo地址：
 感谢 wimagguc 大神
 */
#import <UIKit/UIKit.h>
#import "IDODeviceInfo.h"

@class IDOUIAlertView, IDOUIAlertManager;
typedef void (^OnButtonClickHandle)(IDOUIAlertView *alertView, NSInteger buttonIndex);

@interface IDOUIAlertView : UIView

@property (nonatomic, strong) UIView *dialogView;            // 外层dialog视图
@property (nonatomic, strong) UIView *containerView;         // 自定义的布局（子视图）
@property (nonatomic, strong) NSArray *buttonTitles;         // 按钮标题数组
@property (nonatomic, assign) BOOL closeOnTouchUpOutside;    // 触摸背景关闭, 默认NO

@property (nonatomic, copy) OnButtonClickHandle onButtonClickHandle; // 按钮点击事件

/*
 初始化方法
 */
- (instancetype)init;
- (instancetype)initWithtitle:(NSString *)titleString info:(NSString *)infoString buttonTitles:(NSArray *)buttonTitles;
- (instancetype)initWithtitle:(NSString *)titleString info:(NSString *)infoString buttonTitles:(NSArray *)buttonTitles infoTextAlignment:(NSTextAlignment)textAlignment;

- (void)show; // 显示
- (void)close; // 关闭

@end

/********************************** IDOUIAlertManager **********************************************/
@interface IDOUIAlertManager : NSObject

#pragma mark - 单例类
+ (instancetype)sharedInstance;

#pragma mark - 弹框重复添加处理
/**
 弹框重复添加处理
 
 @param keyString keyString
 @param valueAlertView valueAlertView
 */
- (void)showAlertViewWithKeyString:(NSString *)keyString valueAlertView:(IDOUIAlertView *)valueAlertView;

#pragma mark - 弹框移除处理
/**
 弹框移除处理
 
 @param keyString keyString
 */
- (void)closeAlertViewWithKeyString:(NSString *)keyString;

@end
