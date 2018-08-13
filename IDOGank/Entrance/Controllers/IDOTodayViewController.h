//
//  IDOTodayViewController.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOBaseViewController.h"

@class IDOHistoryModel;

typedef enum : NSUInteger {
    GankJumpTypeToday, // 最新干货
    GankJumpTypeHistory, // 历史干货
} GankJumpType;

/**
 最新干货
 */
@interface IDOTodayViewController : IDOBaseViewController

@property (nonatomic, assign) GankJumpType jumpType;
@property (nonatomic, strong) IDOHistoryModel *historyModel;

@end
