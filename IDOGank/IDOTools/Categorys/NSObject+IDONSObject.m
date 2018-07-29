//
//  NSObject+IDONSObject.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/20.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "NSObject+IDONSObject.h"

@implementation NSObject (IDONSObject)

#pragma mark - 转化为json格式字符串
/**
 *  转化为json格式字符串
 */
- (NSString *)ido_toJsonString {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
    //SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    //NSString *jsonString = [jsonWriter stringWithObject:self];
    //return jsonString;
}


@end
