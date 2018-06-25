//
//  UIImage+Category.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 返回一张没有被渲染的图片
 
 @param imageName  图片名称
 @return 一张没有被渲染的图片
 */
+ (UIImage *)yx_imageWithOriginal:(NSString *)imageName;



/**
 根据颜色返回一张图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)yx_imageWithColor:(UIColor *)color;

+ (instancetype)imageWithURLString:(NSString *)urlString;

/**
 按比例缩放,size 是你要把图显示到 多大区域
 */
-(UIImage *)yx_imageCompressForSize:(CGSize)size;

-(UIImage *)yx_imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
-(instancetype)yx_drawRectWithRoundedCorner:(CGFloat)radius;
//圆形
- (void)yx_roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *))completion;
//圆角矩阵
- (void)yx_roundRectImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor radius:(CGFloat)radius completion:(void (^)(UIImage *))completion;

@end
