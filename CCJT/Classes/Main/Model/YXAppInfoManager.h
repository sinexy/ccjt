//
//  YXAppInfoManager.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/15.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXAppInfoModel: NSObject
/**
 * id
 */
@property (nonatomic, copy) NSString *ID;
/**
 * uuid
 */
@property (nonatomic, copy) NSString *uuid;
/**
 * 版本号
 */
@property (nonatomic, copy) NSString *versionNo;
/**
 * 中文版本
 */
@property (nonatomic, copy) NSString *memo;
/**
 * 是否强制更新
 */
@property (nonatomic, assign) BOOL isForce;
/**
 * 弹窗title
 */
@property (nonatomic, copy) NSString *title;
/**
 * 弹窗描述
 */
@property (nonatomic, copy) NSString *remark;
/**
 * 下载地址
 */
@property (nonatomic, copy) NSString *downloadAdress;
/**
 * 更新时间
 */
@property (nonatomic, copy) NSString *appupdateDate;

@end


@interface YXAppInfoManager : NSObject

/**
 * 启动页图片
 */
@property (nonatomic, copy) NSString *welcomePage;
/**
 * App信息
 */
@property (nonatomic, strong) YXAppInfoModel *iosVersion;
/**
 *  用途
 */
@property (nonatomic, strong) NSMutableArray *purpose;


/**是否需要更新*/
@property (nonatomic, assign) BOOL isUpdate;
/**是否第一次打开*/
@property (nonatomic, assign) BOOL isFirst;
/**是否初始化成功*/
@property (nonatomic, assign) BOOL isSueecss;

// 活动相关
// 是否有活动
@property (nonatomic, assign) BOOL isActivity;

@property (nonatomic, strong) NSDictionary *activities;

+(instancetype)shared;

@end
