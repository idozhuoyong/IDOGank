//
//  IDOTodayModel.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/27.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDOTodayModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *publishedAt;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *used;
@property (nonatomic, copy) NSString *who;
@property (nonatomic, strong) NSArray *images;


@end
