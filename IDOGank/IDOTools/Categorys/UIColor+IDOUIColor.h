//
//  UIColor+IDOUIColor.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IDOUIColor)

#pragma mark - RGB颜色
+ (UIColor *)ido_RGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)ido_RGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

#pragma mark - HEX颜色
+ (UIColor *)ido_HexColorWithHexString:(NSString *)color;

+ (UIColor *)ido_HexColorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
