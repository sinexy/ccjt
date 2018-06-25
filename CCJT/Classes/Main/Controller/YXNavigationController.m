//
//  YXBaseNavigationController.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXNavigationController.h"

@interface YXNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YXNavigationController

#pragma mark - life cycle
+ (void)initialize {
    
    UINavigationBar *navBar = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        
    }else {
        
        navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    }
    navBar.shadowImage = [UIImage new];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale],
                                   NSForegroundColorAttributeName:[UIColor whiteColor],
                                   };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupPan];
}


/**
 设置导航栏
 */
- (void)setupNavBar{
    
    UINavigationBar *navBar = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        
    }else {
        
        navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    }
    navBar.shadowImage = [UIImage new];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale],
                                   NSForegroundColorAttributeName:[UIColor whiteColor],
                                   };
}

- (void)transparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18*kScale]}];
}

- (void)opaqueNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale]}];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonTextColor,NSFontAttributeName:[UIFont systemFontOfSize:18*kScale]}];
}

// MARK: 设置全屏滑动返回
- (void)setupPan{
    
    //WZLog(@"%@",self.interactivePopGestureRecognizer);
    // 全屏滑动返回手势,利用系统的tagget和action实现,并禁止系统的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(backButtonClicked)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    // 禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
}


// MARK:  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 如果不是栈底控制器才触发手势
    return self.childViewControllers.count > 1;
}

// MARK: - 拦截系统的push方法统一设置返回按钮样式和TarBar的隐藏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithImage:@"back_black" highImage:nil target:self action:@selector(backButtonClicked)];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backButtonClicked
{
    if (self.childViewControllers.count > 0) {
        [self popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
