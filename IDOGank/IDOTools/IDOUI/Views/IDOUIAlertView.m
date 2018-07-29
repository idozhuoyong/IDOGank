//
//  IDOUIAlertView.m
//  IDOUIAlertView
//
//  Created by 卓勇 on 2017/3/29.
//  Copyright © 2017年 idozhuoyong. All rights reserved.
//

#import "IDOUIAlertView.h"

const static CGFloat kIDOAlertViewDefaultButtonHeight       = 44;   // 默认按钮高度
const static CGFloat kIDOAlertViewDefaultButtonSpacerHeight = 1;    // 默认按钮分割线高度
const static CGFloat kIDOAlertViewDefaultButtonSpacerWidth  = 0.5;  // 默认按钮分割线宽度
const static CGFloat kIDOAlertViewCornerRadius              = 8;    // 默认圆角半径

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;
CGFloat buttonSpacerWidth = 0;

#ifndef KRGBColor
    #define KRGBColor(R, G, B)       [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#endif
#ifndef KRGBPColor
    #define KRGBPColor(R, G, B, P)   [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:P]
#endif
#ifndef KHEXColor
    #define KHEXColor(HEX)           [UIColor colorWithRed:((float)((HEX & 0xFF0000) >> 16))/255.0 green:((float)((HEX & 0xFF00) >> 8))/255.0 blue:((float)(HEX & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef KUIScreenWidth
    #define KUIScreenWidth [UIScreen mainScreen].bounds.size.width
#endif
#ifndef KUIScreenHeight
    #define KUIScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
#ifndef KUIScreenScale
    #define KUIScreenScale (KUIScreenWidth / 375.0)
#endif
#ifndef KScale
    #define KScale(width) ((width) * KUIScreenScale)
#endif

#ifndef KStatusBarHeight
    #define KStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 0 ? [[UIApplication sharedApplication] statusBarFrame].size.height : 20) // 20
#endif

@interface IDOUIAlertView ()

@property (nonatomic, copy) NSString *alertManagerKeyString;


@end

@implementation IDOUIAlertView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.closeOnTouchUpOutside = NO;
        
        // 必须调用此方法, 设备旋转监听才有效
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        // 设备旋转
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        // 键盘出现
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        // 键盘消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (instancetype)initWithtitle:(NSString *)titleString info:(NSString *)infoString buttonTitles:(NSArray *)buttonTitles {
    
    return [self initWithtitle:titleString info:infoString buttonTitles:buttonTitles infoTextAlignment:NSTextAlignmentCenter];
}

- (instancetype)initWithtitle:(NSString *)titleString info:(NSString *)infoString buttonTitles:(NSArray *)buttonTitles infoTextAlignment:(NSTextAlignment)textAlignment {
    self = [self init];
    
    if (self) {
        CGFloat margin = KScale(15);
        CGFloat width = [self countScreenSize].width - margin*2;
        CGFloat height = [self countScreenSize].height - kIDOAlertViewDefaultButtonHeight - KStatusBarHeight*2;
        
        // 标题
        UIFont *titleLabelFont = [UIFont boldSystemFontOfSize:20];
        CGSize titleSize = [titleString boundingRectWithSize:CGSizeMake(width - margin*2, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabelFont} context:nil].size;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, width - margin*2, titleSize.height)];
        titleLabel.text = titleString;
        titleLabel.numberOfLines = 0;
        titleLabel.font = titleLabelFont;
        titleLabel.textColor = KRGBColor(85, 85, 85);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 标题下面的线条
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(margin/2.0, CGRectGetMaxY(titleLabel.frame) + margin/2.0, width - margin, 1.0f)];
        lineView.backgroundColor = KRGBColor(234, 234, 234);
        
        // 展示的信息
        UIScrollView *infoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(lineView.frame) + margin, width - margin*2, 0)];
        
        UIFont *infoLabelFont = [UIFont systemFontOfSize:16];
        CGFloat tempInfoLabelHeight = [self getSpaceLabelHeight:infoString withFont:infoLabelFont allWidth:width - margin*2 lineSpace:6 allHeight:INT_MAX - CGRectGetMaxY(lineView.frame)];
        CGFloat infoLabelHeight = KScale(60);
        if (infoLabelHeight < tempInfoLabelHeight) {
            infoLabelHeight = tempInfoLabelHeight;
        }
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(infoScrollView.frame), infoLabelHeight)];
        infoLabel.numberOfLines = 0;
        infoLabel.font = infoLabelFont;
        infoLabel.textColor = KRGBColor(98, 98, 98);
        [self setLabelSpace:infoLabel withValue:infoString withFont:infoLabelFont lineSpace:6 textAlignment:textAlignment];
        [infoScrollView addSubview:infoLabel];
        
        CGFloat infoScrollViewHeight = CGRectGetHeight(infoLabel.frame);
        CGFloat tempHeight = infoScrollView.frame.origin.y + infoScrollViewHeight;
        if (tempHeight > height) {
            infoScrollView.frame = CGRectMake(infoScrollView.frame.origin.x, infoScrollView.frame.origin.y, infoScrollView.frame.size.width, height - infoScrollView.frame.origin.y);
            infoScrollView.contentSize = CGSizeMake(infoScrollView.frame.size.width, infoScrollViewHeight);
        } else {
            infoScrollView.frame = CGRectMake(infoScrollView.frame.origin.x, infoScrollView.frame.origin.y, infoScrollView.frame.size.width, infoScrollViewHeight);
            infoScrollView.contentSize = CGSizeMake(infoScrollView.frame.size.width, infoScrollViewHeight);
        }
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, CGRectGetMaxY(infoScrollView.frame))];
        [backgroundView addSubview:titleLabel];
        [backgroundView addSubview:lineView];
        [backgroundView addSubview:infoScrollView];
        [self setContainerView:backgroundView];
        
        [self setButtonTitles:buttonTitles];
        
        // 计算alertManagerKeyString
        NSMutableString *keyString = [[NSMutableString alloc] initWithFormat:@"%@%@", titleString, infoString];
        for (NSString *buttonTitleString in buttonTitles) {
            [keyString appendString:buttonTitleString];
        }
        self.alertManagerKeyString = [IDODeviceInfo md5:keyString];
    }
    return self;
}

// 给UILabel设置行间距和字间距
- (void)setLabelSpace:(UILabel*)label withValue:(NSString*)infoString withFont:(UIFont*)font lineSpace:(CGFloat)lineSpace textAlignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    // 设置字间距 NSKernAttributeName:@1.5f
    //NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:infoString attributes:dic];
    label.attributedText = attributeStr;
}

// 计算UILabel的高度(带有行间距的情况)
- (CGFloat)getSpaceLabelHeight:(NSString*)infoString withFont:(UIFont*)font allWidth:(CGFloat)allWidth lineSpace:(CGFloat)lineSpace allHeight:(CGFloat)allHeight {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [infoString boundingRectWithSize:CGSizeMake(allWidth, allHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - show
- (void)show {
    // 重复弹框处理
    [[IDOUIAlertManager sharedInstance] showAlertViewWithKeyString:self.alertManagerKeyString valueAlertView:self];

    // 显示弹框
    self.dialogView = [self createContainerView];
    
    // layer光栅化，提高性能
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:self.dialogView];
    
    // iOS7, 计算与调整位置
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } else {
        // other, 计算位置
        CGSize screenSize = [self countScreenSize];
        CGSize dialogSize = [self countDialogSize];
        CGSize keyboardSize = CGSizeMake(0, 0);
        
        self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
        
    }
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    // 动画效果和背景色
    // 动画效果和背景色
    self.dialogView.layer.opacity = 0.5f;
    self.dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        self.dialogView.layer.opacity = 1.0f;
        self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - close
- (void)close {
    // 重复弹框处理
    [[IDOUIAlertManager sharedInstance] closeAlertViewWithKeyString:self.alertManagerKeyString];

    // 关闭弹框
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self.dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
        self.dialogView.layer.opacity = 0.0f;
        
    } completion:^(BOOL finished) {
        
        for (UIView *subView in [self subviews]) {
            [subView removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - touches
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.closeOnTouchUpOutside == YES) {
        // 点击背景关闭视图
        UITouch *touch = [touches anyObject];
        if ([touch.view isKindOfClass:[IDOUIAlertView class]]) {
            [self close];
        }
    }
}

#pragma mark - notification observe
/**
 设备旋转

 @param notification notification
 */
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS7, 设备方向改变
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CGAffineTransform rotation;
        
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
                break;
                
            default:
                rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
                break;
        }
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.dialogView.transform = rotation;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        // other, 设备方向改变
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            CGSize dialogSize = [self countDialogSize];
            CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
            self.dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 键盘出现
 
 @param notification notification
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

/**
 键盘消失
 
 @param notification notification
 */
- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

#pragma mark - button click
- (void)closeButtonClick:(UIButton *)button {
    if (self.onButtonClickHandle) {
        self.onButtonClickHandle(self, button.tag);
    } else {
        [self close];
    }
}

#pragma mark - other
- (UIView *)createContainerView {
    if (!self.containerView) {
       // 创建默认容器视图
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    // 黑色背景
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // 对话框容器视图
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // 对话框容器视图样式
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kIDOAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    // 按钮上方的分割线
    //UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    //lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    //[dialogContainer addSubview:lineView];
    
    // 增加自定义的容器视图
    [dialogContainer addSubview:self.containerView];
    
    // 增加按钮
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

- (void)addButtonsToView: (UIView *)container {
    if (!self.buttonTitles || self.buttonTitles.count == 0) {
        // 没有按钮
        return;
    }
    
    // 按钮宽度
    /*
    CGFloat buttonWidth = container.bounds.size.width / [self.buttonTitles count];

    for (int i = 0; i < [self.buttonTitles count]; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [closeButton.layer setCornerRadius:kIDOAlertViewCornerRadius];
        [container addSubview:closeButton];
        
        if (i > 0) {
            // 按钮分隔线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonSpacerWidth, buttonHeight)];
            lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
            [container addSubview:lineView];
        }
    }
    */
    
    CGFloat buttonWidth = (container.bounds.size.width - (KScale(15)*2 + KScale(8) * (self.buttonTitles.count-1))) / [self.buttonTitles count];

    for (int i = 0; i < [self.buttonTitles count]; i++) {

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(i * buttonWidth + KScale(15)+KScale(8)*i, container.bounds.size.height - buttonHeight - KScale(15), buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        closeButton.layer.cornerRadius = 3.f;
        closeButton.layer.masksToBounds = YES;
        
        if ([self.buttonTitles count] > 1) {
            if (i%2 == 0) {
                [closeButton setBackgroundColor:KHEXColor(0xffffff)];
                [closeButton setTitleColor:KHEXColor(0x0372f1) forState:UIControlStateNormal];
                closeButton.layer.borderColor = KHEXColor(0x0372f1).CGColor;
                closeButton.layer.borderWidth = 1.f;
                closeButton.layer.cornerRadius = 3.f;
                closeButton.layer.masksToBounds = YES;
            } else {
                [closeButton setBackgroundColor:KHEXColor(0x0372f1)];
                [closeButton setTitleColor:KHEXColor(0xffffff) forState:UIControlStateNormal];
            }
        } else {
            // 只有一个
            [closeButton setBackgroundColor:KHEXColor(0x0372f1)];
            [closeButton setTitleColor:KHEXColor(0xffffff) forState:UIControlStateNormal];
        }
        
        [container addSubview:closeButton];
    }
}

#pragma mark - helper
/**
 得到对话框容器的size

 @return size
 */
- (CGSize)countDialogSize {
    CGFloat dialogWidth = self.containerView.frame.size.width;
    CGFloat dialogHeight = self.containerView.frame.size.height + buttonHeight + buttonSpacerHeight + KScale(30);
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

/**
 得到屏幕的size

 @return size
 */
- (CGSize)countScreenSize {
    
    if (self.buttonTitles && [self.buttonTitles count] > 0) {
        buttonHeight       = kIDOAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kIDOAlertViewDefaultButtonSpacerHeight;
        buttonSpacerWidth  = kIDOAlertViewDefaultButtonSpacerWidth;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
        buttonSpacerWidth = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // iOS7, 屏幕的宽高不会随着方向自动调整
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end


/********************************** IDOUIAlertManager **********************************************/
@interface IDOUIAlertManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, IDOUIAlertView *> *alertMuDictionary;

@end

@implementation IDOUIAlertManager

#pragma mark - 单例类
+ (instancetype)sharedInstance {
    
    static IDOUIAlertManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.alertMuDictionary = [NSMutableDictionary dictionary];
    });
    
    return sharedInstance;
}

#pragma mark - 弹框重复添加处理
/**
 弹框重复添加处理

 @param keyString keyString
 @param valueAlertView valueAlertView
 */
- (void)showAlertViewWithKeyString:(NSString *)keyString valueAlertView:(IDOUIAlertView *)valueAlertView {
    keyString = [IDOCommonUtils trimString:keyString];
    
    if ([@"" isEqualToString:keyString]) {
        // keyString为空 不处理
        return;
    }
    
    // 重复弹框处理
    {
        IDOUIAlertView *alertView = [self.alertMuDictionary objectForKey:keyString];
        if ([IDOCommonUtils trimNilObj:alertView]) {
            [alertView close];
        }
        [self.alertMuDictionary setObject:valueAlertView forKey:keyString];
    }
    
    // 同时包含超时类型、互踢类型处理
    {
        // 互踢
        NSString *key1 = [IDOCommonUtils trimString:[IDODeviceInfo md5:@"温馨提示您的账号已在其它电子渠道登录，故您已被强制退出确定"]];
        // 会话超时
        NSString *key2 = [IDOCommonUtils trimString:[IDODeviceInfo md5:@"温馨提示会话已超时确定"]];
        
        // 同时包含超时类型、互踢类型 - 移除会话超时
        IDOUIAlertView *alertView1 = [self.alertMuDictionary objectForKey:key1]; // 互踢
        IDOUIAlertView *alertView2 = [self.alertMuDictionary objectForKey:key2]; // 会话超时
        if ([IDOCommonUtils trimNilObj:alertView1] && [IDOCommonUtils trimNilObj:alertView2]) {
            [alertView2 close];
        }
    }
}

#pragma mark - 弹框移除处理
/**
 弹框移除处理

 @param keyString keyString
 */
- (void)closeAlertViewWithKeyString:(NSString *)keyString {
    keyString = [IDOCommonUtils trimString:keyString];
    if (![@"" isEqualToString:keyString]) {
        [self.alertMuDictionary removeObjectForKey:keyString];
    }
}

@end
