//
//  YXLousDetailsViewController.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"

@class YXLousDetalisModel;

@interface YXLousDetailsViewController : YXBaseViewController

@property (nonatomic, strong) YXLousDetalisModel *model;

- (instancetype)initWithModel:(YXLousDetalisModel *)model;

@end
