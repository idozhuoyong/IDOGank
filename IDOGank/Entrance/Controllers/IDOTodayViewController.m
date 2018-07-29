//
//  IDOTodayViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOTodayViewController.h"
#import "IDOTodayCell.h"
#import "IDOTodayModel.h"

@interface IDOTodayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel * titleLabel; // 标题
@property (nonatomic, strong) UILabel * navTitleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation IDOTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNav];
    [self initUI];
    
    // 获取最新干货数据
    [self getTodayData];
}

#pragma mark - init
- (void)initNav {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage ido_imageNamed:@"refresh_icon"] style:UIBarButtonItemStyleDone handler:^(id sender) {}];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 28)];
    logoImageView.image = [UIImage ido_imageNamed:@"logo"];
    [navTitleView addSubview:logoImageView];
    
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 120, 16)];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel.font = [UIFont systemFontOfSize:12.f];
    self.navTitleLabel.text = @"2018-07-26";
    [navTitleView addSubview:self.navTitleLabel];
    self.navigationItem.titleView = navTitleView;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor ido_HexColorWithHexString:@"0xD7E9F7"];
    self.titleLabel.textColor = [UIColor ido_HexColorWithHexString:@"0x61ABD4"];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.text = @"今日力推：全部干货";
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.mas_equalTo(33);
        } else {
            make.top.left.right.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo(33);
        }
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.titleLabel.mas_safeAreaLayoutGuideBottom).offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
            make.left.right.bottom.mas_equalTo(self.view).offset(0);
        }
    }];

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    footer.stateLabel.numberOfLines = 0;
    footer.stateLabel.textColor = [UIColor ido_HexColorWithHexString:@"0xAEAEAE"];
    [footer setTitle:@"感谢所有默默付出的编辑们\n愿大家有美好一天" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *gankArray = [self.dataArray ido_safeObjectAtIndex:section];
    return gankArray.count;
}

static NSString * cellId = @"cellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDOTodayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[IDOTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - 网络请求
/** 获取最新干货数据 */
- (void)getTodayData {
    @weakObj(self)
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = @"today";
    caller.isShowActivityIndicator = NO;
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self)

        NSDictionary *results = [caller.responseObject objectForKey:@"results"];
        
        NSMutableArray *contentMutableArray = [NSMutableArray array];
        
        if ([results.allKeys containsObject:@"iOS"]) {
            [contentMutableArray addObject:results[@"iOS"]];
        }
        
        if ([results.allKeys containsObject:@"Android"]) {
            [contentMutableArray addObject:results[@"Android"]];
        }
        
        if ([results.allKeys containsObject:@"前端"]) {
            [contentMutableArray addObject:results[@"前端"]];
        }
        
        if ([results.allKeys containsObject:@"拓展资源"]) {
            [contentMutableArray addObject:results[@"拓展资源"]];
        }
        
        if ([results.allKeys containsObject:@"瞎推荐"]) {
            [contentMutableArray addObject:results[@"瞎推荐"]];
        }
        
        if ([results.allKeys containsObject:@"App"]) {
            [contentMutableArray addObject:results[@"App"]];
        }
        
        if ([results.allKeys containsObject:@"休息视频"]) {
            [contentMutableArray addObject:results[@"休息视频"]];
        }
        
        if ([results.allKeys containsObject:@"福利"]) {
            [contentMutableArray addObject:results[@"福利"]];
        }
        
        self.dataArray = [IDOTodayModel ido_objectArrayWithKeyValuesArray:contentMutableArray];
        [self.tableView reloadData];
        
    } failure:^(IDOBussinessCaller *caller) {
        
    }];

}

@end
