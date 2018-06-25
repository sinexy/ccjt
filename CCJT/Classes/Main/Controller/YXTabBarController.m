//
//  YXTabBarController.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXTabBarController.h"
#import "YXNavigationController.h"
#import "YXHomeViewController.h"
#import "YXLousViewController.h"
#import "YXMyLousViewController.h"
#import "YXMeViewController.h"

@interface YXTabBarController ()

@end

@implementation YXTabBarController

+ (void)load{
    
    UITabBarItem *item = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        item =  [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    }else {
        item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    }
    
    NSMutableDictionary *norDict = [NSMutableDictionary dictionary];
    norDict[NSFontAttributeName] = kFont10;
    
    NSMutableDictionary *selDict = [NSMutableDictionary dictionary];
    selDict[NSForegroundColorAttributeName] = YXRGB(0, 122, 255);
    
    [item setTitleTextAttributes:norDict forState:UIControlStateNormal];
    [item setTitleTextAttributes:selDict forState:UIControlStateSelected];
    
    UITabBar * tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    tabBar.shadowImage = [UIImage yx_imageWithColor:YXGray(240)];
    [tabBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addAllChildVC];

}

// MARK: -  添加子控制器

/**
 添加所有的子控制器
 */
- (void)addAllChildVC{
    // 主页
    [self addChildeVC:[YXHomeViewController new] imageName:@"tabbar_home_normal" selectedImgeName:@"tabbar_home_selected" title:@"首页"];
    // 趣买
    [self addChildeVC:[YXLousViewController new] imageName:@"tabbar_lous_normal" selectedImgeName:@"tabbar_lous_selected" title:@"打借条"];
    // 购劵
    [self addChildeVC:[YXMyLousViewController new] imageName:@"tabbar_mylous_normal" selectedImgeName:@"tabbar_mylous_selected" title:@"我的借条"];
    // 个人中心
    [self addChildeVC:[YXMeViewController new] imageName:@"tabbar_me_normal" selectedImgeName:@"tabbar_me_selected" title:@"我的"];
}

/**
 添加一个子控制器
 @param vc VC
 @param imageName 图片名
 @param selectedImageName  选中图片名
 @param title titleStr
 */
- (void)addChildeVC:(UIViewController *)vc imageName:(NSString *)imageName selectedImgeName:(NSString *)selectedImageName title:(NSString *)title{
    
    YXNavigationController *nav = [[YXNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    nav.tabBarItem.selectedImage = [UIImage yx_imageWithOriginal:selectedImageName];
    
    static NSInteger index = 10;
    nav.tabBarItem.tag = index;
    index ++;
    
    [self addChildViewController:nav];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    YXLog(@"%@",item);
}


@end
