//
//  NSURL+IDONSURL.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (IDONSURL)

/**
 字符串转『URL』地址
 
 @param URLString URLString
 @return 『URL』地址
 */
+ (nullable instancetype)ido_URLWithString:(NSString *_Nullable)URLString;

@end
