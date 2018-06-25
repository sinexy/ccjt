//
//  YXCategory.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/15.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "NSData+Category.h"

@implementation NSData (YXCategory)

- (instancetype) yx_initWithBase64EncodedString:(NSString *)base64String {
    return [self initWithBase64Encoding:[base64String stringPaddedForBase64]];
}

- (NSString *) yx_base64EncodedString {
    return [self base64Encoding];
}

@end
