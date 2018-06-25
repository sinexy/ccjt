//
//  YXAppInfoManager.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/15.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXAppInfoManager.h"

@implementation YXAppInfoModel

- (instancetype)init
{
    if (self = [super init]) {
        [YXAppInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id"
                     };
        }];
    }
    return self;
}

@end

@implementation YXAppInfoManager

+(instancetype)shared
{
    static YXAppInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (BOOL)isUpdate
{
    if([self.iosVersion.versionNo compare:APP_VERSION_STRING options:NSNumericSearch] == NSOrderedDescending) {
        return self.iosVersion.isForce;
    }
    return false;
}

- (BOOL)isFirst
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"appInfo"];
    if (dict){
        return ![dict[@"isFirst"] isEqualToString:@"1"];
    }else{
        return true;
    }
}

- (void)setIsFirst:(BOOL)isFirst
{
    if (isFirst == false) {
        NSMutableDictionary * appInfo = [NSMutableDictionary dictionary];
        appInfo[@"isFirst"] = @"1";
        //快速创建
        [[NSUserDefaults standardUserDefaults] setObject:appInfo forKey:@"appInfo"];
        //必须
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setIsSueecss:(BOOL)isSueecss
{
    _isSueecss = isSueecss;

}

- (BOOL)isActivity
{
    if (!self.activities) {
        return false;
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"appActivity"];
    if (dict){
        NSInteger show = [dict[@"isShow"] integerValue];
        NSInteger repeatCount = [dict[@"repeatCount"] integerValue];
        if (repeatCount-show > 0) {
            NSMutableDictionary * Activity = [NSMutableDictionary dictionary];
            Activity[@"isShow"] = @(show++);
            Activity[@"repeatCount"] = self.activities[@"repeatCount"];
            //快速创建
            [[NSUserDefaults standardUserDefaults] setObject:Activity forKey:@"appActivity"];
            return true;
        }else{
            return false;
        }
    }else{
        NSMutableDictionary * Activity = [NSMutableDictionary dictionary];
        Activity[@"isShow"] = @"1";
        Activity[@"repeatCount"] = self.activities[@"repeatCount"];
        //快速创建
        [[NSUserDefaults standardUserDefaults] setObject:Activity forKey:@"appActivity"];
        //必须
        [[NSUserDefaults standardUserDefaults] synchronize];
        return true;
    }
}

@end
