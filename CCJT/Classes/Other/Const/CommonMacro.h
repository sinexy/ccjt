//
//  CommonMacro.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h



// MARK: - 项目名称
#define kProjectName @"草船借条"

// MARK: - baseurl  测试
#define kBaseUrl @"xxxxxxxxxxxxxxxxx"
// MARK: - apiurl   测试
#define kApiUrl [NSString stringWithFormat:@"%@ccapi",kBaseUrl]

// MARK: - bundleid
#define kBundleID @"com.baiyunxin.ccjt"

  // 微信支付结果通知
#define kWeiXinPayResultNotification @"WeiXinPayResultNotification"
  // 微信分享结果通知
#define kWeiXinSendMessageResultNotification  @"WeiXinSendMessageResultNotification"

// bugly appId
#define kBuglyAppId @"xxxxxxxxxx"

// 微信 apiid
#define kWXApiAppId @"xxxxxxxxxx"


#import "SVProgressHUD.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "YXNetworking.h"
#import "YXAppInfoManager.h"
#import "YXUserManager.h"
#import "YXNotificationConst.h"

/// 颜色
#define YXRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define YXRGB(r,g,b) YXRGBA(r,g,b,1.0f)
#define YXGray(x) YXRGB(x,x,x)

// 主色调
#define kCommonColor YXRGB(56, 115, 229)
#define kCommonTextColor YXRGB(72, 77, 80)
#define kCommonUnableColor YXRGB(218, 223, 223)

// 中间本颜色
#define kMDeepTextColor YXGray(77)
// 最深文本颜色
#define kLDeepTextColor [UIColor colorWithHexString:@"#333333"]
// 最浅文本颜色
#define kSDeepTextColor [UIColor colorWithHexString:@"#B0B0B0"]


// 字体
#define kFont10 [UIFont systemFontOfSize:10*kScale]
#define kFont12 [UIFont systemFontOfSize:12*kScale]
#define kFont13 [UIFont systemFontOfSize:13*kScale]
#define kFont14 [UIFont systemFontOfSize:14*kScale]
#define kFont15 [UIFont systemFontOfSize:15*kScale]
#define kFont16 [UIFont systemFontOfSize:16*kScale]
#define kFont17 [UIFont systemFontOfSize:17*kScale]
#define kFont18 [UIFont systemFontOfSize:18*kScale]
#define kFont20 [UIFont systemFontOfSize:20*kScale]
#define kFont26 [UIFont systemFontOfSize:26*kScale]

//[UIFont systemFontOfSize:18*kScale]
#endif /* CommonMacro_h */
