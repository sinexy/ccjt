//
//  UIImageView+Category.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)

- (void)yx_setCornerImage;
//网络延迟下载--圆形
- (void)yx_setCircleImageWithUrl:(NSURL *)url placeholder:(UIImage *)image fillColor:(UIColor *)color;
//网络延迟下载--圆形矩阵
- (void)yx_setRoundRectImageWithUrl:(NSURL *)url placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius;
@end
