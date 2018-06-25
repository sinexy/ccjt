//
//  YXUserManager.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXUserModel : NSObject

@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *idAuth;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *authUuid;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *appChannel;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *userUuid;

@end

@interface YXUserManager : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, assign, readonly) BOOL isRealName;
@property (nonatomic, strong) YXUserModel *userModel;

+ (instancetype)shared;


@end
