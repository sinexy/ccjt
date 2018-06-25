//
//  YXNoDataView.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXNoDataView : UIView

+ (instancetype)shared;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;

@end
