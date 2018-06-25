//
//  YXCountView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXCountView.h"

@interface YXCountView()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YXCountView

- (instancetype)init
{
    if (self = [super init]) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowColor = kCommonColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.6f;
        self.layer.cornerRadius = 8 * kScale;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    YXWeakSelf(self);

    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf).multipliedBy(0.5);
        make.height.mas_equalTo(weakSelf);
    }];
    [_leftView addSubview:self.leftImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_leftView);
        make.top.mas_equalTo(_leftView).mas_offset(22*kScale);
    }];
    
    [_leftView addSubview:self.leftTextLabel];
    [self.leftTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftImageView);
        make.top.mas_equalTo(self.leftImageView.mas_bottom).mas_offset(6*kScale);
    }];
    
    [_leftView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftImageView);
        make.top.mas_equalTo(self.leftTextLabel.mas_bottom).mas_offset(10*kScale);
    }];
    
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf).multipliedBy(0.5);
        make.height.mas_equalTo(weakSelf);
    }];
    [_rightView addSubview:self.rightImageView];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_rightView);
        make.top.mas_equalTo(_rightView).mas_offset(22*kScale);
    }];
    
    [_rightView addSubview:self.rightTextLabel];
    [self.rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightImageView);
        make.top.mas_equalTo(self.rightImageView.mas_bottom).mas_offset(6*kScale);
    }];
    
    [_rightView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightImageView);
        make.top.mas_equalTo(self.rightTextLabel.mas_bottom).mas_offset(10*kScale);
    }];
    
    UIView *cutOff = [UIView new];
    [self addSubview:cutOff];
    cutOff.backgroundColor = kCommonUnableColor;
    [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(80*kScale);
        make.width.mas_equalTo(1);
    }];
}


- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClicked:)];
        [_leftView addGestureRecognizer:tap];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.tag = 2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClicked:)];
        [_rightView addGestureRecognizer:tap];
    }
    return _rightView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [UIImage imageNamed:@"repaid"];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [UIImage imageNamed:@"paid"];
    }
    return _rightImageView;
}

- (UILabel *)leftTextLabel
{
    if (!_leftTextLabel) {
        _leftTextLabel = [UILabel new];
        _leftTextLabel.font = kFont14;
        _leftTextLabel.textColor = kMDeepTextColor;
        _leftTextLabel.text = @"借入(元)";
    }
    return _leftTextLabel;
}

- (UILabel *)rightTextLabel
{
    if (!_rightTextLabel) {
        _rightTextLabel = [UILabel new];
        _rightTextLabel.font = kFont14;
        _rightTextLabel.textColor = kMDeepTextColor;
        _rightTextLabel.text = @"借出(元)";
    }
    return _rightTextLabel;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = kFont14;
        _leftLabel.textColor = kMDeepTextColor;
        _leftLabel.text = @"0.00";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = kFont14;
        _rightLabel.textColor = kMDeepTextColor;
        _rightLabel.text = @"0.00";
    }
    return _rightLabel;
}

#pragma mark private method
- (void)viewDidClicked:(UITapGestureRecognizer *)tap
{
    // 左边是1  右边是2
    [self.delegate countView:self didSelectedIndex:tap.view.tag];
    
}

@end
