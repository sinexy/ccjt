//
//  YXSearchLousViewController.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/13.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXMyLousModel.h"

@interface YXSearchLousViewController : YXBaseViewController
@property (nonatomic, assign) NSUInteger type;

- (instancetype)initWithType:(NSUInteger)type withModel:(YXMyLousModel *)model;

@end
