//
//  YXActivityViewController.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXActivityViewController : YXBaseViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *url;
- (instancetype)initWithNavigationTitle:(NSString *)title url:(NSString *)url;

@end
