//
//  IDORepeatTrsHandler.m
//  IDOGank
//
//  Created by 卓勇 on 2017/12/8.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDORepeatTrsHandler.h"

#define KRepeatTrsInfoFileName      @"KRepeatTrsInfoFileName.data"          // 重复交易信息

@interface IDORepeatTrsHandler ()

@end

@implementation IDORepeatTrsHandler

MJCodingImplementation

/**
 重复交易处理

 @param caller caller
 @return IDORepeatTrsHandler
 */
+ (IDORepeatTrsHandler *)repeatTrsHandler:(IDOBussinessCaller *)caller {

    IDORepeatTrsHandler *trsInfoModel = [[IDORepeatTrsHandler alloc] init];
    
    NSArray *transactionIdDataArray = [IDORepeatTrsHandler transactionIdDataArray];
    if (![transactionIdDataArray containsObject:caller.transactionId]) {
        // 不需要判断重复交易
        trsInfoModel.isNeedCheckRepeatTrs = NO;
        
        return trsInfoModel;
    }
    
    // 对参数进行处理(处理成 @[@{@"key":@"", @"value":@""}] 形式，数组根据key进行升序排序)
    NSMutableDictionary *dict = [caller.transactionParameters mutableCopy];
    
    NSMutableDictionary *keyValueDict = [[NSMutableDictionary alloc] init];
    for (NSString *key in dict) {
        if ([key isEqualToString:@"Signature"]) {
            continue;
        }
        if ([key isEqualToString:@"_dataMap"] && [[dict objectForKey:@"_dataMap"] isKindOfClass:[NSDictionary class]]) {
            for (NSString *keyObj in [dict objectForKey:@"_dataMap"]) {
                if ([[[dict objectForKey:@"_dataMap"] objectForKey:keyObj] isKindOfClass:[NSString class]] ||
                    [[[dict objectForKey:@"_dataMap"] objectForKey:keyObj] isKindOfClass:[NSNumber class]] ||
                    [[[dict objectForKey:@"_dataMap"] objectForKey:keyObj] isKindOfClass:[NSValue class]]) {
                    
                    if ([keyObj isEqualToString:@"Signature"]) {
                        continue;
                    }
                    
                    [keyValueDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:keyObj, @"key", [[[dict objectForKey:@"_dataMap"] objectForKey:keyObj] description], @"value", nil] forKey:keyObj];
                }
            }
        } else {
            if ([[dict objectForKey:key] isKindOfClass:[NSString class]] ||
                [[dict objectForKey:key] isKindOfClass:[NSNumber class]] ||
                [[dict objectForKey:key] isKindOfClass:[NSValue class]]) {
                
                [keyValueDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", [dict objectForKey:key], @"value", nil] forKey:key];
            }
        }
    }
    
    NSMutableArray *keyValueArray = [[NSMutableArray alloc] init];
    for (NSString *keyObject in keyValueDict) {
        [keyValueArray addObject:[keyValueDict objectForKey:keyObject]];
    }
    
    [keyValueArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj1 objectForKey:@"key"] compare:[obj2 objectForKey:@"key"]];
    }];
    
    NSMutableString *valueString = [[NSMutableString alloc] init]; // value值
    
    for (int i = 0; i < keyValueArray.count; i++) {
        // 去除不能校验字段
        if ([@"test" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] || // 后台用的测试字段
            [@"TrsPassword" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] || // 密码
            [@"DynamicPassword" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] || // 短信验证码
            [@"OTPPassword" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] ||// 动态令牌码
            [@"_tokenName" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] || // 防重复提交
            [@"_JnlNo" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] || // 流水号
            [@"availbal" isEqualToString:[[keyValueArray objectAtIndex:i] objectForKey:@"key"]] // 可用余额
            ) {
            continue;
        }
        
        [valueString appendString:[[[keyValueArray objectAtIndex:i] objectForKey:@"value"] description]];
    }
    
    // 判断重复交易
    // 解档
    NSString *cachePathString = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:KRepeatTrsInfoFileName];

    NSDictionary *repeatTrsInfoDict = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:cachePathString]];

    NSString *currentMd5String = [IDOCommonUtils trimString:[IDODeviceInfo md5:valueString]]; // md5
    NSDate *currentDate = [NSDate date];

    IDORepeatTrsHandler *dataModel = [repeatTrsInfoDict objectForKey:caller.transactionId];
    if ([IDOCommonUtils trimNilObj:dataModel] != nil) {

        // 计算时间差
        NSCalendar *calender = [NSCalendar currentCalendar]; // 日历对象
        NSCalendarUnit unit = NSCalendarUnitMinute; // 获得一个时间元素
        NSInteger minuteDiff = [calender components:unit fromDate:dataModel.trsDate toDate:currentDate options:kNilOptions].minute;

        if (minuteDiff <= 5 &&
            ![@"" isEqualToString:[IDOCommonUtils trimString:currentMd5String]] &&
            [[IDOCommonUtils trimString:currentMd5String] isEqualToString:dataModel.trsParametersMd5])
        {
            // 重复交易
            trsInfoModel.isNeedCheckRepeatTrs = YES;
            trsInfoModel.isRepeatTrs = YES;
            trsInfoModel.transactionId = caller.transactionId; // 交易ID
            trsInfoModel.trsDate = currentDate;
            trsInfoModel.trsParametersMd5 = currentMd5String;
            return trsInfoModel;
        }
    }

    // 非重复交易
    trsInfoModel.isNeedCheckRepeatTrs = YES;
    trsInfoModel.isRepeatTrs = NO;
    trsInfoModel.transactionId = caller.transactionId; // 交易ID
    trsInfoModel.trsDate = currentDate;
    trsInfoModel.trsParametersMd5 = currentMd5String;

    return trsInfoModel;
}

/**
 把交易信息写入文件中

 @param trsDataModel trsDataModel
 */
+ (void)saveRepeatTrsInfo:(IDORepeatTrsHandler *)trsDataModel {
    if (!trsDataModel || !trsDataModel.transactionId || trsDataModel.transactionId.length == 0) {
        return;
    }
    // 更新存储时间 - 重复交易时，选择停留比较久时，需要更新时间
    trsDataModel.trsDate = [NSDate date];

    NSString *cachePathString = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:KRepeatTrsInfoFileName];
    
    // 解档
    NSMutableDictionary *repeatTrsInfoMuDict = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:cachePathString]];
    if (!repeatTrsInfoMuDict) {
        repeatTrsInfoMuDict = [NSMutableDictionary dictionary];
    }
    // 更新配置信息
    [repeatTrsInfoMuDict setObject:trsDataModel forKey:trsDataModel.transactionId];

    // 归档
    [NSKeyedArchiver archiveRootObject:repeatTrsInfoMuDict toFile:cachePathString];
}

/**
 需要判断重复交易的交易名
 */
+ (NSArray *)transactionIdDataArray {
    return [@[
              // 转账
              /*
              OtherTransfer, // 他行转账
              InnerTransfer, // 本行转账
              MobileTransfer, // 通讯录转账
               */
              ] copy];
}


@end
