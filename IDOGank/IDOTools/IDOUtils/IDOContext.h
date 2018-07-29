//
//  IDOContext.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  存放全局数据
 */
@interface IDOContext : NSObject

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;

+ (instancetype)sharedInstance;

@end
