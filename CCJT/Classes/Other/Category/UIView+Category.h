//
//  UIView+Category.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (nonatomic, assign) CGFloat yx_x;
@property (nonatomic, assign) CGFloat yx_y;
@property (nonatomic, assign) CGFloat yx_width;
@property (nonatomic, assign) CGFloat yx_height;
@property (nonatomic, assign) CGFloat yx_centerX;
@property (nonatomic, assign) CGFloat yx_centerY;

- (void)setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (void)set_yxbackgroundImage:(NSString *)imageNamed ofType:(NSString *)type;

@end
