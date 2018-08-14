//
//  IDOWelfareViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/14.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOWelfareViewController.h"
#import "IDOWelfareCell.h"
#import "IDOWelfareModel.h"

@interface IDOWelfareViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, XLPhotoBrowserDatasource, XLPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isPullRefresh;
@property (nonatomic, assign) int page;

@end

@implementation IDOWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNav];
    [self layoutUI];
    
    self.isPullRefresh = YES;
    self.page = 1;
    [self getWelfareData];
}

#pragma mark - init
- (void)layoutNav {
    self.title = @"萌妹子";
}

static NSString * cellId = @"cellId";
- (void)layoutUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[IDOWelfareCell class] forCellWithReuseIdentifier:cellId];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongObj(self);
        
        self.isPullRefresh = YES;
        self.page = 1;
        [self getWelfareData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongObj(self);
        
        self.isPullRefresh = NO;
        self.page = self.page + 1;
        [self getWelfareData];
    }];
    self.collectionView.mj_header.hidden = YES;
    self.collectionView.mj_footer.hidden = YES;
    
    self.collectionView.ly_emptyView = [IDOEmptyView defaultNoDataEmptyWithBtnClickBlock:^{
        @strongObj(self);
        
        self.isPullRefresh = YES;
        self.page = 1;
        [self getWelfareData];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IDOWelfareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setModel:self.dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 每个 item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KUIScreenWidth - 30) * 0.5, 211);
}

// 每个 item 的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// 每个 item 的垂直距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 每个 item 的水平距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:self.dataArray.count datasource:self];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
}

#pragma mark - XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    IDOWelfareModel *model = [self.dataArray ido_safeObjectAtIndex:index];
    return [NSURL ido_URLWithString:model.url];
}

#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex {
    [browser saveCurrentShowImage];
}

#pragma mark - 网络请求
/** 获取福利数据 */
- (void)getWelfareData {
    @weakObj(self);
    
    IDOBussinessCaller *caller = [IDONetworkServers createDefaultCallerWithWrapObj:self];
    caller.transactionId = [NSString stringWithFormat:@"data/福利/20/%d", self.page];
    if (self.isPullRefresh) {
        caller.isShowActivityIndicator = YES;
    } else {
        caller.isShowActivityIndicator = NO;
    }
    
    [self.collectionView ly_startLoading];
    [IDONetworkServers sendGETWithCaller:caller progress:nil success:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        NSArray *results = [caller.responseObject objectForKey:@"results"];
        if (self.isPullRefresh) {
            self.dataArray = [IDOWelfareModel ido_objectArrayWithKeyValuesArray:results];
        } else {
            [self.dataArray addObjectsFromArray:[IDOWelfareModel ido_objectArrayWithKeyValuesArray:results]];
        }
        
        
        if (self.isPullRefresh) {
            [self.collectionView.mj_header endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.collectionView reloadData];
        
        if (self.dataArray.count == 0) {
            self.collectionView.mj_header.hidden = YES;
            self.collectionView.mj_footer.hidden = YES;
        } else {
            self.collectionView.mj_header.hidden = NO;
            self.collectionView.mj_footer.hidden = NO;
        }
        
        [self.collectionView ly_endLoading];
    } failure:^(IDOBussinessCaller *caller) {
        @strongObj(self);
        
        if (self.isPullRefresh) {
            [self.collectionView.mj_header endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.collectionView reloadData];
        
        if (self.dataArray.count == 0) {
            self.collectionView.mj_header.hidden = YES;
            self.collectionView.mj_footer.hidden = YES;
        } else {
            self.collectionView.mj_header.hidden = NO;
            self.collectionView.mj_footer.hidden = NO;
        }
        
        [self.collectionView ly_endLoading];
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
