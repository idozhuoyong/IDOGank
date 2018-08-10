//
//  IDOUIWebView.m
//  IDOGank
//
//  Created by 卓勇 on 2017/9/8.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOUIWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface IDOUIWebView () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

/** 导航栏是否有关闭按钮，默认无(NO) */
@property (nonatomic, assign) BOOL isHasCloseBtn;

@end

@implementation IDOUIWebView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.webView.frame = self.bounds;
    _progressView.frame = CGRectMake(0.f, 0.f, self.webView.ido_width, 2.f);
}

#pragma mark - common init
- (void)commonInit {

    self.isHasCloseBtn = NO;
    self.isUsingUTF8Encoding = YES;

    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    [self addSubview:self.webView];

    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    self.webView.delegate = _progressProxy;
    
    self.progressView = [[NJKWebViewProgressView alloc] init];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.webView addSubview:self.progressView];
}

#pragma mark - public method
- (void)loadRequestWithString:(NSString *)urlString {
    if (!urlString || urlString.length <= 0) {
        return;
    }
    
    if (self.isUsingUTF8Encoding == YES) {
        // 进行UTF8编码
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        KDebugLog(@"%@", urlString);
    }

    if ([urlString hasPrefix:@"http"]) {
        
        // 加载网络文件
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    } else {
        
        // 加载本地文件
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlString]]];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL ret = YES;
    if ([_webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 网页标题
    if (self.webViewTitleUpdateBlock) {
        NSString *webViewTitleString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.webViewTitleUpdateBlock(webView, webViewTitleString);
        //NSLog(@"webViewTitleString: %@", webViewTitleString);
    }
    
    // 导航栏
    if (self.webViewNavItemUpdateBlock) {
        if ([webView canGoBack]) {
            
            if (self.isHasCloseBtn == NO) {
                
                self.isHasCloseBtn = YES;
                self.webViewNavItemUpdateBlock(webView, YES/* 需要更新导航 */, self.isHasCloseBtn /* 导航为有关闭按钮状态 */);
            } else {
                
                self.webViewNavItemUpdateBlock(webView, NO/* 不需要更新导航 */, self.isHasCloseBtn /* 导航为有关闭按钮状态 */);
            }
        
        } else {
            
            if (self.isHasCloseBtn == YES) {
                
                self.isHasCloseBtn = NO;
                self.webViewNavItemUpdateBlock(webView, YES/* 需要更新导航 */, self.isHasCloseBtn /* 导航为无关闭按钮状态 */);
            } else {
                
                self.webViewNavItemUpdateBlock(webView, NO/* 不需要更新导航 */, self.isHasCloseBtn /* 导航为无关闭按钮状态 */);
            }
        }
    }
    
    if ([_webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewDelegate webView:webView didFailLoadWithError:error];
    }
}


@end
