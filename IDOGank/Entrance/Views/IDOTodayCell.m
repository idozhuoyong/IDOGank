//
//  IDOTodayCell.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/27.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOTodayCell.h"

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
    self.demoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.demoImageView];
    
    // 分类
    self.classifyLabel = [[UILabel alloc] init];
}

@end
