//
//  UIButton+Category.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/20.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

- (void)layoutButtonImageView:(YXPosition)positionWithPadding :(CGFloat)padding
{
    CGRect oldFrame = self.frame;
    CGRect oldImageViewFrame = self.imageView.frame;
    CGRect oldTitleFrame = self.titleLabel.frame;

    switch (positionWithPadding) {
        case imageUp:
            [self setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
            break;
        case imageLeft:
            
            break;
        case imageDown:
            
            break;
        case imageRight:
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -oldImageViewFrame.size.width-padding*0.5, 0, oldImageViewFrame.size.width+padding*0.5)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, oldTitleFrame.size.width+padding*0.5, 0, -oldTitleFrame.size.width-padding*0.5)];
            break;
            
        default:
            break;
    }
}

@end
