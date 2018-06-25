//
//  Target_Home.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "Target_Home.h"
#import "YXHomeViewController.h"

@implementation Target_Home

- (UIViewController *)action_nativeFetchHomeViewController:(NSDictionary *)params
{
    // 因为action是从属于模块Home的，所以action直接可以使用home模块中的所有声明
    YXHomeViewController *viewController = [[YXHomeViewController alloc] init];
    return viewController;
}


@end
