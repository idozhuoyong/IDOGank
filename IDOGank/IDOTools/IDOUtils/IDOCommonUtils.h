//
//  IDOCommonUtils.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "PinYin4Objc.h"

/**
 存放公共的工具方法
 */
@interface IDOCommonUtils : NSObject

#pragma mark -
#pragma mark 字符串裁剪
/**
 *  字符串裁剪（裁剪空值和两端空格）
 *
 *  @param string 需要裁剪的字符串
 *  @return 裁剪之后字符串
 */
+ (NSString *)trimString:(NSString *)string;

#pragma mark 空对象处理
/**
 *  空对象处理
 *
 *  说明：
 *      1. [NSNull null]、@"<null>"、@"(null)" 返回 nil
 *      2. 其余原样返回
 *
 *  @param obj 需要处理的对象
 *  @return 处理之后的对象
 */
+ (NSObject *)trimNilObj:(NSObject *)obj;

#pragma mark -
#pragma mark 隐藏姓
/**
 *  隐藏姓名 - 隐藏姓
 *
 *  说明:
 *      1. 大于等于2位的姓名才能进行隐藏
 *      2. 例子：
 *          传入: 雷守东
 *          结果: *守东
 *
 *  @param name 要隐藏的姓名
 *
 *  @return 隐藏之后的姓名
 */
+ (NSString *)hideFirstName:(NSString *)name;

#pragma mark 隐藏名
/**
 *  隐藏姓名 - 隐藏名
 *
 *  说明:
 *      1. 大于等于2位的姓名才能进行隐藏
 *      2. 例子：
 *          传入: 雷守东
 *          结果: 雷**
 *
 *  @param name 要隐藏的姓名
 *
 *  @return 隐藏之后的姓名
 */
+ (NSString *)hideLastName:(NSString *)name;

#pragma mark 隐藏证件号码
/**
 *  隐藏证件号码
 *
 *  说明:
 *      1. 大于等于10位的证件号码才能进行隐藏
 *      2. 例子：
 *          传入: 360103197504084120
 *          结果: 360103********4120
 *
 *  @param idCard 要隐藏的证件号码
 *
 *  @return 隐藏之后的证件号码
 */
+ (NSString *)hideIdCard:(NSString *)idCard;

#pragma mark 隐藏手机号码
/**
 *  隐藏手机号码
 *
 *  说明:
 *      1. 大于等于7位的手机号码才能进行隐藏
 *      2. 例子：
 *          传入: 13349617695
 *          结果: 133****7695
 *
 *  @param mobilePhone 要隐藏的手机号码
 *
 *  @return 隐藏之后的手机号码
 */
+ (NSString *)hideMobilePhone:(NSString *)mobilePhone;

#pragma mark 隐藏银行卡号
/**
 *  隐藏银行卡号
 *
 *  说明:
 *      1. 大于8位的账号才能进行隐藏
 *      2. 例子：
 *          传入: 6222757300586843
 *          结果: 62227573****6843
 *
 *  @param bankCardNumber 要隐藏的账号
 *
 *  @return 隐藏之后的账号
 */
+ (NSString *)hideBankCardNumber:(NSString *)bankCardNumber;

#pragma mark 账号是否为隐藏状态
/**
 账号是否为隐藏状态
 
 @param bankCardNumber 账号
 @return YES(隐藏状态)/NO(非隐藏状态)
 */
+ (BOOL)isHideBankCardNumber:(NSString *)bankCardNumber;

#pragma mark 隐藏昵称
/**
 *  隐藏昵称
 *
 *  说明:
 *      1. 大于5位的昵称才能进行隐藏
 *      2. 例子：
 *          传入: yangmuling
 *          结果: yang*****g
 *
 *  @param nickName 要隐藏的账号
 *
 *  @return 隐藏之后的账号
 */
+ (NSString *)hideNickName:(NSString *)nickName;

#pragma mark - 计算字符串的尺寸
/**
 *  计算字符串的尺寸
 *
 *  @param string 需要计算的字符串
 *  @param size 字符串尺寸规则
 *  @param attributes 字符串显示的规则
 *  @return 计算得到的尺寸
 */
+ (CGSize)getStringSize:(NSString *)string withSize:(CGSize)size attributes:(NSDictionary<NSString *, id> *)attributes;

#pragma mark -
#pragma mark 计算两个日期的间隔天数
/**
 *  计算两个日期的间隔天数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔天数
 */
+ (NSInteger)getDaysFrom:(NSDate *)startDate To:(NSDate *)endDate;

#pragma mark 日期转字符串
/**
 *  日期转字符串
 *
 *  @param date 需要转换的日期
 *  @return 转换之后的字符串(格式：yyyy-MM-dd)
 */
+ (NSString *)dateToString:(NSDate *)date;

#pragma mark 日期转字符串
/**
 *  日期转字符串
 *
 *  @param date 需要转换的日期
 *  @param formatter 转换的格式
 *  @return 转换之后的字符串
 */
+ (NSString *)dateToString:(NSDate *)date formatter:(NSString *)formatter;

#pragma mark 当前日期的字符串格式
/**
 *  当前日期的字符串格式
 *
 *  @return 当前日期的字符串格式(yyyy-MM-dd)
 */
+ (NSString *)getCurrentDateString;

#pragma mark 当前日期的字符串格式
/**
 *  当前日期的字符串格式
 *
 *  @param formatter 格式化的格式(默认格式：yyyy-MM-dd)
 *
 *  @return 字符串形式的当前日期
 */
+ (NSString *)getCurrentDateStringFormatter:(NSString *)formatter;

#pragma mark 根据指定日期获取一定时间差之后的日期
/**
 *  根据指定日期获取一定时间差之后的日期
 *
 *  说明：
 *      1. 指定日期默认为nil时默认当前的日期([NSDate date])
 *      2. yearNum、monthNum为nil时默认为0
 *      3. 例子：(当前日期为：2016-04-27)
 *          调用：[IDOCommonUtils getDateByDate:nil agoYear:0 agoMonth:-1 agoDay:0 format:nil]
 *          结果：2016-03-27
 *
 *  @param dateString     指定的日期
 *  @param yearNum  相差的年
 *  @param monthNum 相差的月
 *  @param dayNum 相差的天
 *  @param formatter 格式化的格式(默认格式：yyyy-MM-dd)
 *  @param dateStringFormatter 日期字符串格式(默认格式：yyyy-MM-dd)
 *
 *  @return 一定时间差之后的日期
 */
+ (NSString *)getDateStringByDateString:(NSString *)dateString year:(int)yearNum month:(int)monthNum day:(int)dayNum formatter:(NSString *)formatter dateStringFormatter:(NSString *)dateStringFormatter;

/**
 *  根据指定日期获取一定时间差之后的日期
 *
 *  说明：
 *      1. 指定日期默认为nil时默认当前的日期([NSDate date])
 *      2. yearNum、monthNum为nil时默认为0
 *      3. 例子：(当前日期为：2016-04-27)
 *          调用：[IDOCommonUtils getDateByDate:nil agoYear:0 agoMonth:-1 agoDay:0 format:nil]
 *          结果：2016-03-27
 *
 *  @param date     指定的日期
 *  @param yearNum  相差的年
 *  @param monthNum 相差的月
 *  @param dayNum 相差的天
 *  @param formatter 格式化的格式(默认格式：yyyy-MM-dd)
 *
 *  @return 一定时间差之后的日期
 */
+ (NSString *)getDateStringByDate:(NSDate *)date year:(int)yearNum month:(int)monthNum day:(int)dayNum formatter:(NSString *)formatter;

#pragma mark - 第一次启动
/**
 *  程序第一次启动判断
 *
 *  说明：
 *      1. 默认存储判断标识。
 *      2. 判断标识存储之后，再次判断时，就不在是第一次启动。
 *
 *  @return YES(第一次启动)/NO(不是第一次启动)
 */
+ (BOOL)isFirstLoadCurrentVersion;

/**
 *  程序第一次启动判断
 *
 *  说明：
 *      1. 判断标识存储之后，再次判断时，就不在是第一次启动。
 *
 *  @param isMenory YES(存储判断表示)/NO
 *
 *  @return YES(第一次启动)/NO(不是第一次启动)
 */
+ (BOOL)isFirstLoadCurrentVersionAndMenory:(BOOL)isMenory;

/**
 程序首次安装
 
 @param isMenory 是否存储标志
 @return YES(首次安装)/NO(不是首次安装)
 */
+ (BOOL)isFirstInstallAppAndMenoryFlag:(BOOL)isMenory;

#pragma mark - 图像处理
/**
 *  获取矩形的渐变色的UIImage(此函数还不够完善)
 *
 *  @param bounds       UIImage的bounds
 *  @param colors       渐变色数组，可以设置两种颜色
 *  @param gradientType 渐变的方式：0--->从上到下   1--->从左到右
 *
 *  @return 渐变色的UIImage
 */
+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray *)colors andGradientType:(int)gradientType;

/**
 更具指定颜色创建图片
 
 @param color color
 @return image
 */
+ (UIImage *)createImageWithColor:(UIColor*)color;

/**
 *  截图方法
 *
 *  @param screenView 需要截屏的view
 *
 *  @return 截屏后的image
 */
+ (UIImage *)screenshot:(UIView *)screenView;

/**
 *  图片加模糊效果
 *
 *  说明：
 *      1. 需要导入的库#import <Accelerate/Accelerate.h>
 *
 *  @param image 需要模糊的图片
 *  @param blur  模糊度
 *
 *  @return 模糊后的图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

#pragma mark - 接URL地址
/**
 *  拼接URL地址
 *
 *  @param sourceURLString 原始URL地址
 *  @param argument 需要拼接参数
 *
 *  @return 拼接完成的地址
 */
+ (NSString*)getUrlWithSourceURLString:(NSString*)sourceURLString argument:(NSDictionary*)argument;

#pragma mark - 拼音转换
/**
 *  把中文转化为拼音
 *  说明：
 *      案例：
 *        中国 ---> ZHONGGUO
 *  @param chinese 要转化的中文
 *
 *  @return 转化得到的拼音
 */
+ (NSString *)getPinyinFromChinese:(NSString *)chinese;

/**
 *  获取中文拼音首字母
 *  说明：
 *      案例：
 *        中国 ---> ZG
 *
 *  @param chinese 中文
 *
 *  @return 拼音首字母
 */
+ (NSString *)getChinesePinyinFirstCharacter:(NSString *)chinese;

#pragma mark - 根据身份证号码获取性别
/**
 根据身份证号码获取性别
 
 @param identityCard 身份证号码
 @return nil/男/女
 */
+ (NSString *)sexStringFromIdentityCard:(NSString *)identityCard;

@end
