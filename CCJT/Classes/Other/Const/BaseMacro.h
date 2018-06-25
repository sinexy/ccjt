//
//  BaseMacro.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//
#ifndef BaseMacro_h
#define BaseMacro_h


#import <UIKit/UIKit.h>
//手机序列号

// MARK: - APP版本号
//此获取的版本号对应bundle，打印出来对应为12345这样的数字
#define APP_VERSION_NUMBER [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

//此获取的版本号对应version，打印出来对应为1.2.3.4.5这样的字符串
#define APP_VERSION_STRING [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
// 是否等于
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

// 是否大于
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// 大于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 小于
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

// 小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



// MARK: - weak strong
#define YXWeakSelf(var)   __weak typeof(var) weakSelf = var
#define YXStrongSelf(var) __strong typeof(var) strongSelf = var

//MARK: - NavBar高度
#define NavigationBar_HEIGHT 44

// MARK: - 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)



// MARK: - 屏幕适配
#define WZAutoScaleWidth SCREEN_WIDTH / 320 // 横向缩放
#define WZAutoScaleHeight SCREEN_HEIGHT / 568// 垂直缩放
#define WZFontSize(s) (s) * WZAutoScaleHeight // 字体大小
#define WZWidth(f) (f) * WZAutoScaleWidth // 宽度
#define WZHeight(f) (f) * WZAutoScaleHeight // 高度
/***********屏幕适配*************/
#define YXScreenW [UIScreen mainScreen].bounds.size.width
#define YXScreenH [UIScreen mainScreen].bounds.size.height
#define kScale YXScreenW/375    // UI作图按照6s为模板 375*667
#define kFontScale kScale > 1 ? kScale * 0.6 : kScale

#define iphoneX (YXScreenH == 812)
#define iphone6P (YXScreenH == 736)
#define iphone6 (YXScreenH == 667)
#define iphone5 (YXScreenH == 568)
#define iphone4 (YXScreenH == 480)
/***********屏幕适配*************/

// MARK: - 系统版本号

#define kCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// MARK: - 打印日志
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define YXLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YXLog(...)
#endif

#endif /* BaseMacro_h */

