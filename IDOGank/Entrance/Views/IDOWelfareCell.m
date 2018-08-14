//
//  IDOWelfareCell.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/14.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOWelfareCell.h"
#import "IDOWelfareModel.h"

@interface IDOWelfareCell ()

@property (nonatomic, strong) UIImageView *welfareImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IDOWelfareCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    // 福利图
    self.welfareImageView = [[UIImageView alloc] init];
    self.welfareImageView.clipsToBounds = YES;
    self.welfareImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.welfareImageView];
    
    // 上传者名称
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor ido_HexColorWithHexString:@"0xAEAEAE"];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.titleLabel];
    
    //
    [self.welfareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView).mas_offset(0);
        make.height.mas_equalTo(170);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.welfareImageView.mas_bottom).mas_offset(-5);
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
    }];
}

- (void)setModel:(IDOWelfareModel *)model {
    
    [self.welfareImageView ido_setImageWithURL:[NSURL ido_URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = [IDOCommonUtils trimString:model.who];
}

@end
