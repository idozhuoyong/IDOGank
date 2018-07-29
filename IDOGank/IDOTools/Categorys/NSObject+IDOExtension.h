//
//  NSObject+IDOExtension.h
//  jxbankMobileClient
//
//  Created by 卓勇 on 2017/7/15.
//  Copyright © 2017年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 对MJExtension进行简单封装，减少程序对MJExtension的依赖
 */
@interface NSObject (IDOExtension)

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)ido_replacedKeyFromPropertyName;

/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)ido_objectWithKeyValues:(id)keyValues;

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)ido_objectClassInArray;

/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @return 模型数组
 */
+ (NSMutableArray *)ido_objectArrayWithKeyValuesArray:(id)keyValuesArray;


@end
