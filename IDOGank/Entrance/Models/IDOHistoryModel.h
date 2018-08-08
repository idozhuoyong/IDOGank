//
//  IDOHistoryModel.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/8.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDOHistoryModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *publishedAt;
@property (nonatomic, copy) NSString *rand_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) NSArray *imageArray;

@end
