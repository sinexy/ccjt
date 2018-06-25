//
//  YXNetworking.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSURLSessionTask;

// 请求类型
typedef NS_ENUM(NSInteger, YXRequestType) {
    YXRequestTypeGet = 0,   // get请求
    YXRequestTypePost = 1,  // post请求
};

/**
 * 请求返回的请求会话
 */
typedef NSURLSessionTask YXNSURLSessionTask;


/**
 *  请求成功的回调
 *
 *  @param response 请求返回对象
 */
typedef void(^YXResponseSuccess)(id response);

/**
 *  请求失败的回调
 *
 *  @param error 失败信息
 */
typedef void(^YXResponseFail)(NSError *error) ;


/**
 *  上传和下载的进度回调
 *
 *  @param progress 上传和下载进度
 */
typedef void(^YXProgress)(NSProgress *progress);


@interface YXNetworking : NSObject

/**baseUrl*/
@property (nonatomic, strong)NSString *baseUrl;



/**
 配置请求头
 
 @param headers 请求头字典
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)headers;

/**
 *  get请求
 *
 *  @param url     请求url
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 请求回话
 */
+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;

/**
 *  get请求 带参数
 *
 *  @param url     请求url
 *  @param params  请求参数
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 请求回话
 */
+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;

/**
 *  get请求 带参数,带进度
 *
 *  @param url      请求url
 *  @param params   请求参数
 *  @param progress 请求进度回调
 *  @param success  请求成功的回调
 *  @param fail     请求失败的回调
 *
 *  @return 请求回话
 */
+ (YXNSURLSessionTask *)getWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(YXProgress)progress
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;

/**
 *  post请求
 *
 *  @param url     请求url
 *  @param params  请求参数
 *  @param success 成功的回调
 *  @param fail    失败的回调
 *  @return 请求回话
 */
+ (YXNSURLSessionTask *)postWithUrl:(NSString *)url
                             params:(NSDictionary *)params
                            success:(YXResponseSuccess)success
                               fail:(YXResponseFail)fail;

/**
 *  post请求 带进度
 *
 *  @param url      请求url
 *  @param params   请求参数
 *  @param progress 请求进度回调
 *  @param success  成功的回调
 *  @param fail     失败的回调
 *
 *  @return 请求回话
 */
+ (YXNSURLSessionTask *)postWithUrl:(NSString *)url
                             params:(NSDictionary *)params
                           progress:(YXProgress)progress
                            success:(YXResponseSuccess)success
                               fail:(YXResponseFail)fail;





/**
 单张图片上传
 
 @param url 请求url
 @param params 参数
 @param image 单张图片
 @param name name
 @param progress 进度条
 @param success 成功回调
 @param fail 失败回调
 @return 请求会话
 */
+ (YXNSURLSessionTask *)uploadWith:(NSString *)url
                            params:(NSDictionary *)params
                             image:(UIImage *)image
                              name:(NSString *)name
                          progress:(YXProgress)progress
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;

/**
 图片上传,支持图片数组
 
 @param url 请求url
 @param params 参数
 @param pics 图片数组
 @param name name
 @param progress 进度条
 @param success 成功回调
 @param fail 失败回调
 @return 请求会话
 */
+ (YXNSURLSessionTask *)uploadWith:(NSString *)url
                            params:(NSDictionary *)params
                              pics:(NSArray *)pics
                              name:(NSString *)name
                          progress:(YXProgress)progress
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;


/**
 图片上传
 
 @param url url
 @param params params
 @param pics 图片数组
 @param names 对应请求参数的key
 @param progress 进度
 @param success 成功回调
 @param fail 失败回到
 @return 请求会话
 */
+ (YXNSURLSessionTask *)uploadWith:(NSString *)url
                            params:(NSDictionary *)params
                              pics:(NSArray *)pics names:(NSArray *)names
                          progress:(YXProgress)progress
                           success:(YXResponseSuccess)success
                              fail:(YXResponseFail)fail;
// 单例模型
+ (instancetype)shared;

@end
