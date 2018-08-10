//
//  IDOBaseViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOBaseViewController.h"

@interface IDOBaseViewController ()

@end

@implementation IDOBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor ido_RGBColorWithRed:239 green:239 blue:244];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor ido_HexColorWithHexString:@"0xD33E42"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [@{NSForegroundColorAttributeName:[UIColor whiteColor]} copy];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIImage *backImage = [UIImage ido_imageNamed:@"return_black"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:target action:action];
    return backItem;
}

#pragma mark - dealloc
- (void)dealloc {
    // 移除页面所有交易
    [IDONetworkServers removePageAllTransaction:KPageId(self)];
    
    // 移除页面通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // DebugLog
    KDebugLog(@"\n------ %@类被销毁了，PageId=%@", NSStringFromClass([self class]), KPageId(self));
}

@end
