//
//  IDOEmptyView.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/9.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOEmptyView.h"

@implementation IDOEmptyView

+ (instancetype)defaultNoDataEmptyWithBtnClickBlock:(LYActionTapBlock)btnClickBlock {
    IDOEmptyView *emptyView = [IDOEmptyView emptyActionViewWithImageStr:@"nodata"
                                                               titleStr:@"暂无数据"
                                                              detailStr:@"请检查你的网络连接是否正确!"
                                                            btnTitleStr:@"重新加载"
                                                          btnClickBlock:btnClickBlock];
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    emptyView.autoShowEmptyView = NO;
    return emptyView;
}

+ (instancetype)createCustomEmptyViewWith {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    return [IDOEmptyView emptyViewWithCustomView:customView];
}

@end
