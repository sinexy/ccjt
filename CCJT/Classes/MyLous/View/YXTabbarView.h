//
//  YXTabbarView.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTabbarView;

@protocol YXTabbarViewDelegate

- (void)tabbarView:(YXTabbarView *)tabbarView didSelectedIndex:(NSUInteger)index;

@end

@interface YXTabbarView : UIView

@property (nonatomic, weak) id<YXTabbarViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger index;

@end
