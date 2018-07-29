//
//  UIImage+IDOUIImage.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "UIImage+IDOUIImage.h"

@implementation UIImage (IDOUIImage)

/**
 获取启动图片
 */
+ (instancetype)ido_getLaunchImage {
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    CGSize viewSize = currentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImageName];
}

/**
 改变图片颜色
 
 @param color color
 @return image
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 获取图片

 @param imageName 图片名称
 @return UIImage
 */
+ (UIImage *)ido_imageNamed:(NSString *)imageName {
    return [self ido_imageNamed:imageName imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 获取图片

 @param imageName 图片名称
 @param renderingMode renderingMode
 @return UIImage
 */
+ (UIImage *)ido_imageNamed:(NSString *)imageName imageWithRenderingMode:(UIImageRenderingMode)renderingMode {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:renderingMode];
}

@end
