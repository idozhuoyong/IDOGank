//
//  IDODetailViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/10.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDODetailViewController.h"
#import "IDOWKWebView.h"

@interface IDODetailViewController ()

@property (nonatomic, strong) IDOWKWebView *webView;

@end

@implementation IDODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNav];
    [self layoutUI];
}

#pragma mark - init
- (void)layoutNav {
    @weakObj(self);
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"return_black"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongObj(self);
        if (self.webView.webView.canGoBack) {
            [self.webView.webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"关闭" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongObj(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItems = @[backBarButton, closeBarButton];
}

- (void)layoutUI {
    @weakObj(self);
    self.webView = [[IDOWKWebView alloc] init];
    [self.webView loadRequestWithString:self.urlString];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(0);
        } else {
            make.left.top.right.bottom.mas_equalTo(self.view).mas_offset(0);
        }
    }];
    
    
    self.webView.webViewTitleUpdateBlock = ^(WKWebView *webView, NSString *titleString) {
        @strongObj(self);
        if (titleString.length > 15) {
            titleString = [NSString stringWithFormat:@"%@...", [titleString substringToIndex:8]];
        }
        self.title = titleString;
    };
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
