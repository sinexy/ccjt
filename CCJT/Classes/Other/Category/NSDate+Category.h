//
//  NSDate+Category.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/16.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

/**
 * 获取两个时间的天数差
 @param firstDate 第一个时间
 @param secondDate 第二个时间
 @return 比较得出的天数差
 */
+ (NSInteger)getDateFormDate:(NSDate *)firstDate toDate:(NSDate *)secondDate;
+ (NSInteger)getDateToDateDays:(NSDate *)firstDate withSaveDate:(NSDate *)secondDate;

+ (NSString *)getCurrentYearMonthDay;

+ (NSString *)getNowTimeTimestamp;

@end
