//
//  IDOBussinessActivityIndicator.h
//  IDOGank
//
//  Created by 卓勇 on 2017/8/30.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDOBussiness.h"
#import <MBProgressHUD.h>

typedef void(^BussinessCancelClickBlock)(IDOBussinessCaller *caller);

@interface IDOBussinessActivityIndicator : NSObject

@property (nonatomic, copy) BussinessCancelClickBlock bussinessCancelClickBlock;

- (void)showActivityIndicatorView:(IDOBussinessCaller *)caller;

- (void)hideAnimated;

- (void)hideAnimated:(BOOL)animated;

@end
