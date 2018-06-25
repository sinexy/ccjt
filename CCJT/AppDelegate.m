//
//  AppDelegate.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/6.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "AppDelegate.h"
#import "YXLaunchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Bugly/Bugly.h>
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [YXNetworking shared].baseUrl = kApiUrl;
    [Bugly startWithAppId:kBuglyAppId];
    [SVProgressHUD setMinimumDismissTimeInterval:1.8];
    [WXApi registerApp:kWXApiAppId];
    [self setupKeyboard];
    [self loadInitInfo];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.window.rootViewController = [[YXLaunchViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupKeyboard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
//    keyboardManager.toolbarDoneBarButtonItemText = @"收起";
    keyboardManager.toolbarDoneBarButtonItemImage = [UIImage imageNamed:@"back_downArrow"];
//    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - 初始化app
- (void)loadInitInfo
{
    [YXNetworking getWithUrl:@"index/initProject" success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]){
            YXAppInfoManager *manager = [YXAppInfoManager shared];
            manager.iosVersion = [YXAppInfoModel mj_objectWithKeyValues:response[@"data"][@"iosVersion"]];
            manager.welcomePage = response[@"data"][@"welcomePage"];
            manager.isSueecss = true;
            manager.purpose = response[@"data"][@"purpose"];
            manager.activities = response[@"data"][@"activities"];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络问题..."];
    }];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
     return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    YXLog(@"%@",@"------");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    YXLog(@"%@",@"进入后台");

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    YXLog(@"%@",@"进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    YXLog(@"%@",@"开始活跃");
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDBECOMEACTIVENOTIFICATION object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// MARK:   WXApiDelegate
-(void)onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        // 发送微信支付结果通知
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti postNotificationName:kWeiXinPayResultNotification object:resp];

    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        // 发送微信分享结果通知
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti postNotificationName:kWeiXinSendMessageResultNotification object:resp];
    }
    
}

@end
