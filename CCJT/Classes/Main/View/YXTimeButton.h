//
//  YXTimeButton.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTimeButton : UIButton
/**重置时间*/
- (void)resetTime;
/**开始减少*/
- (void)startReduce;

/**销毁计时器*/
- (void)deallocTimer;
@end
