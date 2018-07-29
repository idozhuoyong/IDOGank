//
//  IDONetworkFailureViewController.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IDONetworkFailureViewController;

typedef void(^ReloadButtonClickBlock)(IDONetworkFailureViewController *vc, UIButton *button);

@interface IDONetworkFailureViewController : UIViewController

@property (nonatomic, copy) ReloadButtonClickBlock reloadButtonClickBlock;

@end
