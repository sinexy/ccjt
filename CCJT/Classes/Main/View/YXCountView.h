//
//  YXCountView.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXCountView;

@protocol YXCountViewDelegate

- (void)countView:(YXCountView *)countView didSelectedIndex:(NSUInteger )index;

@end

@interface YXCountView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *leftTextLabel;
@property (nonatomic, strong) UILabel *rightTextLabel;
@property (nonatomic, weak) id<YXCountViewDelegate> delegate;

@end
