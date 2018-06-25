//
//  YXQRCodeViewController.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/20.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXQRCodeViewController : YXBaseViewController

@property (nonatomic, copy) NSString *urlString;
- (instancetype)initWithUrlString:(NSString *)urlString;

@end
