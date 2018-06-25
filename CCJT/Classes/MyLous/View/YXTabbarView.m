//
//  YXTabbarView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXTabbarView.h"

@interface YXTabbarView()

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation YXTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSArray *title = @[@"全部", @"待还", @"待收"];
    CGFloat w = 64*kScale;
    CGFloat h = 24*kScale;
    CGFloat x = (YXScreenW-3*w)/4;
    for (int i = 0; i < title.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:title[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(x+i*(w+x), 9*kScale, w, h);
        [button setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        button.titleLabel.font = kFont16;
        button.layer.cornerRadius = 12*kScale;
        if (i == 0) {
            button.backgroundColor = kCommonColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.selectedButton = button;
        }
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    UIButton *button = self.subviews[index];
    [self.selectedButton setTitleColor:kCommonTextColor forState:UIControlStateNormal];
    self.selectedButton.backgroundColor = [UIColor clearColor];
    
    button.backgroundColor = kCommonColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedButton = button;
    
    [self.delegate tabbarView:self didSelectedIndex:button.tag];
    
}

- (void)buttonDidClicked:(UIButton *)button
{
    [self.selectedButton setTitleColor:kCommonTextColor forState:UIControlStateNormal];
    self.selectedButton.backgroundColor = [UIColor clearColor];
    
    button.backgroundColor = kCommonColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedButton = button;
    
    [self.delegate tabbarView:self didSelectedIndex:button.tag];
}

@end
