//
//  UIImageView+IDOUIImageView.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/7.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (IDOUIImageView)

#pragma mark - (SDWebImage/UIImageView+WebCache.h)
- (void)ido_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;

@end
