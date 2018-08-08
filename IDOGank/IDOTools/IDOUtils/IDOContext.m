//
//  IDOContext.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOContext.h"

@implementation IDOContext

+ (instancetype)sharedInstance {
    
    static IDOContext *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.titleOrderArray = [@[
                                  @"iOS", @"Android", @"前端", @"拓展资源", @"瞎推荐",
                                  @"App", @"休息视频"
                                  ] copy];
        
    }
    return self;
}

@end
