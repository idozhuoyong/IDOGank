//
//  NSObject+IDOExtension.m
//  IDOGank
//
//  Created by 卓勇 on 2017/7/15.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "NSObject+IDOExtension.h"
#import <MJExtension/MJExtension.h>

@implementation NSObject (IDOExtension)

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self ido_replacedKeyFromPropertyName];
}

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)ido_replacedKeyFromPropertyName {
    return nil;
}

/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)ido_objectWithKeyValues:(id)keyValues
{
    return [self mj_objectWithKeyValues:keyValues];
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return [self ido_objectClassInArray];
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)ido_objectClassInArray {
    return nil;
}

/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @return 模型数组
 */
+ (NSMutableArray *)ido_objectArrayWithKeyValuesArray:(id)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}


@end
