//
//  NSArray+IDONSArray.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/27.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IDONSArray)

/**
 获取数组中数据
 
 @param index index
 @return id
 */
- (id)ido_safeObjectAtIndex:(NSUInteger)index;

@end
