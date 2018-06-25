//
//  Target_Lous.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "Target_Lous.h"
#import "YXLousViewController.h"

@implementation Target_Lous

- (UIViewController *)action_nativeFetchLousViewController:(NSDictionary *)params
{
    
    YXLousViewController *viewController = [[YXLousViewController alloc] init];
    return viewController;
}

@end
