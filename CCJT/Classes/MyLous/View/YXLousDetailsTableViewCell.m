//
//  YXLousDetailsTableViewCell.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousDetailsTableViewCell.h"

@implementation YXLousDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI
{
    self.itemLabel = [UILabel new];
    [self.contentView addSubview:self.itemLabel];
    self.itemLabel.textColor = kCommonTextColor;
    self.itemLabel.font = kFont16;
    YXWeakSelf(self);
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(16*kScale);
        make.centerY.mas_equalTo(weakSelf.contentView);
    }];
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textColor = kCommonTextColor;
    self.contentLabel.font = kFont16;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.itemLabel.mas_right).offset(5*kScale);
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(260*kScale);
//        make.right.mas_equalTo(weakSelf.contentView).offset(-20*kScale);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
