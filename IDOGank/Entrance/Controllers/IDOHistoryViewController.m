//
//  IDOHistoryViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOHistoryViewController.h"
#import "IDOTodayViewController.h"
#import "IDOHistoryCell.h"
#import "IDOHistoryModel.h"

@interface IDOHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isPullRefresh;
@property (nonatomic, assign) int page;

@end

@implementation IDOHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
    
    self.isPullRefresh = YES;
    self.page = 1;
    
    [self getHistoryData];
}

#pragma mark - init
- (void)initNav {
    self.title = @"历史的车轮";
}

- (void)initUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(0);
        } else {
            make.top.left.right.bottom.mas_equalTo(self.view).mas_offset(0);
        }
    }];
    
    @weakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongObj(self);
        
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = YES;
        self.isPullRefresh = YES;
        self.page = 1;
        
        [self getHistoryData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongObj(self);
        
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = NO;
        self.isPullRefresh = NO;
        self.page = self.page + 1;
        
        [self getHistoryData];
    }];
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.ly_emptyView = [IDOEmptyView defaultNoDataEmptyWithBtnClickBlock:^{
        @strongObj(self);
        
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        self.isPullRefresh = YES;
        self.page = 1;
        
        [self getHistoryData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

static NSString * cellId = @"cellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDOHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[IDOHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell setModel:self.dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDOTodayViewController *vc = [[IDOTodayViewController alloc] init];
    vc.jumpType = GankJumpTypeHistory;
    vc.historyModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
/** 获取历史干货数据 */
- (void)getHistoryData {
    @weakObj(self);
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = [NSString stringWithFormat:@"history/content/20/%d", self.page];
    if (self.isPullRefresh) {
        caller.isShowActivityIndicator = YES;
    } else {
        caller.isShowActivityIndicator = NO;
    }
    
    [self.tableView ly_startLoading];
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        NSArray *results = [caller.responseObject objectForKey:@"results"];
        if (self.isPullRefresh) {
            // 下拉刷新
             self.dataArray = [[IDOHistoryModel ido_objectArrayWithKeyValuesArray:results] mutableCopy];
        } else {
            // 上拉加载
            [self.dataArray addObjectsFromArray:[IDOHistoryModel ido_objectArrayWithKeyValuesArray:results]];
        }
        
        if (self.isPullRefresh) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        
        if (self.dataArray.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_header.hidden = NO;
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView ly_endLoading];
    } failure:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        if (self.isPullRefresh) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        
        if (self.dataArray.count == 0) {
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_header.hidden = NO;
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView ly_endLoading];
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
