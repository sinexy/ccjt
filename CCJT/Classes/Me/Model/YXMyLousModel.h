//
//  YXMyLousModel.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/21.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXMyLousModel : NSObject

@property (nonatomic, assign) CGFloat repaymentSumAmount;   // 待还
@property (nonatomic, assign) CGFloat receivableSumAmount;  // 待收
@property (nonatomic, strong) NSString *repaymentTotalCount;   // 待还次数
@property (nonatomic, strong) NSString *receivableTotalCount;  // 待收次数
@property (nonatomic, assign) CGFloat repaymentSumInterest;   // 待还利息
@property (nonatomic, assign) CGFloat receivableSumInterest;  // 待收利息

@end
