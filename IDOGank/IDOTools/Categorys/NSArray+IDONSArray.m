//
//  NSArray+IDONSArray.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/27.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "NSArray+IDONSArray.h"

@implementation NSArray (IDONSArray)

/**
 获取数组中数据

 @param index index
 @return id
 */
- (id)ido_safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
