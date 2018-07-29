//
//  IDOBussinessActivityIndicator.m
//  IDOGank
//
//  Created by 卓勇 on 2017/8/30.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOBussinessActivityIndicator.h"

#define KBackgroundViewColor [UIColor colorWithWhite:0.f alpha:.2f] // [UIColor clearColor]
#define KBezelViewBackgroundColor [UIColor colorWithRed:37.0/255.0 green:78.0/255.0 blue:147.0/255.0 alpha:0.8]
#define KContentColor [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f] // [UIColor whiteColor]

@interface IDOBussinessActivityIndicator ()

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) IDOBussinessCaller *caller;

@end

@implementation IDOBussinessActivityIndicator

- (void)showActivityIndicatorView:(IDOBussinessCaller *)caller {
    
    self.caller = caller;
    
    if (self.caller.isShowActivityIndicator) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:caller.activityWrapView animated:YES];
        self.progressHUD.removeFromSuperViewOnHide = YES;
        
        if ([@"" isEqualToString:self.caller.activityIndicatorText]) {
            // 活动指示器文字默认值
            if (self.caller.activityMode == IDOActivityModeCustomActivityView) {
                self.caller.activityIndicatorText = @"数据加载中...";
            } else {
                self.caller.activityIndicatorText = @"正在加载...";
            }
        }
        
        if (self.caller.activityMode == IDOActivityModeCanBackButCanNotCancel) {
            
            // 不遮蔽导航栏，但不能取消交易的模式
            /*
            self.progressHUD.frame = CGRectMake(0, KNavgationAndStateHeight, KUIScreenWidth, KUIScreenHeight - KNavgationAndStateHeight);
             
            // 背景
            self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.backgroundView.color = KBackgroundViewColor;

            // 蒙层
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = KBezelViewBackgroundColor;
            
            // 文字和指示器
            self.progressHUD.contentColor = KContentColor;
            self.progressHUD.label.text = self.caller.activityIndicatorText;
            */
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
            self.progressHUD.contentColor = [UIColor whiteColor];
            
        } else if (self.caller.activityMode == IDOActivityModeCanCancelButCanNotBack) {
            
            // 能取消交易，但遮蔽导航栏的模式
            /*
            // 蒙层
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = KBezelViewBackgroundColor;
            
            // 文字和指示器
            self.progressHUD.contentColor = KContentColor;
            self.progressHUD.label.text = self.caller.activityIndicatorText;
            
            // 取消按钮
            [self.progressHUD.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
            [self.progressHUD.button addTarget:self action:@selector(cancelTransaction:) forControlEvents:UIControlEventTouchUpInside];
            */
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
            self.progressHUD.contentColor = [UIColor whiteColor];
            
        } else if (self.caller.activityMode == IDOActivityModeCanBackAndCanCancel) {
            
            // 不遮蔽导航栏，且能取消交易的模式
            /*
            self.progressHUD.frame = CGRectMake(0, KNavgationAndStateHeight, KUIScreenWidth, KUIScreenHeight - KNavgationAndStateHeight);

            // 背景
            self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.backgroundView.color = KBackgroundViewColor;
            
            // 蒙层
            //self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            //self.progressHUD.bezelView.backgroundColor = KBezelViewBackgroundColor;
            
            // 文字和指示器
            self.progressHUD.contentColor = KContentColor;
            self.progressHUD.label.text = self.caller.activityIndicatorText;
            
            // 取消按钮
            [self.progressHUD.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
            [self.progressHUD.button addTarget:self action:@selector(cancelTransaction:) forControlEvents:UIControlEventTouchUpInside];
             */
            
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
            self.progressHUD.contentColor = [UIColor whiteColor];
            
        } else if (self.caller.activityMode == IDOActivityModeCanNotBackAndCanNotCancel) {
            
            // 不能取消交易，且遮蔽导航栏的模式
            /*
            // 背景
            self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.backgroundView.color = KBackgroundViewColor;

            // 蒙层
            //self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            //self.progressHUD.bezelView.backgroundColor = KBezelViewBackgroundColor;
            
            // 文字和指示器
            self.progressHUD.contentColor = KContentColor;
            self.progressHUD.label.text = self.caller.activityIndicatorText;
             */
            
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8];
            self.progressHUD.contentColor = [UIColor whiteColor];
            
        } else if (self.caller.activityMode == IDOActivityModeCustomActivityView) {
            
            // 为当前项目自定义的
            self.progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.backgroundView.color = KBackgroundViewColor;
            
            self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.progressHUD.bezelView.backgroundColor = [UIColor clearColor];
            
            self.progressHUD.contentColor = [UIColor colorWithRed:67/255.0 green:187/255.0 blue:194/255.0 alpha:1.0];
            self.progressHUD.label.text = self.caller.activityIndicatorText;
            self.progressHUD.label.font = [UIFont systemFontOfSize:14];
            
            self.progressHUD.mode = MBProgressHUDModeCustomView;
            
            // loading image view
            UIImage *loadingRotateingImage = [UIImage imageNamed:@"inset_loading_rotateing"];
            UIImageView *loadingRotateingImageView = [[UIImageView alloc] initWithImage:loadingRotateingImage];
            
            // 旋转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.fromValue = [NSNumber numberWithFloat:0];
            animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
            animation.duration = 1.0;
            animation.autoreverses = NO;
            //animation.cumulative = YES;
            animation.fillMode = kCAFillModeForwards;
            animation.repeatCount = MAXFLOAT;
            [loadingRotateingImageView.layer addAnimation:animation forKey:@"loading_rotateing"];
            
            // logo image view
            UIImage *loadingMyBankLogoImage = [UIImage imageNamed:@"inset_loading_mybank_logo"];
            UIImageView *loadingMyBankLogoImageView = [[UIImageView alloc] initWithImage:loadingMyBankLogoImage];
            loadingMyBankLogoImageView.layer.cornerRadius = loadingMyBankLogoImage.size.width / 2.0;
            loadingMyBankLogoImageView.layer.masksToBounds = YES;
            [loadingMyBankLogoImageView addSubview:loadingRotateingImageView];
            
            [self.progressHUD setCustomView:loadingMyBankLogoImageView];
        }
    }
}

- (void)hideAnimated {
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated {
    if (self.progressHUD) {
        [self.progressHUD hideAnimated:animated];
    }
}

#pragma mark - button click method
- (void)cancelTransaction:(UIButton *)button {
    // 取消交易
    if (self.bussinessCancelClickBlock) {
        self.bussinessCancelClickBlock(self.caller);
    }
    [self hideAnimated];
}

@end
