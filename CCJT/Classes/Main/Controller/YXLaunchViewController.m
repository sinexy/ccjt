//
//  YXLaunchViewController.m
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLaunchViewController.h"
#import "YXTabBarController.h"
#import "YXLoginViewController.h"

@interface YXLaunchViewController ()

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation YXLaunchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoading = NO;
    
    [self setupUI];
    [self registerNotification];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGINNOTIFICATION object:nil];
}

#pragma mark - layout subviews
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([YXAppInfoManager shared].welcomePage.length > 0) {
        [self.launchImageView sd_setImageWithURL:[NSURL URLWithString:[YXAppInfoManager shared].welcomePage] placeholderImage:nil options:SDWebImageRefreshCached];
    }
    [_launchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    if ([YXAppInfoManager shared].isFirst) {
        [self.view addSubview:self.launchImageView];
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (iphoneX) {
            commitButton.frame = CGRectMake(25*kScale, 520*kScale+44, YXScreenW-50*kScale, 44*kScale);
        }else{
            commitButton.frame = CGRectMake(25*kScale, 520*kScale, YXScreenW-50*kScale, 44*kScale);
        }

        commitButton.layer.cornerRadius = 4*kScale;
        [commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [commitButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitButton.titleLabel.font = kFont18;
        [commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:commitButton];
    }else{
        if ([YXAppInfoManager shared].isSueecss) {
             [self loadData];
        }else{
            [self loadInitInfo];
        }
    }
}

#pragma mark - get data
- (void)loadData{
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    
    if ([YXAppInfoManager shared].isUpdate) {
        [self showAlert];
        self.isLoading = NO;

        return;
    }
    [self rootVC];
}

// 跳转商店
- (void)rightBtnDidClick {
    
//    NSString * webLink = [YXAppInfoManager shared].iosVersion.downloadAdress;
    NSString * webLink = @"itms-apps://itunes.apple.com/app/id1288528444";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
}

- (void)rootVC
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([YXUserManager shared].isLogin) {
            self.isLoading = NO;
            [UIApplication sharedApplication].keyWindow.rootViewController = [[YXTabBarController alloc] init];
        }else{
            self.isLoading = NO;
            YXLoginViewController *loginViewController = [[YXLoginViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = loginViewController;
        }
    });
}

#pragma mark - setter and getter
- (UIImageView *)launchImageView {
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc] init];
        _launchImageView.frame = CGRectMake(0, 0, YXScreenW, YXScreenH);
        _launchImageView.contentMode = UIViewContentModeScaleAspectFit;
        _launchImageView.image = [UIImage imageNamed:@"new_feature"];
        
    }
    return _launchImageView;
}

#pragma mark - private method
- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[YXAppInfoManager shared].iosVersion.title message:[YXAppInfoManager shared].iosVersion.remark preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
//                                                              NSLog(@"action = %@", action);
                                                              [self rightBtnDidClick];
                                                          }];
    [alert addAction:defaultAction];

    if (![YXAppInfoManager shared].iosVersion.isForce){
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 [self rootVC];
                                                             }];
        [alert addAction:cancelAction];
    }

    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 初始化app
- (void)loadInitInfo
{
    YXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中..."];
    [YXNetworking getWithUrl:@"index/initProject" success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]){
            YXAppInfoManager *manager = [YXAppInfoManager shared];
            manager.iosVersion = [YXAppInfoModel mj_objectWithKeyValues:response[@"data"][@"iosVersion"]];
            manager.isSueecss = true;
            manager.purpose = response[@"data"][@"purpose"];
            manager.activities = response[@"data"][@"activities"];
            manager.isFirst = false;
//            [weakSelf.launchImageView sd_setImageWithURL:response[@"date"][@"welcomePage"] placeholderImage:nil options:SDWebImageRefreshCached];
            [weakSelf loadData];
            [SVProgressHUD dismiss];

        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络问题..."];
    }];
}

- (void)commitButtonDidClicked
{
    [self loadInitInfo];
}

#pragma mark - notification
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:DIDBECOMEACTIVENOTIFICATION object:nil];
}
@end
