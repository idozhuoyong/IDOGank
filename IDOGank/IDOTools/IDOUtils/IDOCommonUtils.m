//
//  IDOCommonUtils.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOCommonUtils.h"

@implementation IDOCommonUtils

#pragma mark -
#pragma mark 字符串裁剪
/**
 *  字符串裁剪（裁剪空值和两端空格）
 *
 *  @param string 需要裁剪的字符串
 *  @return 裁剪之后字符串
 */
+ (NSString *)trimString:(NSString *)string {
    if ([self trimNilObj:string] == nil) {
        return @"";
    }
    
    NSString *valueString = [NSString stringWithFormat:@"%@", string];
    
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *resultString = [valueString stringByTrimmingCharactersInSet:characterSet];
    
    return resultString;
}

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
+ (NSObject *)trimNilObj:(NSObject *)obj {
    if ([[NSNull null] isEqual:obj]) {
        
        return nil;
    } else if ([@"<null>" isEqual:obj]) {
        
        return nil;
    } else if ([@"(null)" isEqual:obj]) {
        
        return nil;
    } else {
        
        return obj;
    }
}

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
+ (NSString *)hideFirstName:(NSString *)name
{
    if (name.length > 1) {
        for (int i = 0; i < 1; i++) {
            name =  [name stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return name;
}

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
+ (NSString *)hideLastName:(NSString *)name
{
    if (name.length > 1) {
        for (int i = 1; i < name.length; i++) {
            name =  [name stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return name;
}

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
+ (NSString *)hideIdCard:(NSString *)idCard
{
    if (idCard.length > 10) {
        for (int i = 6; i < idCard.length - 4; i++) {
            idCard =  [idCard stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return idCard;
}

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
+ (NSString *)hideMobilePhone:(NSString *)mobilePhone
{
    if (mobilePhone.length > 7) {
        for (int i = 3; i < mobilePhone.length - 4; i++) {
            mobilePhone =  [mobilePhone stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return mobilePhone;
}

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
+ (NSString *)hideBankCardNumber:(NSString *)bankCardNumber
{
    if (bankCardNumber.length > 8) {
        for (int i = (int)bankCardNumber.length - 8; i < bankCardNumber.length-4; i++) {
            bankCardNumber =  [bankCardNumber stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return bankCardNumber;
}

#pragma mark 账号是否为隐藏状态
/**
 账号是否为隐藏状态
 
 @param bankCardNumber 账号
 @return YES(隐藏状态)/NO(非隐藏状态)
 */
+ (BOOL)isHideBankCardNumber:(NSString *)bankCardNumber
{
    if ([[self trimString:bankCardNumber] containsString:@"*"]) {
        return YES;
    }
    return NO;
}


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
+ (NSString *)hideNickName:(NSString *)nickName
{
    if (nickName.length > 6) {
        for (int i = 3; i < nickName.length - 1; i++) {
            nickName =  [nickName stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return nickName;
}


#pragma mark - 计算字符串的尺寸
/**
 *  计算字符串的尺寸
 *
 *  @param string 需要计算的字符串
 *  @param size 字符串尺寸规则
 *  @param attributes 字符串显示的规则
 *  @return 计算得到的尺寸
 */
+ (CGSize)getStringSize:(NSString *)string withSize:(CGSize)size attributes:(NSDictionary<NSString *, id> *)attributes {
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}

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
+ (NSInteger)getDaysFrom:(NSDate *)startDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:startDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

#pragma mark 日期转字符串
/**
 *  日期转字符串
 *
 *  @param date 需要转换的日期
 *  @return 转换之后的字符串(格式：yyyy-MM-dd)
 */
+ (NSString *)dateToString:(NSDate *)date {
    return [self dateToString:date formatter:@"yyyy-MM-dd"];
}

#pragma mark 日期转字符串
/**
 *  日期转字符串
 *
 *  @param date 需要转换的日期
 *  @param formatter 转换的格式
 *  @return 转换之后的字符串
 */
+ (NSString *)dateToString:(NSDate *)date formatter:(NSString *)formatter {
    if (!date) {
        
        return nil;
    } else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        if (formatter) {
            [dateFormatter setDateFormat:formatter];
        } else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        NSString *dateString = [dateFormatter stringFromDate:date];
        return [self trimString:dateString];
    }
}

#pragma mark 当前日期的字符串格式
/**
 *  当前日期的字符串格式
 *
 *  @return 当前日期的字符串格式(yyyy-MM-dd)
 */
+ (NSString *)getCurrentDateString {
    return [self getCurrentDateStringFormatter:@"yyyy-MM-dd"];
}

#pragma mark 当前日期的字符串格式
/**
 *  当前日期的字符串格式
 *
 *  @param formatter 格式化的格式(默认格式：yyyy-MM-dd)
 *
 *  @return 字符串形式的当前日期
 */
+ (NSString *)getCurrentDateStringFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return [self trimString:dateString];
}

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
+ (NSString *)getDateStringByDateString:(NSString *)dateString year:(int)yearNum month:(int)monthNum day:(int)dayNum formatter:(NSString *)formatter dateStringFormatter:(NSString *)dateStringFormatter {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    if (dateStringFormatter) {
        [dateFormatter setDateFormat:dateStringFormatter];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [self getDateStringByDate:date year:yearNum month:monthNum day:dayNum formatter:formatter];
}

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
+ (NSString *)getDateStringByDate:(NSDate *)date year:(int)yearNum month:(int)monthNum day:(int)dayNum formatter:(NSString *)formatter
{
    if (!date) {
        date = [NSDate date];
    }
    
    if (!yearNum) {
        yearNum = 0;
    }
    
    if (!monthNum) {
        monthNum = 0;
    }
    
    if (!dayNum) {
        dayNum = 0;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:yearNum];
    [adcomps setMonth:monthNum];
    [adcomps setDay:dayNum];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *newDate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
    if (newDate) {
        NSString *agoDateString =  [dateFormatter stringFromDate:newDate];
        return [self trimString:agoDateString];
    } else {
        
        return @"";
    }
}

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
+ (BOOL)isFirstLoadCurrentVersion
{
    return [self isFirstLoadCurrentVersionAndMenory:YES];
}

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
+ (BOOL)isFirstLoadCurrentVersionAndMenory:(BOOL)isMenory
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:@"isNoFirstRun"];
    
    if (!lastRunVersion) {
        // App第一次启动
        if (isMenory) {
            [defaults setObject:currentVersion forKey:@"isNoFirstRun"];
            [defaults synchronize];
        }
        return YES;
    } else if (![lastRunVersion isEqualToString:currentVersion]) {
        // App更新之后第一次启动
        if (isMenory) {
            [defaults setObject:currentVersion forKey:@"isNoFirstRun"];
            [defaults synchronize];
        }
        return YES;
    } else {
        return NO;
    }
}

/**
 程序首次安装
 
 @param isMenory 是否存储标志
 @return YES(首次安装)/NO(不是首次安装)
 */
+ (BOOL)isFirstInstallAppAndMenoryFlag:(BOOL)isMenory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstInstallFlag = [defaults objectForKey:@"isFirstInstall"];
    
    if (!firstInstallFlag || ![@"1" isEqualToString:firstInstallFlag]) {
        // App第一次安装
        if (isMenory) {
            [defaults setObject:@"1" forKey:@"isFirstInstall"];
            [defaults synchronize];
        }
        return YES;
    }
    return NO;
}

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
+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray *)colors andGradientType:(int)gradientType {
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, bounds.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bounds.size.width, 0.0);
            break;
        default:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bounds.size.width, 0.0);
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

/**
 更具指定颜色创建图片
 
 @param color color
 @return image
 */
+ (UIImage *)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  截图方法
 *
 *  @param screenView 需要截屏的view
 *
 *  @return 截屏后的image
 */
+ (UIImage *)screenshot:(UIView *)screenView
{
    CGSize size = screenView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [screenView.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

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
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    // 模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    // boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    //NSLog(@"boxSize:%i",boxSize);
    // 图像处理
    CGImageRef img = image.CGImage;
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    // 图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    // 像素缓存
    void *pixelBuffer;
    
    // 数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    // 宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    // 像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    // Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    // error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    // error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    // 颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    // 根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - 接URL地址
/**
 *  拼接URL地址
 *
 *  @param sourceURLString 原始URL地址
 *  @param argument 需要拼接参数
 *
 *  @return 拼接完成的地址
 */
+ (NSString*)getUrlWithSourceURLString:(NSString*)sourceURLString argument:(NSDictionary*)argument {
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:sourceURLString];
    
    BOOL isFirst = YES;
    if(sourceURLString && [argument isKindOfClass: [NSDictionary class]]){
        for (NSString *key in [argument allKeys]) {
            NSString *parameter = @"";
            if (isFirst) {
                parameter = [NSString stringWithFormat:@"?%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[argument objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                isFirst = NO;
            } else {
                parameter = [NSString stringWithFormat:@"&%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[argument objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            [urlString appendString:parameter];
        }
    }
    
    return urlString;
}

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
+ (NSString *)getPinyinFromChinese:(NSString *)chinese {
    NSMutableString *pinyin = [self chineseTransformPinyin:chinese];
    
    NSString *tempStr = [pinyin uppercaseString];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return tempStr;
}

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
+ (NSString *)getChinesePinyinFirstCharacter:(NSString *)chinese {
    NSMutableString *pinyin = [self chineseTransformPinyin:chinese];
    
    NSString *tempStr = [pinyin uppercaseString];
    NSArray *arr = [tempStr componentsSeparatedByString:@" "];
    NSMutableString *firstPinyin = [NSMutableString string];
    for (NSString *str in arr) {
        if (str.length > 0) {
            [firstPinyin appendString:[str substringToIndex:1]];
        }
    }
    
    return [firstPinyin uppercaseString];
}

/**
 汉子转化为拼音
 
 @param chinese chinese
 @return pinyin
 */
+ (NSMutableString *)chineseTransformPinyin:(NSString *)chinese {
    if (!chinese || chinese.length == 0) {
        return [@"" mutableCopy];
    }
    /*
     NSMutableString *pinyin = [chinese mutableCopy];
     
     CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, NO);
     // 去除音标
     CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
     */
    // 出于性能考虑，拼音转换改为第三方库
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSMutableString *pinyin = [[PinyinHelper toHanyuPinyinStringWithNSString:chinese withHanyuPinyinOutputFormat:outputFormat withNSString:@" "] mutableCopy];
    
    // 多音字处理 - 待完善
    if ([[chinese substringToIndex:1] compare:@"长"] == NSOrderedSame) {
        [pinyin replaceCharactersInRange:NSMakeRange(0, [pinyin rangeOfString:@" "].location) withString:@"chang"];
    } else if ([[chinese substringToIndex:1] compare:@"重"] == NSOrderedSame) {
        [pinyin replaceCharactersInRange:NSMakeRange(0, [pinyin rangeOfString:@" "].location) withString:@"chong"];
    } else if ([[chinese substringToIndex:1] compare:@"曾"] == NSOrderedSame) {
        [pinyin replaceCharactersInRange:NSMakeRange(0, [pinyin rangeOfString:@" "].location) withString:@"zeng"];
    }
    
    return pinyin;
}

#pragma mark - 根据身份证号码获取性别
/**
 根据身份证号码获取性别
 
 @param identityCard 身份证号码
 @return nil/男/女
 */
+ (NSString *)sexStringFromIdentityCard:(NSString *)identityCard {
    NSString *sexString = nil; // 性别
    NSString *sexNumberString = nil; // 身份证标志位
    
    if (identityCard.length == 18) {
        // 18位身份证 二代身份证
        sexNumberString  = [identityCard substringWithRange:NSMakeRange(16, 1)];
    } else if (identityCard.length == 15) {
        // 15位身份证 一代身份证
        sexNumberString = [identityCard substringWithRange:NSMakeRange(14, 1)];
    }
    
    if (!sexNumberString) {
        // 未获取到性别标志位
        return sexString;
    }
    
    // 数字检测
    BOOL isAllNumber = YES;
    const char *tempChar = [sexNumberString UTF8String];
    const char *p = tempChar;
    while (*p != '\0') {
        if(!(*p >= '0' && *p <= '9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber) {
        // 非数字
        return sexString;
    }
    
    NSInteger sexNumber = [sexNumberString integerValue];
    if (sexNumber%2 == 1) {
        sexString = @"男";
    } else {
        sexString = @"女";
    }
    
    return sexString;
}

@end
