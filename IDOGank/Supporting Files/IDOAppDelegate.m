//
//  IDOAppDelegate.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/6.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOAppDelegate.h"
#import <IQKeyboardManager.h>
#import "IDONetworkCheck.h"
#import "IDODeviceInfo.h"

#import "IDONetworkFailureViewController.h"
#import "IDOUITabBarController.h"

@interface IDOAppDelegate ()

@end

@implementation IDOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if (![[IDONetworkCheck sharedInstance] isExistenceNetworkByUrl:SERVER_URL]) {
        // 网络有问题
        @weakObj(self)
        IDONetworkFailureViewController *vc = [[IDONetworkFailureViewController alloc] init];
        vc.reloadButtonClickBlock = ^(IDONetworkFailureViewController *vc, UIButton *button) {
            @strongObj(self)
            if ([[IDONetworkCheck sharedInstance] isExistenceNetworkByUrl:SERVER_URL]) {
                // 网络正常
                [self applicationLaunching];
            }
        };
        self.window.rootViewController = vc;
    } else {
        // 网络正常
        [self applicationLaunching];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - application launching
- (void)applicationLaunching {
    // 键盘管理
    IQKeyboardManager *keyboardManger = [IQKeyboardManager sharedManager];
    keyboardManger.enable = YES; // 整个功能是否启用
    keyboardManger.shouldResignOnTouchOutside = YES; // 点击背景是否收起键盘
    [keyboardManger setToolbarManageBehaviour:IQAutoToolbarByPosition]; // 工具条的创建方式
    keyboardManger.shouldShowToolbarPlaceholder = NO; // 是否显示TextFieldPlaceholder
    keyboardManger.previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
    
    // 缓存公网IP
    [IDODeviceInfo getPublicIPAddress];
    
    // 网络监听
    [[IDONetworkCheck sharedInstance] listeningNetworkState];
    [[IDONetworkCheck sharedInstance] setReachabilityStatusChangeBlock:^(IDONetworkStatus status) {
        switch (status) {
            case IDONotReachable: {
                KDebugLog(@"不可达的网络(未连接)");
                [IDOProjectUtils showUpInfoWithMessage:@"网络连接已断开..."];
            }
                break;
            case IDOReachableViaWWAN: {
                KDebugLog(@"2G,3G,4G...的网络");
            }
                break;
            case IDOReachableViaWiFi: {
                 KDebugLog(@"wifi的网络");
            }
                break;
        }
    }];
    
    //
    IDOUITabBarController *tabBarVC = [[IDOUITabBarController alloc] init];
    self.window.rootViewController = tabBarVC;

    KContext.window = self.window;
    KContext.rootViewController = self.window.rootViewController;
}


@end
