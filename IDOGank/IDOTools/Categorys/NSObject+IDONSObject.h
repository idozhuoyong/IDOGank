//
//  NSObject+IDONSObject.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IDONSObject)

#pragma mark - 转化为json格式字符串
/**
 *  转化为json格式字符串
 */
- (NSString *)ido_toJsonString;

@end
