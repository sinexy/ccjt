//
//  YXTextFieldView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXTextFieldView.h"

@implementation YXTextFieldView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text placeHolderText:(NSString *)placeHolderText rightView:(UIView *)rightView andIsSecret:(BOOL)isSecret
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.font = kFont16;
        label.text = text;
        label.textColor = kCommonTextColor;
        YXWeakSelf(self);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(16*kScale);
            make.centerY.mas_equalTo(weakSelf);
        }];
        _textField = [[UITextField alloc] init];
        [self addSubview:_textField];

        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(10);
            make.centerY.mas_equalTo(weakSelf);
            make.width.mas_equalTo(180*kScale);
            make.height.mas_equalTo(36);
        }];
        _textField.secureTextEntry = isSecret;
        _textField.textColor = kCommonTextColor;
        _textField.placeholder = placeHolderText;
        _textField.font = kFont16;
        
        if (rightView) {
            [self addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-21*kScale);
                make.centerY.mas_equalTo(weakSelf);
            }];
        }

        UIView *cutOffView = [UIView new];
        cutOffView.backgroundColor = YXRGB(223, 230, 233);
        [self addSubview:cutOffView];
        cutOffView.frame = CGRectMake(16*kScale, self.yx_height-3, self.yx_width-32*kScale, 1);
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image placeHolderText:(NSString *)placeHolderText rightView:(UIView *)rightView andIsSecret:(BOOL)isSecret
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        YXWeakSelf(self);
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf).offset(16*kScale);
            make.centerY.mas_equalTo(weakSelf);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        _textField = [[UITextField alloc] init];
        [self addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(10);
            make.centerY.mas_equalTo(weakSelf);
            make.width.mas_equalTo(180*kScale);
            make.height.mas_equalTo(36);
        }];
        _textField.secureTextEntry = isSecret;
        _textField.textColor = kCommonTextColor;
        _textField.placeholder = placeHolderText;
        _textField.font = kFont16;
        if (rightView) {
            [self addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-21*kScale);
                make.centerY.mas_equalTo(weakSelf);
            }];
        }
        UIView *cutOffView = [UIView new];
        cutOffView.backgroundColor = YXRGB(223, 230, 233);
        [self addSubview:cutOffView];
        cutOffView.frame = CGRectMake(16*kScale, self.yx_height-3, self.yx_width-32*kScale, 1);
    }
    return self;
}

@end
