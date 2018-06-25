//
//  UIBarButtonItem+YXCategory.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YXCategory)

/**
 根据图片 快速创建一个UIBarButtonItem
 
 @param image 默认图片
 @param highImage 高亮图片
 @param target target
 @param action SEL
 @return 返回UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

/**
 根据图片和文字 快速创建一个UIBarButtonItem
 
 @param image 默认图片
 @param highImage 高亮图片
 @param target target
 @param action SE
 @param title 名字
 @return 返回UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action;

/**
 根据文字 快速创建一个UIBarButtonItem
 @param title 文本
 @param normalColor 普通颜色
 @param highlightColor 高亮颜色
 @param target target
 @param action SE
 @return 返回UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithtitle:(NSString *)title normalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor target:(id)target action:(SEL)action;


@end
