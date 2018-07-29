//
//  UIView+IDOUIView.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/24.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "UIView+IDOUIView.h"

@implementation UIView (IDOUIView)

- (CGFloat)ido_x {
    return self.frame.origin.x;
}

- (void)setIdo_x:(CGFloat)ido_x {
    CGRect tempRect = self.frame;
    tempRect.origin.x = ido_x;
    self.frame = tempRect;
}

- (CGFloat)ido_y {
    return self.frame.origin.y;
}

- (void)setIdo_y:(CGFloat)ido_y {
    CGRect tempRect = self.frame;
    tempRect.origin.y = ido_y;
    self.frame = tempRect;
}

- (CGFloat)ido_width {
    return self.frame.size.width;
}

- (void)setIdo_width:(CGFloat)ido_width {
    CGRect tempRect = self.frame;
    tempRect.size.width = ido_width;
    self.frame = tempRect;
}

- (CGFloat)ido_height {
    return self.frame.size.height;
}

- (void)setIdo_height:(CGFloat)ido_height {
    CGRect tempRect = self.frame;
    tempRect.size.height = ido_height;
    self.frame = tempRect;
}

- (CGFloat)ido_centerX {
    return self.center.x;
}

- (void)setIdo_centerX:(CGFloat)ido_centerX {
    CGPoint center = self.center;
    center.y = ido_centerX;
    self.center = center;
}

- (CGFloat)ido_centerY {
    return self.center.y;
}

- (void)setIdo_centerY:(CGFloat)ido_centerY {
    CGPoint center = self.center;
    center.y = ido_centerY;
    self.center = center;
}

- (CGFloat)ido_MaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)ido_MaxY {
    return CGRectGetMaxY(self.frame);
}

#pragma mark - 控制器
/**
 获取view所在ViewController
 
 @return ViewController
 */
- (UIViewController*)ido_viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/**
 获取View所在的导航栏控制器
 
 @return UINavigationController
 */
- (UINavigationController *)ido_navigationController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 增加点击手势
/**
 增加点击手势
 
 @param target target
 @param action action
 */
- (void)ido_addTapGestureRecognizerWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
