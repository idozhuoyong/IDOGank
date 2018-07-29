//
//  UIImage+IDOUIImage.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IDOUIImage)

/**
 获取启动图片
 */
+ (instancetype)ido_getLaunchImage;

/**
 改变图片颜色
 
 @param color color
 @return image
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 获取图片
 
 @param imageName 图片名称
 @return UIImage
 */
+ (UIImage *)ido_imageNamed:(NSString *)imageName;

/**
 获取图片
 
 @param imageName 图片名称
 @param renderingMode renderingMode
 @return UIImage
 */
+ (UIImage *)ido_imageNamed:(NSString *)imageName imageWithRenderingMode:(UIImageRenderingMode)renderingMode;

@end
