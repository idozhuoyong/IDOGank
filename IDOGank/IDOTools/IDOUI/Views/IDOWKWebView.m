//
//  IDOWKWebView.m
//  IDOGank
//
//  Created by 卓勇 on 2017/6/22.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import "IDOWKWebView.h"

@interface IDOWKWebView ()

/** 导航栏是否有关闭按钮，默认无(NO) */
@property (nonatomic, assign) BOOL isHasCloseBtn;

@end

@implementation IDOWKWebView

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
    self.progressView.frame = CGRectMake(0.f, 0.f, self.webView.frame.size.width, 2.f);
}

#pragma mark - common init
- (void)commonInit {
    
    self.isUsingUTF8Encoding = YES;
    self.isHasCloseBtn = NO;
    
    if (!self.webView) {
        // 防止多次初始化
        self.webView = [[WKWebView alloc] init];
        [self addSubview:self.webView];
        
        // 进度条
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        // 标题
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.progressView) {
        // 防止多次初始化
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.trackTintColor=[UIColor clearColor];
        self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.progressView setProgress:0 animated:NO];
        [self.webView addSubview:self.progressView];
    }
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
        if (KIOS_VERSION_9_OR_ABOVE) {
            // >= iOS9
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlString]]];
        } else {
            // iOS8下 WKWebView是不允许通过loadRequest的方法来加载本地根目录的HTML文件
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:urlString]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self.webView loadRequest:request];
        }
    }
}

#pragma mark - observe value change
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([object isEqual:self.webView]) {
            
            CGFloat progressValue =  [change[NSKeyValueChangeNewKey] doubleValue];
            if (progressValue >= 1.f) {
                
                [self.progressView setProgress:0.f animated:NO];
            } else {
                
                [self.progressView setProgress:progressValue animated:YES];
            }
            
        } else {
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if([keyPath isEqualToString:@"title"]) {
        if ([object isEqual:self.webView]) {
            // 网页标题
            if (self.webViewTitleUpdateBlock) {
                NSString *webViewTitleString = self.webView.title;
                self.webViewTitleUpdateBlock(self.webView, webViewTitleString);
                //NSLog(@"webViewTitleString: %@", webViewTitleString);
            }

            // 导航栏
            if (self.webViewNavItemUpdateBlock) {
                if ([self.webView canGoBack]) {

                    if (self.isHasCloseBtn == NO) {

                        self.isHasCloseBtn = YES;
                        self.webViewNavItemUpdateBlock(self.webView, YES/* 需要更新导航 */, self.isHasCloseBtn /* 导航为有关闭按钮状态 */);
                    } else {

                        self.webViewNavItemUpdateBlock(self.webView, NO/* 不需要更新导航 */, self.isHasCloseBtn /* 导航为有关闭按钮状态 */);
                    }

                } else {

                    if (self.isHasCloseBtn == YES) {

                        self.isHasCloseBtn = NO;
                        self.webViewNavItemUpdateBlock(self.webView, YES/* 需要更新导航 */, self.isHasCloseBtn /* 导航为无关闭按钮状态 */);
                    } else {

                        self.webViewNavItemUpdateBlock(self.webView, NO/* 不需要更新导航 */, self.isHasCloseBtn /* 导航为无关闭按钮状态 */);
                    }
                }
            }

        } else {

            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - other
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    
    // Create "/temp/WKWebViewTemp" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"WKWebViewTemp"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

#pragma mark - dealloc
- (void)dealloc {
    @try {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
    } @catch (NSException *exception) {
        NSLog(@"多次删除kvo 报错了");
    } @finally {
        
    }
    
}

@end
