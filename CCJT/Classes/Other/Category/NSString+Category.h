//
//  NSString+Category.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Category)

- (CGFloat)stringHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

- (CGFloat)stringHeightWithFont:(UIFont *)font width:(CGFloat)width;

/** 判断是否未数字（可以是小数）*/
- (BOOL)isNumber;
/** 身份证号码格式校验 */
- (BOOL)isIdentification;
/** 手机号码校验 */
- (BOOL)isPhoneNumber;

// 将不完整的base64 转为完整的
- (NSString *) stringPaddedForBase64;


/** 32位小写加密 */
- (NSString*)md532BitLower;
/** 32位大写加密 */
- (NSString*)md532BitUpper;

/** 时间戳转年月日*/
- (NSString *)timeStampString2Date;
@end
