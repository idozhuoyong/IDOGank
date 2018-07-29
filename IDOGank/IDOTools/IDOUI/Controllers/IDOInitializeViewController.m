//
//  IDOInitializeViewController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOInitializeViewController.h"

@interface IDOInitializeViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation IDOInitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutUI];
}

#pragma mark - init
- (void)layoutUI {
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage ido_getLaunchImage];
    [self.view addSubview:_imageView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    _activityIndicatorView.center = CGPointMake(_imageView.center.x, _imageView.center.y - 20);
    [_activityIndicatorView startAnimating];
    [self.imageView addSubview:_activityIndicatorView];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _imageView.frame.size.width, 33)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.center = CGPointMake(_imageView.center.x, _imageView.center.y + 20);
    //_textLabel.text = @"程序正在加载，请稍后...";
    [self.imageView addSubview:_textLabel];
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
