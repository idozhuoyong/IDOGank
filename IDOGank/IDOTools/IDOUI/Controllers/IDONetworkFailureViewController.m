//
//  IDONetworkFailureViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDONetworkFailureViewController.h"

@interface IDONetworkFailureViewController ()

@property (nonatomic, strong) UILabel *wifiInfoLabel;
@property (nonatomic, strong) UIView *loadingBackgroundView;

@end

@implementation IDONetworkFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutUI];
}

#pragma mark - init
- (void)layoutUI {
    
    // wifi
    UIImage *networkErrImage = [UIImage ido_imageNamed:@"icon_network_err"];
    UIImageView *networkErrImageView = [[UIImageView alloc] initWithImage:networkErrImage];
    networkErrImageView.frame = CGRectMake((self.view.frame.size.width - networkErrImage.size.width) / 2.0, KScale(80), networkErrImage.size.width, networkErrImage.size.height);
    [self.view addSubview:networkErrImageView];
    
    // wifi failure info
    self.wifiInfoLabel = [[UILabel alloc] init];
    self.wifiInfoLabel.text = @"似乎已断开与互联网的连接。(-1009)";
    self.wifiInfoLabel.font = [UIFont systemFontOfSize:17];
    self.wifiInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.wifiInfoLabel.frame = CGRectMake(KScale(15), CGRectGetMaxY(networkErrImageView.frame) + KScale(40), self.view.frame.size.width - KScale(30), KScale(30));
    [self.view addSubview:self.wifiInfoLabel];
    
    // 温馨提示
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示：";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.frame = CGRectMake(KScale(15), self.view.center.y - KScale(15), self.view.frame.size.width - KScale(30), KScale(40));
    [self.view addSubview:titleLabel];
    // 提示内容
    NSString *infoString = @"1、请确保手机连接的WIFI或者运营商网络正常。如果正常，您可能关闭了“江西银行”的使用权限，请在设置中开启，点击“点此检查”按钮可前往设置。\n2、如果设置中找不到“无线局域网与蜂窝移动”，请重启手机后在尝试以上操作";
    NSMutableAttributedString *infoMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:infoString];
    NSMutableParagraphStyle *infoMutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [infoMutableParagraphStyle setLineSpacing:6];
    [infoMutableAttributedString addAttribute:NSParagraphStyleAttributeName value:infoMutableParagraphStyle range:NSMakeRange(0, [infoString length])];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - KScale(30), 10000)];
    infoLabel.attributedText = infoMutableAttributedString;
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor ido_HexColorWithHexString:@"0x333333"];
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];
    infoLabel.frame = CGRectMake(KScale(15), CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width - KScale(30), infoLabel.frame.size.height);
    [self.view addSubview:infoLabel];
    
    CGFloat width = (self.view.frame.size.width - KScale(30) - KScale(8)) / 2.0;
    // 点此检查按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setTitle:@"点此检查" forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor ido_RGBColorWithRed:16 green:117 blue:225] forState:UIControlStateNormal];
    checkButton.layer.cornerRadius = 8;
    checkButton.clipsToBounds = YES;
    checkButton.layer.borderWidth = 1;
    checkButton.layer.borderColor = [UIColor ido_RGBColorWithRed:16 green:117 blue:225].CGColor;
    [checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.frame = CGRectMake(KScale(15), CGRectGetMaxY(infoLabel.frame) + KScale(40), width, KScale(40));
    [self.view addSubview:checkButton];
    
    // 重新加载按钮
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadButton setBackgroundColor:[UIColor ido_RGBColorWithRed:16 green:117 blue:225]];
    reloadButton.layer.cornerRadius = 8;
    reloadButton.clipsToBounds = YES;
    [reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.frame = CGRectMake(CGRectGetMaxX(checkButton.frame) + KScale(8), CGRectGetMinY(checkButton.frame), width, CGRectGetHeight(checkButton.frame));
    [self.view addSubview:reloadButton];
}

#pragma mark - button click
- (void)checkButtonClick:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)reloadButtonClick:(UIButton *)sender {
    
    [self.view addSubview:self.loadingBackgroundView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.reloadButtonClickBlock) {
            self.reloadButtonClickBlock(self, sender);
        }
        
        [self.loadingBackgroundView removeFromSuperview];
        self.loadingBackgroundView = nil;
    });
}

#pragma mark - getter
- (UIView *)loadingBackgroundView {
    if (!_loadingBackgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
        
        UIActivityIndicatorView * activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activeView.frame = CGRectMake(0, 0, 60, 60);
        activeView.center = backgroundView.center;
        [activeView startAnimating];
        [backgroundView addSubview:activeView];
        
        _loadingBackgroundView = backgroundView;
    }
    
    return _loadingBackgroundView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
