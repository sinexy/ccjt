//
//  YXLousDetalisModel.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/19.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousDetalisModel.h"

@implementation YXLousDetalisModel
- (instancetype)init
{
    if (self = [super init]) {
        [YXLousDetalisModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id"
                     };
        }];
    }
    return self;
}

- (NSString *)statusString
{
    /**
     * status  :  1-待确认  2-确认  3-取消  4-驳回  5-结束
     */
    NSString *dateString;
    switch (self.status) {
        case 1:
            dateString = @"待确认";
            break;
        case 2:
            dateString = @"进行中";
            break;
        case 3:
            dateString = @"取消";
            break;
        case 4:
            dateString = @"驳回";
            break;
        case 5:
            dateString = @"结束";
            break;
        default:
            break;
    }
    return dateString;
}
@end
