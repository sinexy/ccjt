//
//  YXLousDetailsHeaderView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/13.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousDetailsHeaderView.h"

@implementation YXLousDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.iconImageView = [UIImageView new];
        YXWeakSelf(self);
        UIView *sep1 = [UIView new];
        [self addSubview:sep1];
        sep1.backgroundColor = YXGray(248);
        [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf);
            make.height.mas_equalTo(10);
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(99*kScale);
            make.centerY.mas_equalTo(weakSelf);
            make.width.mas_equalTo(40*kScale);
            make.height.mas_equalTo(40*kScale);
        }];
        
        self.state = [UILabel new];
        [self addSubview:self.state];
        [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(8*kScale);
            make.top.mas_equalTo(weakSelf.iconImageView);
        }];
        self.state.font = kFont20;
        self.state.textColor = kCommonTextColor;
        
        self.date = [UILabel new];
        [self addSubview:self.date];
        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(8*kScale);
            make.bottom.mas_equalTo(weakSelf.iconImageView);
        }];
        self.date.font = kFont13;
        self.date.textColor = kCommonUnableColor;
        
        UIView *sep2 = [UIView new];
        [self addSubview:sep2];
        sep2.backgroundColor = YXGray(248);
        [sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

@end
