//
//  IDOTodayViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOTodayViewController.h"
#import "IDODetailViewController.h"
#import "IDOTodayCell.h"
#import "IDOTodayHeaderView.h"
#import "IDOTodayModel.h"
#import "IDOHistoryModel.h"

@interface IDOTodayViewController () <UITableViewDataSource, UITableViewDelegate, XLPhotoBrowserDatasource, XLPhotoBrowserDelegate>

@property (nonatomic, strong) UILabel * titleLabel; // 标题
@property (nonatomic, strong) UILabel * navTitleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *girlUrlString; // 妹子图

@end

@implementation IDOTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNav];
    [self initUI];
    
    if (self.jumpType == GankJumpTypeHistory) {
        // 历史干货

        // 标题
        self.titleLabel.text = [IDOCommonUtils trimString:self.historyModel.title];
        [self calculTitleLabelTextHeight];
        
        // 发布日期
        NSString *publishedDate = [IDOCommonUtils trimString:self.historyModel.publishedAt];
        NSArray *publishedArray = [publishedDate componentsSeparatedByString:@"T"];
        if (publishedArray.count > 0) {
            publishedDate = [IDOCommonUtils trimString:publishedArray[0]];
        }
        self.navTitleLabel.text = publishedDate;

        NSString *day = [publishedDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [self getDayData:day];

    } else {
        // 获取最新干货数据
        [self getTodayData];
    }
}

#pragma mark - init
- (void)initNav {
    @weakObj(self);
    
    if (self.jumpType == GankJumpTypeToday) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage ido_imageNamed:@"refresh_icon"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            @strongObj(self);
            [self getTodayData];
        }];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 28)];
    logoImageView.image = [UIImage ido_imageNamed:@"logo"];
    [navTitleView addSubview:logoImageView];
    
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 120, 16)];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel.font = [UIFont systemFontOfSize:12.f];
    //self.navTitleLabel.text = @"2018-07-26";
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
    //self.titleLabel.text = @"今日力推：全部干货";
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
    self.tableView.estimatedRowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 50;
    self.tableView.estimatedSectionFooterHeight = 50;
    self.tableView.showsVerticalScrollIndicator = NO;
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
    
    @weakObj(self);
    self.tableView.ly_emptyView = [IDOEmptyView defaultNoDataEmptyWithBtnClickBlock:^{
        @strongObj(self);
        
        if (self.jumpType == GankJumpTypeHistory) {
            NSString *publishedDate = [IDOCommonUtils trimString:self.historyModel.publishedAt];
            NSArray *publishedArray = [publishedDate componentsSeparatedByString:@"T"];
            if (publishedArray.count > 0) {
                publishedDate = [IDOCommonUtils trimString:publishedArray[0]];
            }
            NSString *day = [publishedDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            [self getDayData:day];
        } else {
            [self getTodayData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count > 0) {
        return self.dataArray.count + 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        NSArray *gankArray = [self.dataArray ido_safeObjectAtIndex:(section - 1)];
        return gankArray.count;
    }
    return 0;
}

static NSString * cellId = @"cellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDOTodayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[IDOTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *gankArray = [self.dataArray ido_safeObjectAtIndex:(indexPath.section - 1)];
    [cell setModel:[gankArray ido_safeObjectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return UITableViewAutomaticDimension;
    }
    return CGFLOAT_MIN;
}

static NSString * headerViewId = @"headerViewId";
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        IDOTodayHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        if (!headerView) {
            headerView = [[IDOTodayHeaderView alloc] initWithReuseIdentifier:headerViewId];
        }
        
        [headerView.girlImageView ido_setImageWithURL:[NSURL ido_URLWithString:self.girlUrlString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        @weakObj(self);
        [headerView.girlImageView bk_whenTapped:^{
            @strongObj(self);
            XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
            [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        }];
        
        return headerView;
    } else {
        UIView *titleView = [UIView new];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = [self.titleArray ido_safeObjectAtIndex:(section - 1)];
        // 设置中英文斜体
        //titleLabel.font = [UIFont italicSystemFontOfSize:18];
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(10 * M_PI/180.0), 1, 0, 0);
        UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:18].fontName matrix:matrix];
        titleLabel.font = [UIFont fontWithDescriptor:desc size:18];
        titleLabel.textColor = [UIColor lightGrayColor];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleView).mas_offset(10);
            make.left.mas_equalTo(titleView).mas_offset(15);
            make.right.mas_equalTo(titleView).mas_offset(-15);
            make.bottom.mas_equalTo(titleView).mas_offset(-10);
        }];
        
        return titleView;
    }
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

    NSArray *gankArray = [self.dataArray ido_safeObjectAtIndex:(indexPath.section - 1)];
    IDOTodayModel *model = [gankArray ido_safeObjectAtIndex:indexPath.row];
    
    IDODetailViewController *vc = [[IDODetailViewController alloc] init];
    vc.urlString = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL ido_URLWithString:self.girlUrlString];
}

#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex {
    [browser saveCurrentShowImage];
}

#pragma mark - 网络请求
/** 获取最新干货数据 */
- (void)getTodayData {
    
    @weakObj(self)
    
    // 获取历史数据
    [self getHistoryData];
    
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = @"today";
    caller.isShowActivityIndicator = YES;
    
    [self.tableView ly_startLoading];
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self)

        NSDictionary *results = [caller.responseObject objectForKey:@"results"];
        
        NSMutableArray *titleMutableArray = [NSMutableArray array];
        NSMutableArray *dataMutableArray = [NSMutableArray array];
        
        for (NSString *title in KContext.titleOrderArray) {
            if ([results.allKeys containsObject:title]) {
                [titleMutableArray addObject:title];
                [dataMutableArray addObject:results[title]];
            }
        }
        
        if ([results.allKeys containsObject:@"福利"]) {
            // 福利妹子图
            NSArray *tempArray = results[@"福利"];
            self.girlUrlString = [[tempArray ido_safeObjectAtIndex:0] objectForKey:@"url"];
        }
        
        self.titleArray = [titleMutableArray copy];
        self.dataArray = [IDOTodayModel ido_objectArrayWithKeyValuesArray:dataMutableArray];
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(IDOBussinessCaller *caller) {
        @strongObj(self)
        
        [self.tableView ly_endLoading];
    }];
}

/** 获取历史干货数据 */
- (void)getHistoryData {
    @weakObj(self);
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = @"history/content/1/1";
    caller.isShowActivityIndicator = NO;
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        NSArray *results = [caller.responseObject objectForKey:@"results"];
        NSArray *resultsModel = [[IDOHistoryModel ido_objectArrayWithKeyValuesArray:results] copy];
        
        if (resultsModel.count > 0) {
            IDOHistoryModel *model = resultsModel[0];
            
            // 标题
            self.titleLabel.text = [IDOCommonUtils trimString:model.title];
            [self calculTitleLabelTextHeight];
            
            // 发布日期
            NSString *publishedDate = [IDOCommonUtils trimString:model.publishedAt];
            NSArray *publishedArray = [publishedDate componentsSeparatedByString:@"T"];
            if (publishedArray.count > 0) {
                publishedDate = [IDOCommonUtils trimString:publishedArray[0]];
            }
            self.navTitleLabel.text = publishedDate;
        }
    } failure:^(IDOBussinessCaller *caller) {
        
    }];
}

/**
 获取指定日期干货数据

 @param day day 『day』格式『2018/08/09』
 */
- (void)getDayData:(NSString *)day {
    @weakObj(self);
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = [NSString stringWithFormat:@"day/%@", day];
    
    [self.tableView ly_startLoading];
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        NSDictionary *results = [caller.responseObject objectForKey:@"results"];
        
        NSMutableArray *titleMutableArray = [NSMutableArray array];
        NSMutableArray *dataMutableArray = [NSMutableArray array];
        
        for (NSString *title in KContext.titleOrderArray) {
            if ([results.allKeys containsObject:title]) {
                [titleMutableArray addObject:title];
                [dataMutableArray addObject:results[title]];
            }
        }
        
        if ([results.allKeys containsObject:@"福利"]) {
            // 福利妹子图
            NSArray *tempArray = results[@"福利"];
            self.girlUrlString = [[tempArray ido_safeObjectAtIndex:0] objectForKey:@"url"];
        }
        
        self.titleArray = [titleMutableArray copy];
        self.dataArray = [IDOTodayModel ido_objectArrayWithKeyValuesArray:dataMutableArray];
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        [self.tableView ly_endLoading];
    }];
}

#pragma mark - other method
/** 计算文字标题高度 */
- (void)calculTitleLabelTextHeight {
    CGFloat titleHeight = [self.titleLabel.text boundingRectWithSize:CGSizeMake(KUIScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.height;
    titleHeight = (titleHeight > 33) ? (titleHeight + 12) : (33);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(0);
            make.height.mas_equalTo(titleHeight);
        } else {
            make.top.left.right.mas_equalTo(self.view).mas_offset(0);
            make.height.mas_equalTo(titleHeight);
        }
    }];
}

@end
