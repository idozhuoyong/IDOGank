//
//  IDOWKWebView.h
//  IDOGank
//
//  Created by 卓勇 on 2017/6/22.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface IDOWKWebView : UIView

/** 标题更新回调 */
@property (nonatomic, copy) void(^webViewTitleUpdateBlock)(WKWebView *webView, NSString *titleString);

/** 导航栏更新回调 */
@property (nonatomic, copy) void(^webViewNavItemUpdateBlock)(WKWebView *webView, BOOL isNeedUpdate, BOOL isHasCloseBtn);

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

/** 是否进行UTF8进行编码，默认YES(使用UTF8编码) */
@property (nonatomic, assign) BOOL isUsingUTF8Encoding;

#pragma mark - public method
- (void)loadRequestWithString:(NSString *)urlString;

@end
