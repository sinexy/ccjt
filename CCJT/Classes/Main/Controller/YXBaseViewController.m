//
//  YXBaseViewController.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXActivityViewController.h"
#import "YXNavigationController.h"

@interface YXBaseViewController ()

@end

@implementation YXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([YXAppInfoManager shared].isShow) {
//        [self openAvtivityViewController];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - goto
- (void)openAvtivityViewControllerWithTitle:(NSString *)title url:(NSString *)url
{
    YXActivityViewController *activityViewController = [[YXActivityViewController alloc] initWithNavigationTitle:title url:url];
    YXNavigationController *nav = [[YXNavigationController alloc] initWithRootViewController:activityViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -  get data


#pragma mark - layout subviews
- (void)setupUI
{
    
}

#pragma mark - setters and getters


@end
