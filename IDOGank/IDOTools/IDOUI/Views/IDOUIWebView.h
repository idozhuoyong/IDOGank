//
//  IDOUIWebView.h
//  IDOGank
//
//  Created by 卓勇 on 2017/9/8.
//  Copyright © 2017年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif


@interface IDOUIWebView : UIView

/** 标题更新回调 */
@property (nonatomic, copy) void(^webViewTitleUpdateBlock)(UIWebView *webView, NSString *titleString);

/** 导航栏更新回调 */
@property (nonatomic, copy) void(^webViewNavItemUpdateBlock)(UIWebView *webView, BOOL isNeedUpdate, BOOL isHasCloseBtn);

/** 是否进行UTF8进行编码，默认YES(使用UTF8编码) */
@property (nonatomic, assign) BOOL isUsingUTF8Encoding;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewDelegate;

#pragma mark - public method
- (void)loadRequestWithString:(NSString *)urlString;

@end
