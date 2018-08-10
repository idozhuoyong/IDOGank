//
//  IDOHistoryDetailViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/10.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOHistoryDetailViewController.h"

@interface IDOHistoryDetailViewController ()

@end

@implementation IDOHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - 获取指定日期数据
- (void)getSpecifyDateData {
    @weakObj(self);
    
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = @"today";
    caller.isShowActivityIndicator = YES;
    
    [self.tableView ly_startLoading];
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self)
        
    } failure:^(IDOBussinessCaller *caller) {
        @strongObj(self)
        
    }];

    
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
