//
//  IDOUITabBarController.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/25.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOUITabBarController.h"
#import "IDOUINavigationController.h"

#import "IDOTodayViewController.h"
#import "IDOHistoryViewController.h"
#import "IDOWelfareViewController.h"

#define TabBarVC            @"TabBarVC"
#define TabBarTitle         @"TabBarTitle"
#define TabBarImage         @"TabBarImage"
#define TabBarSelectedImage @"TabBarSelectedImage"

@interface IDOUITabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSArray *tabBarItems;

@end

@implementation IDOUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化控制器
    [self loadViewControllers];
    
    self.delegate = self;
}

#pragma mark - init method
- (void)loadViewControllers {
    @weakObj(self)
    [self.tabBarItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongObj(self)
        
        NSDictionary *item = (NSDictionary *)obj;
        
        NSString *tabBarVC              = [item objectForKey:TabBarVC];
        NSString *tabBarTitle           = [item objectForKey:TabBarTitle];
        NSString *tabBarImage           = [item objectForKey:TabBarImage];
        NSString *tabBarSelectedImage   = [item objectForKey:TabBarSelectedImage];
        
        IDOBaseViewController *vc = [[NSClassFromString(tabBarVC) alloc] init];
        vc.navigationItem.title = tabBarTitle;
        IDOUINavigationController *nav = [[IDOUINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarTitle image:[UIImage imageNamed:tabBarImage] selectedImage:[UIImage imageNamed:tabBarSelectedImage]];
        nav.tabBarItem = tabBarItem;
        
        [self addChildViewController:nav];
        
        if (idx == 0) {
            self.currentViewController = nav;
        }
    }];
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor ido_HexColorWithHexString:@"0xD33E42"];
}

#pragma mark - setter and getter method
- (NSArray *)tabBarItems {
    
    if ([_tabBarItems count] <= 0) {
        NSArray *tabBarItems = @[
                                 @{
                                     TabBarVC:              NSStringFromClass([IDOTodayViewController class]),
                                     TabBarTitle:           @"最新",
                                     TabBarImage:           @"in_love_icon",
                                     TabBarSelectedImage:   @"in_love_icon",
                                     },
                                 @{
                                     TabBarVC:              NSStringFromClass([IDOHistoryViewController class]),
                                     TabBarTitle:           @"历史",
                                     TabBarImage:           @"crazy_icon",
                                     TabBarSelectedImage:   @"crazy_icon",
                                     },
                                 @{
                                     TabBarVC:              NSStringFromClass([IDOWelfareViewController class]),
                                     TabBarTitle:           @"萌妹子",
                                     TabBarImage:           @"in_love_icon",
                                     TabBarSelectedImage:   @"in_love_icon",
                                     }
                                 ];
        _tabBarItems = tabBarItems;
    }
    
    return _tabBarItems;
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.currentViewController]) {
        return NO;
    } else {
        self.currentViewController = viewController;
        return YES;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}


@end
