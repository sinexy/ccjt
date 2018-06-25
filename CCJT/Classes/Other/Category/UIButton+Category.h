//
//  UIButton+Category.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/20.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXPosition) {
    
    imageUp = 0,
    imageLeft,
    imageDown,
    imageRight,
};

@interface UIButton (Category)

- (void)layoutButtonImageView:(YXPosition)positionWithPadding:(CGFloat)padding;

@end
