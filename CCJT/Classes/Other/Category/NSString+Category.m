//
//  NSString+Category.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/26.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)

- (CGFloat)stringHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height;
}

- (CGFloat)stringHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height;
}

- (BOOL)isNumber
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]\\d*\\.?\\d*|0\\.\\d*[0-9]\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)isIdentification
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPhoneNumber
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

- (NSString *)stringPaddedForBase64
{
    NSUInteger paddedLength = self.length + (self.length % 3);
    return [self stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
}

- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString*)md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

- (NSString *)timeStampString2Date
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [self doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

@end
