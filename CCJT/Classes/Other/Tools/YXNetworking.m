//
//  YXNetworking.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface YXNetworking()

@property (nonatomic, assign) AFNetworkReachabilityStatus networkingStatus;

/**请求头*/
@property (nonatomic, strong) NSDictionary *httpParamsDict;

@end

@implementation YXNetworking

// MARK: 配置请求头
+ (void)configCommonHttpHeaders:(NSDictionary *)headers
{
    YXNetworking *share = [self shared];
    share.httpParamsDict = headers;
    [self manager];
}

#pragma mark - get请求
+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    return [self requestWithUrl:url requestType:YXRequestTypeGet params:nil progress:nil success:success fail:fail];
}

+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    return [self requestWithUrl:url requestType:YXRequestTypeGet params:params progress:nil success:success fail:fail];
}

+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url params:(NSDictionary *)params progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    return [self requestWithUrl:url requestType:YXRequestTypeGet params:params progress:progress success:success fail:fail];
}

#pragma mark - post请求
+ (YXNSURLSessionTask *)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    return [self requestWithUrl:url requestType:YXRequestTypePost params:params progress:nil success:success fail:fail];
}

+ (YXNSURLSessionTask *)postWithUrl:(NSString *)url params:(NSDictionary *)params progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    return [self requestWithUrl:url requestType:YXRequestTypePost params:params progress:progress success:success fail:fail];
}

#pragma mark - 图片上传
+ (YXNSURLSessionTask *)uploadWith:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image name:(NSString *)name progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    NSArray *arr = @[image];
    return [self uploadWith:url params:params pics:arr name:name progress:progress success:success fail:fail];
}

+ (YXNSURLSessionTask *)uploadWith:(NSString *)url params:(NSDictionary *)params pics:(NSArray *)pics name:(NSString *)name progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    if ([[self shared] baseUrl] == nil) {
        
    }else {
        url = [NSString stringWithFormat:@"%@/%@",[[self shared] baseUrl],url];
    }
    YXNSURLSessionTask *task = nil;
    task = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < pics.count; i++) {
            UIImage *image = pics[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%zd.jpg",i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    return task;
}

+ (YXNSURLSessionTask *)uploadWith:(NSString *)url params:(NSDictionary *)params pics:(NSArray *)pics names:(NSArray *)names progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    YXNSURLSessionTask *task = nil;
    task = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < pics.count; i++) {
            UIImage *image = pics[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.85);
            [formData appendPartWithFileData:imageData name:names[i] fileName:[NSString stringWithFormat:@"%zd.jpg",i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
    return task;
}

#pragma mark - 请求统一处理
+ (YXNSURLSessionTask *)requestWithUrl: (NSString *)url requestType:(YXRequestType)type params:(NSDictionary *)params progress:(YXProgress)progress success:(YXResponseSuccess)success fail:(YXResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    YXNSURLSessionTask *task = nil;
    if ([[self shared] baseUrl] == nil) {
        
    }else {
//        NSURL *baseUrl = [NSURL URLWithString:[[self shared] baseUrl]];
        url = [NSString stringWithFormat:@"%@/%@",[[self shared] baseUrl],url];
    }
    // 判断请求类型
    if (type == YXRequestTypeGet) {
        task = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }
        }];
    }else if(type == YXRequestTypePost){
        task = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }
        }];
    }
    return task;
}

#pragma mark - sessionManager对象
+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = nil;
    manager = [AFHTTPSessionManager manager];

//    if ([[self shared] baseUrl] == nil) {
//        manager = [AFHTTPSessionManager manager];
//    }else {
//        NSURL *baseUrl = [NSURL URLWithString:[[self shared] baseUrl]];
//        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
//    }
    
    // 设置请求头
    NSDictionary *httpParams = [[self shared] httpParamsDict];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];  // 申明请求的数据是json类型
    for (NSString *key in httpParams) {
        if (httpParams[key] != nil) {
            [manager.requestSerializer setValue:httpParams[key] forHTTPHeaderField:key];
        }
    }
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TESTTOKEN] forHTTPHeaderField:@"Authorization"];
    // 设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"multipart/form-data",
                                                                              @"image/*"]];

    return manager;
}

#pragma mark - 模型单例对象
+(instancetype)shared
{
    static YXNetworking *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[YXNetworking alloc] init];
    });
    return singleton;
}

@end
