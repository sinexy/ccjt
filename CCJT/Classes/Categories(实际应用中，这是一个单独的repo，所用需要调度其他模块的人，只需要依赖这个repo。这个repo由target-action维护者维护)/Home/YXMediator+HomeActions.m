//
//  YXMediator+HomeActions.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/7.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXMediator+HomeActions.h"


NSString * const kYXMediatorTargetHome = @"Home";

NSString * const kYXMediatorActionNativFetchHomeViewController = @"ativFetchHomeViewController";

@implementation YXMediator (HomeActions)

- (UIViewController *)YXMediator_viewControllerForHome
{
    UIViewController *viewController = [self performTarget:kYXMediatorTargetHome action:kYXMediatorActionNativFetchHomeViewController params:@{@"key":@"value"} shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        // 异常处理场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
