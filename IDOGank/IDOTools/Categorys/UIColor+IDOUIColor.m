//
//  UIColor+IDOUIColor.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "UIColor+IDOUIColor.h"

@implementation UIColor (IDOUIColor)

#pragma mark - RGB颜色
+ (UIColor *)ido_RGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self ido_RGBColorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)ido_RGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

#pragma mark - HEX颜色
+ (UIColor *)ido_HexColorWithHexString:(NSString *)color {
    return [self ido_HexColorWithHexString:color alpha:1.0];
}

+ (UIColor *)ido_HexColorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    
    color = [color uppercaseString];
    
    // 删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0x"] || [cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if (cString.length != 6 && cString.length != 3) {
        return [UIColor clearColor];
    }
    
    if (cString.length == 3) {
        NSString *rTString = [cString substringWithRange:NSMakeRange(0, 1)];
        NSString *gTString = [cString substringWithRange:NSMakeRange(1, 1)];
        NSString *bTString = [cString substringWithRange:NSMakeRange(2, 1)];
        cString = [NSString stringWithFormat:@"%@%@%@%@%@%@", rTString, rTString, gTString, gTString, bTString, bTString];
    }
    
    // r
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    
    // g
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    
    // b
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
