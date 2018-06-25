//
//  UIBarButtonItem+YXCategory.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIBarButtonItem+YXCategory.h"

@implementation UIBarButtonItem (YXCategory)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn sizeToFit];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:btn.bounds];
    [view addSubview:btn];
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn sizeToFit];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:btn.bounds];
    [view addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (UIBarButtonItem *)itemWithtitle:(NSString *)title normalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:normalColor ?: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:highlightColor ?: [UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn sizeToFit];
//    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:btn.bounds];
    [view addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

@end
