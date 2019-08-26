//
//  IDOHistoryCell.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/7/30.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOHistoryCell.h"
#import "IDOHistoryModel.h"

@interface IDOHistoryCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 发布日期 */
@property (nonatomic, strong) UILabel *dateLabel;
/** imageView容器视图 */
@property (nonatomic, strong) UIView *imageSuperView;
/** imageView */
@property (nonatomic, strong) NSMutableArray *imageViewArray;
/** share按钮 */
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation IDOHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self laytoutUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)laytoutUI {
    // 标题
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    // 图片
    self.imageSuperView = [UIView new];
    self.imageSuperView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageSuperView];
    
    self.imageViewArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.hidden = YES;
        [self.imageSuperView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
    
    // 发布日期
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:12.f];
    self.dateLabel.textColor = [UIColor ido_HexColorWithHexString:@"0xAEAEAE"];
    [self.contentView addSubview:self.dateLabel];
    
    // 分享
    self.shareButton = [UIButton new];
    self.shareButton.tintColor = [UIColor ido_HexColorWithHexString:@"0xAEAEAE"];
    [self.shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.shareButton];
    
    // make constraints
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
    }];
    
    [self.imageSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.height.mas_equalTo(75);
    }];
    
    CGFloat imageWidth = (KUIScreenWidth - 35)/3;
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView *imageView = self.imageViewArray[i];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageSuperView).mas_offset((imageWidth + 5) * i);
            make.top.bottom.equalTo(self.imageSuperView);
            make.width.mas_equalTo(imageWidth);
        }];
    }
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageSuperView.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageSuperView.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.shareButton.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-5);
    }];
}

- (void)setModel:(IDOHistoryModel *)model {
    // 标题
    self.titleLabel.text = [IDOCommonUtils trimString:model.title];
    
    // 图片
    for (UIImageView * imageView in self.imageViewArray) {
        imageView.hidden = YES;
    }
    for (int i = 0; i < model.imageArray.count; i++) {
        UIImageView *imageView = [self.imageViewArray ido_safeObjectAtIndex:i];
        if (imageView) {
            imageView.hidden = NO;
            [imageView ido_setImageWithURL:[NSURL ido_URLWithString:model.imageArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
    }
    
    // 发布日期
    NSString *publishedDate = [IDOCommonUtils trimString:model.publishedAt];
    NSArray *publishedArray = [publishedDate componentsSeparatedByString:@"T"];
    if (publishedArray.count > 0) {
        publishedDate = [IDOCommonUtils trimString:publishedArray[0]];
    }
    self.dateLabel.text = [NSString stringWithFormat:@"发布日期：%@", publishedDate];
}

@end
