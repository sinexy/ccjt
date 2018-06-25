//
//  Target_MyLous.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "Target_MyLous.h"
#import "YXMyLousViewController.h"

@implementation Target_MyLous

- (UIViewController *)action_nativeFetchMyLousViewController:(NSDictionary *)params
{
    
    YXMyLousViewController *viewController = [[YXMyLousViewController alloc] init];
    return viewController;
}

@end
