//
//  UIImageView+Category.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

- (void)yx_setCornerImage
{
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(self.bounds.size.width*0.5, self.bounds.size.width*0.5);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        if (UIGraphicsGetCurrentContext() == nil) {
            return ;
        }
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerRadii];
        [cornerPath addClip];
        [self.image drawInRect:self.bounds];
        CGImageRef newImageRef = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            self.layer.contents = (__bridge id _Nullable)(newImageRef);
        });
    });
}


//圆
- (void)yx_setCircleImageWithUrl:(NSURL *)url placeholder:(UIImage *)image fillColor:(UIColor *)color{
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
    [image yx_roundImageWithSize:size fillColor:color completion:^(UIImage *radiusPlaceHolder) {
        
        //2.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:radiusPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img yx_roundImageWithSize:size fillColor:color completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
            
        }];
        
    }];
}

//圆形矩阵
- (void)yx_setRoundRectImageWithUrl:(NSURL *)url placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius{
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
    [image yx_roundRectImageWithSize:size fillColor:color radius:cornerRadius completion:^(UIImage *roundRectPlaceHolder) {
        
        //2.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:roundRectPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img yx_roundRectImageWithSize:size fillColor:color radius:cornerRadius completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
            
        }];
        
    }];
    
}

@end
