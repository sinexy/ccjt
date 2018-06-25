//
//  Target_Me.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "Target_Me.h"
#import "YXMeViewController.h"

@implementation Target_Me

- (UIViewController *)action_nativeFetchMeViewController:(NSDictionary *)params
{
    YXMeViewController *viewController = [[YXMeViewController alloc] init];
    return viewController;
}
@end
