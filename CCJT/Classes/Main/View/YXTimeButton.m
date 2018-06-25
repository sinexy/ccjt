//
//  YXTimeButton.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXTimeButton.h"

@interface YXTimeButton()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isStart;

@end

@implementation YXTimeButton

static NSInteger countDownTime = 59;

- (void)resetTime
{
    self.isStart = NO;
    self.userInteractionEnabled = YES;
    countDownTime = 59;
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:kCommonColor forState:UIControlStateNormal];
}

- (void)startReduce{
    if (self.isStart) {
        return;
    }
    self.userInteractionEnabled = NO;
    self.isStart = YES;
    [self setTitle:@"59秒" forState:UIControlStateNormal];
    [self setTitleColor:kCommonUnableColor forState:UIControlStateNormal];
    [self timer];
}

- (void)timeReduce
{
    if (countDownTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self resetTime];
        
    }else{
        countDownTime--;
        [self setTitle:[NSString stringWithFormat:@"%zd秒",countDownTime] forState:UIControlStateNormal];
    }
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeReduce) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)deallocTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
