//
//  UIImageView+IDOUIImageView.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/7.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "UIImageView+IDOUIImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (IDOUIImageView)

#pragma mark - (SDWebImage/UIImageView+WebCache.h)
- (void)ido_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
