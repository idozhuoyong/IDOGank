//
//  UIView+IDOUIView.h
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IDOUIView)

@property (nonatomic, assign) CGFloat ido_x;
@property (nonatomic, assign) CGFloat ido_y;
@property (nonatomic, assign) CGFloat ido_width;
@property (nonatomic, assign) CGFloat ido_height;
@property (nonatomic, assign) CGFloat ido_centerX;
@property (nonatomic, assign) CGFloat ido_centerY;

- (CGFloat)ido_MaxX;
- (CGFloat)ido_MaxY;


#pragma mark - 控制器
/**
 获取view所在ViewController
 
 @return ViewController
 */
- (UIViewController*)ido_viewController;

/**
 获取View所在的导航栏控制器
 
 @return UINavigationController
 */
- (UINavigationController *)ido_navigationController;

#pragma mark - 增加点击手势
/**
 增加点击手势
 
 @param target target
 @param action action
 */
- (void)ido_addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;


@end
