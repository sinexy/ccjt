//
//  YXLousDetalisModel.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/19.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLousDetalisModel : NSObject

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *borrowerAuthUuid;
@property (nonatomic, strong) NSString *borrowerIdCard;
@property (nonatomic, strong) NSString *borrowerName;
@property (nonatomic, strong) NSString *borrowingTerm;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createUser;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *interest;
@property (nonatomic, strong) NSString *lenderAuthUuid;
@property (nonatomic, strong) NSString *lenderIdCard;
@property (nonatomic, strong) NSString *lenderName;
@property (nonatomic, strong) NSString *lendingTime;
@property (nonatomic, strong) NSString *loanPurpose;
@property (nonatomic, strong) NSString *rateYear;
@property (nonatomic, strong) NSString *receiveIdCard;
@property (nonatomic, strong) NSString *receiveName;
@property (nonatomic, strong) NSString *receiveUuid;
@property (nonatomic, strong) NSString *refundTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *sendUuid;
/**
 * status  :  1-待确认  2-确认  3-取消  4-驳回  5-结束
 */
@property (nonatomic, assign) NSUInteger status; 
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *updateUser;
@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *statusString;

@end
