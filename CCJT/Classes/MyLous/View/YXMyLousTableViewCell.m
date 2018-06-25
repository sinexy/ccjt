//
//  YXMyLousTableViewCell.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXMyLousTableViewCell.h"

@implementation YXMyLousTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIView *backView = [UIView new];
    backView.frame = CGRectMake(15*kScale, 9*kScale, YXScreenW-30*kScale, 76*kScale);
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5*kScale;
    backView.layer.shadowColor = kCommonColor.CGColor;
    backView.layer.shadowOffset = CGSizeMake(0, 1);
    backView.layer.shadowOpacity = 0.3f;

    [self.contentView addSubview:backView];
    YXWeakSelf(self);
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.contentView).offset(15*kScale);
//        make.right.mas_equalTo(weakSelf.contentView).offset(-15*kScale);
//        make.top.mas_equalTo(weakSelf.contentView).offset(11*kScale);
//        make.height.mas_equalTo(76*kScale);
//    }];
    
    self.name = [UILabel new];
    self.name.textColor = YXRGB(243, 150, 38);
    self.name.font = kFont20;
    [backView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView).offset(14*kScale);
        make.centerY.mas_equalTo(backView);
    }];
    self.name.text = @"";
    
    self.money = [UILabel new];
    self.money.textColor = kCommonTextColor;
    self.money.font = kFont20;
    [backView addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(130*kScale);
        make.top.mas_equalTo(backView).offset(13*kScale);
    }];
    self.money.text = @"";
    
    self.date = [UILabel new];
    self.date.textColor = kCommonTextColor;
    self.date.font = kFont20;
    [backView addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView).offset(-50*kScale);
        make.top.mas_equalTo(backView).offset(13*kScale);
    }];
    self.date.text = @"";
    
    UIView *cutOff = [UIView new];
    [backView addSubview:cutOff];
    cutOff.backgroundColor = kCommonUnableColor;
    [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(backView).offset(160*kScale);
        make.centerX.mas_equalTo(weakSelf.contentView).multipliedBy(1.1);
        make.centerY.mas_equalTo(backView);
        make.height.mas_equalTo(30*kScale);
        make.width.mas_equalTo(1);
    }];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.textColor = YXGray(172);
    self.moneyLabel.font = kFont14;
    [backView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.money);
        make.top.mas_equalTo(weakSelf.money.mas_bottom).offset(5*kScale);
    }];
    self.moneyLabel.text = @"借款金额(元)";
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = YXGray(172);
    self.dateLabel.font = kFont14;
    [backView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.date);
        make.top.mas_equalTo(weakSelf.date.mas_bottom).offset(5*kScale);
    }];
    self.dateLabel.text = @"还款日";
    
    UIImageView *imageView = [UIImageView new];
    [backView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"more"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView).offset(-10*kScale);
        make.centerY.mas_equalTo(backView);
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
