//
//  IDOTodayHeaderView.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/30.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOTodayHeaderView.h"

@implementation IDOTodayHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.clipsToBounds = YES;
    
    self.girlImageView = [[UIImageView alloc] init];
    self.girlImageView.userInteractionEnabled = YES;
    self.girlImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.girlImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.girlImageView];
    
    [self.girlImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(self.contentView).mas_offset(0).priorityLow();
    }];
}

@end
