//
//  YXLatelyView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLatelyView.h"

@interface YXLatelyView()



@end

@implementation YXLatelyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.layer.shadowColor = kCommonColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.8f;
        self.layer.cornerRadius = 8 * kScale;
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTitle:@"近期借条" forState:UIControlStateNormal];
    button.frame = CGRectMake(20*kScale, 15*kScale, 100*kScale, 30*kScale);
    button.backgroundColor = kCommonColor;
    button.layer.cornerRadius = 3*kScale;
    button.titleLabel.font = kFont16;
    
    UILabel *label = [UILabel new];
    [self addSubview:label];
    label.text = @"查看详情";
    label.font = kFont14;
    label.textColor = YXGray(172);
    label.frame = CGRectMake(self.yx_width-90*kScale, 20*kScale, 70*kScale, 17*kScale);
    
    UIView *cutOff = [UIView new];
    [self addSubview:cutOff];
    cutOff.frame = CGRectMake(15*kScale, 54*kScale, self.yx_width-30*kScale, 1);
    cutOff.backgroundColor = kCommonUnableColor;
    
    self.money = [UILabel new];
    [self addSubview:self.money];
    self.money.textColor = YXGray(96);
    self.money.font = kFont20;
    self.money.text = @"1000000.00";
    self.money.frame = CGRectMake(40*kScale, 71*kScale, 120*kScale, 28*kScale);
    
    UILabel *moneyLabel = [UILabel new];
    [self addSubview:moneyLabel];
    moneyLabel.frame = CGRectMake(50*kScale, 104*kScale, 80*kScale, 17*kScale);
    moneyLabel.textColor = YXGray(172);
    moneyLabel.font = kFont12;
    moneyLabel.text = @"借款金额(元)";
    
    self.data = [UILabel new];
    [self addSubview:self.data];
    self.data.textColor = YXGray(96);
    self.data.font = kFont20;
    self.data.text = @"2018/12/31";
    self.data.frame = CGRectMake(self.yx_width - 140*kScale, 71*kScale, 120*kScale, 28*kScale);
    
    UILabel *dataLabel = [UILabel new];
    [self addSubview:dataLabel];
    dataLabel.frame = CGRectMake(self.yx_width - 110*kScale, 104*kScale, 70*kScale, 17*kScale);
    dataLabel.textColor = YXGray(172);
    dataLabel.font = kFont12;
    dataLabel.text = @"还款日";
    
}

@end
