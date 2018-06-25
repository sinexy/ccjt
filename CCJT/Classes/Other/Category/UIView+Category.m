//
//  UIView+Category.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (CGFloat)yx_x
{
    return self.frame.origin.x;
}

- (void)setYx_x:(CGFloat)yx_x
{
    CGRect frame = self.frame;
    frame.origin.x = yx_x;
    self.frame = frame;
}

- (CGFloat)yx_y
{
    return self.frame.origin.y;
}

- (void)setYx_y:(CGFloat)yx_y
{
    CGRect frame = self.frame;
    frame.origin.y = yx_y;
    self.frame = frame;
}

- (CGFloat)yx_width
{
    return self.frame.size.width;
}

- (void)setYx_width:(CGFloat)yx_width
{
    CGRect frame = self.frame;
    frame.size.width = yx_width;
    self.frame = frame;
}

- (CGFloat)yx_height
{
    return self.frame.size.height;
}

- (void)setYx_height:(CGFloat)yx_height
{
    CGRect frame = self.frame;
    frame.size.height = yx_height;
    self.frame = frame;
}

- (CGFloat)yx_centerX
{
    return self.center.x;
}

- (void)setYx_centerX:(CGFloat)yx_centerX
{
    CGPoint center = self.center;
    center.x = yx_centerX;
    self.center = center;
}

- (CGFloat)yx_centerY
{
    return self.center.y;
}

- (void)setYx_centerY:(CGFloat)yx_centerY
{
    CGPoint center = self.center;
    center.y = yx_centerY;
    self.center = center;
}

- (void)setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    [self layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    [self.layer addSublayer:gradientLayer];
}

- (void)set_yxbackgroundImage:(NSString *)imageNamed ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageNamed ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) {
        image = [UIImage imageNamed:imageNamed];
    }
    self.layer.contents = (id)image.CGImage;
}

@end
