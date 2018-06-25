//
//  YXTextFieldView.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *rightView;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text placeHolderText:(NSString *)placeHolderText rightView:(UIView *)rightView andIsSecret:(BOOL)isSecret;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image placeHolderText:(NSString *)placeHolderText rightView:(UIView *)rightView andIsSecret:(BOOL)isSecret;


@end
