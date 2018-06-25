//
//  YXUserManager.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXUserManager.h"

@implementation YXUserModel


@end


@implementation YXUserManager

+ (instancetype)shared
{
    static YXUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXUserManager alloc] init];
    });
    return manager;
}

- (BOOL)isLogin
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (dict){
        _userModel = [[YXUserModel alloc] init];
        _userModel.userUuid = dict[@"userUuid"];
        _userModel.sessionId = dict[@"sessionId"];
        _userModel.mobileNumber = dict[@"mobileNumber"];

        NSString *authUuid, *mobileNumber, *idCard;
        authUuid = [dict valueForKey:@"authUuid"];
        mobileNumber = [dict valueForKey:@"mobileNumber"];
        idCard = [dict valueForKey:@"idCard"];
        
        if (authUuid.length) {
            _userModel.authUuid = authUuid;
            _userModel.idCard = idCard;
            _userModel.mobileNumber = mobileNumber;

        }
        return [dict[@"sessionId"] length];
    }else{
        return false;
    }
}

- (BOOL)isRealName
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (dict){
        _userModel = [[YXUserModel alloc] init];
        _userModel.userUuid = dict[@"userUuid"];
        _userModel.sessionId = dict[@"sessionId"];
        NSString *authUuid, *mobileNumber, *idCard, *realName;
        authUuid = [dict valueForKey:@"authUuid"];
        mobileNumber = [dict valueForKey:@"mobileNumber"];
        idCard = [dict valueForKey:@"idCard"];
        realName = [dict valueForKey:@"realName"];

        if (authUuid.length) {
            _userModel.authUuid = authUuid;
            _userModel.mobileNumber = mobileNumber;
            _userModel.idCard = idCard;
            _userModel.realName = realName;
        }
        return [authUuid length];
    }else{
        return false;
    }
}

- (void)setUserModel:(YXUserModel *)userModel
{
    _userModel = userModel;
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[@"sessionId"] = userModel.sessionId;
    userInfo[@"userUuid"] = userModel.userUuid;
    userInfo[@"authUuid"] = userModel.authUuid;
    userInfo[@"mobileNumber"] = userModel.mobileNumber;
    userInfo[@"idCard"] = userModel.idCard;
    userInfo[@"realName"] = userModel.realName;
    //快速创建
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    //必须
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
