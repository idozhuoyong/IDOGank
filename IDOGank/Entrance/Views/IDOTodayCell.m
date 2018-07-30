//
//  IDOTodayCell.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/27.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOTodayCell.h"
#import "IDOTodayModel.h"

@interface IDOTodayCell ()

@property(strong, nonatomic) UILabel * titleLabel;//标题
@property(strong, nonatomic) UIImageView * demoImageView;//demo图片
@property(strong, nonatomic) UILabel * classifyLabel;//分类

@end

@implementation IDOTodayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [self.contentView addSubview:self.titleLabel];
    
    // 图片
    self.demoImageView = [[UIImageView alloc] init];
    self.demoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.demoImageView];
    
    // 分类
    self.classifyLabel = [[UILabel alloc] init];
    self.classifyLabel.textColor = [UIColor ido_HexColorWithHexString:@"0xAEAEAE"];
    self.classifyLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self.contentView addSubview:self.classifyLabel];
    
    //
    [self.demoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-15).priorityLow();
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
        make.height.mas_lessThanOrEqualTo(80);
    }];

    [self.classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-15);
        make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
        make.height.mas_equalTo(14);
    }];
}

- (void)setModel:(IDOTodayModel *)model {
    // 标题
    self.titleLabel.text = [IDOCommonUtils trimString:model.desc];
    
    // 类型
    self.classifyLabel.text = [NSString stringWithFormat:@"%@ by  %@", [IDOCommonUtils trimString:model.type], [IDOCommonUtils trimString:model.who]];
    
    // 图片
    if (model.images.count > 0) {
        
    }
    
    // 缓存文字高度
    if (model.descTextHeight == 0) {
        // 计算文字高度，并缓存
        model.descTextHeight = [self.titleLabel.text boundingRectWithSize:CGSizeMake(KUIScreenWidth - 150, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19.f]} context:nil].size.height;
    }
    
    //
    if (model.images.count > 0) {
        if (model.descTextHeight <= 80) {
            [self.demoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(15);
                make.right.mas_equalTo(self.contentView).mas_offset(-15);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(80);
                make.bottom.mas_equalTo(self.contentView).mas_offset(-15).priorityLow();
            }];
            
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(15);
                make.left.mas_equalTo(self.contentView).mas_offset(15);
                make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
                make.height.mas_lessThanOrEqualTo(80);
            }];
            
            [self.classifyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(15);
                make.bottom.mas_equalTo(self.contentView).mas_offset(-15);
                make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
                make.height.mas_equalTo(14);
            }];
        } else {
            [self.demoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(15);
                make.right.mas_equalTo(self.contentView).mas_offset(-15);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(80);
                make.bottom.mas_equalTo(self.contentView).mas_offset(-15).priorityLow();
            }];
            
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).mas_offset(15);
                make.left.mas_equalTo(self.contentView).mas_offset(15);
                make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
                make.bottom.mas_equalTo(self.classifyLabel.mas_top).mas_offset(-5);
            }];
            
            [self.classifyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(15);
                make.bottom.mas_equalTo(self.contentView).mas_offset(-15);
                make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
                make.height.mas_equalTo(14);
            }];
        }
    } else {
        [self.demoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(0);
            make.right.mas_equalTo(self.contentView).mas_offset(0);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.contentView).mas_offset(0).priorityLow();
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(15);
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
            make.bottom.mas_equalTo(self.classifyLabel.mas_top).mas_offset(-5);
        }];
        
        [self.classifyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-15);
            make.right.mas_equalTo(self.demoImageView.mas_left).mas_offset(-15);
            make.height.mas_equalTo(14);
        }];
    }
}

@end
