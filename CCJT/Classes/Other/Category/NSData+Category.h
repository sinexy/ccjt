//
//  YXCategory.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/15.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YXCategory)

- (instancetype) yx_initWithBase64EncodedString:(NSString *)base64String;
- (NSString *) yx_base64EncodedString ;

@end
