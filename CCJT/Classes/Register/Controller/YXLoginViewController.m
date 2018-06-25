//
//  YXLoginViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLoginViewController.h"
#import "YXTextFieldView.h"
#import "YXTimeButton.h"
#import "YXTabBarController.h"
#import "YXActivityViewController.h"

@interface YXLoginViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) YXTextFieldView *phoneTextView;
@property (nonatomic, strong) YXTextFieldView *imageIndentifyView;
@property (nonatomic, strong) YXTextFieldView *identifyingView;
@property (nonatomic, strong) YXTimeButton *sendButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, strong) NSString *imgSessionId;

@end

@implementation YXLoginViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getRandomImage];

}

#pragma mark - goto
- (void)openAvtivityViewControllerWithTitle:(NSString *)title url:(NSString *)url
{
    YXActivityViewController *activityViewController = [[YXActivityViewController alloc] initWithNavigationTitle:title url:url];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activityViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -  get data
- (void)logButtonDidClicked
{
    if(![self checkLoninFormdate]) return;
    NSDictionary *params = @{
                             @"mobileNumber":self.phoneTextView.textField.text,
                             @"smsCode":self.identifyingView.textField.text,
                             @"imgCode":self.imageIndentifyView.textField.text,
                             };
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [YXNetworking postWithUrl:@"user/signup" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            YXUserModel *model = [YXUserModel mj_objectWithKeyValues:response[@"data"]];
            model.mobileNumber = self.phoneTextView.textField.text;
            [[YXUserManager shared] setUserModel: model];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[YXTabBarController alloc] init];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];

    }];
}

- (void)sendIdentifyCode
{
    if(![self checkSendCodeFormdate]){
        return;
    }
    
    NSDictionary *params = @{
                             @"mobileNum": self.phoneTextView.textField.text,
                             @"imgSessionId": self.imgSessionId,
                             @"pictureCode": self.imageIndentifyView.textField.text,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"user/smsValidate" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getRandomImage];
            });
            [weakSelf.sendButton startReduce];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [weakSelf getRandomImage];
        }
    } fail:^(NSError *error) {
        [weakSelf getRandomImage];
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
    }];
}

- (void)getRandomImage
{
    self.imageView.userInteractionEnabled = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.imageView.userInteractionEnabled = true;
    });
    NSDictionary *dict = @{
        @"charSize": @(4),
        @"height": @(40*kScale),
        @"typeEnum": @"LOGIN",
        @"width": @(100*kScale)
        };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"common/randomImage" params:dict success:^(id response) {
        YXStrongSelf(weakSelf);
        YXLog(@"%@",response);
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            NSString *baseStr = response[@"data"][@"imgBase64"];
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:baseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            strongSelf.imageView.image = decodedImage;
            strongSelf.imgSessionId = response[@"data"][@"imgSessionId"];
            strongSelf.imageIndentifyView.textField.text = @"";
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        YXLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
    }];
}


#pragma mark - layout subviews

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.imageIndentifyView];
    [self.view addSubview:self.identifyingView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.agreeButton];
    [self.view addSubview:self.protocolButton];
}

#pragma mark - setters and getters

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.frame = CGRectMake((YXScreenW-74*kScale)*0.5, 84*kScale, 74*kScale, 74*kScale);
        _logoImageView.layer.cornerRadius = 8*kScale;
        _logoImageView.clipsToBounds = true;
        _logoImageView.image = [UIImage imageNamed:@"AppIcon"];
    }
    return _logoImageView;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(15, 394*kScale, YXScreenW-30, 44*kScale);
        _loginButton.layer.cornerRadius = 5*kScale;
        [_loginButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        _loginButton.titleLabel.font = kFont17;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(logButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _loginButton;
}

- (YXTextFieldView *)phoneTextView
{
    if (!_phoneTextView) {
        _phoneTextView = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 212*kScale, YXScreenW, 44*kScale) image:[UIImage imageNamed:@"register_phone"] placeHolderText:@"请输入手机号" rightView:nil andIsSecret:NO];
        _phoneTextView.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneTextView;
}

- (YXTextFieldView *)imageIndentifyView
{
    if (!_imageIndentifyView) {
        _imageIndentifyView = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 256*kScale, YXScreenW, 44*kScale) image:[UIImage imageNamed:@"pic_code"] placeHolderText:@"请输入右侧验证码" rightView:self.imageView andIsSecret:false];
//        _imageIndentifyView.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _imageIndentifyView;
}

- (YXTextFieldView *)identifyingView
{
    if (!_identifyingView) {
        _identifyingView = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 300*kScale, YXScreenW, 44*kScale) image:[UIImage imageNamed:@"register_lock"] placeHolderText:@"请输入验证码" rightView:self.sendButton andIsSecret:true];
        _identifyingView.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _identifyingView;
}

- (YXTimeButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [YXTimeButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendButton setTitleColor:kCommonColor forState:UIControlStateNormal];
        _sendButton.titleLabel.font = kFont14;
        [_sendButton addTarget:self action:@selector(sendIdentifyCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100*kScale+44, 40*kScale)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100*kScale, 40*kScale)];
        _imageView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRandomImage)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UIButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.frame = CGRectMake(15, 351*kScale, 30, 30);
        [_agreeButton setImage:[UIImage imageNamed:@"register_agree"] forState:UIControlStateNormal];
    }
    return _agreeButton;
}

- (UIButton *)protocolButton
{
    if (!_protocolButton) {
        _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《注册与服务协议》"];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:kCommonColor
                        range:NSMakeRange(7, 9)];
        [attrStr addAttribute:NSFontAttributeName value:kFont14 range:NSMakeRange(0, attrStr.length)];
        [_protocolButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        _protocolButton.frame = CGRectMake(45, 351*kScale, 250*kScale, 30);
        [_protocolButton addTarget:self action:@selector(protocolButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}

#pragma mark - private method

- (void)protocolButtonDidClicked
{
//
    NSString *url = [NSString stringWithFormat:@"%@/signupAgreement",kApiUrl];
    [self openAvtivityViewControllerWithTitle:@"注册与服务协议" url:url];
}
- (BOOL)checkSendCodeFormdate
{
    if (self.phoneTextView.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return false;
    }
    if (![self.phoneTextView.textField.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return false;
    }
    if (self.imageIndentifyView.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入图像验证码"];
        return false;
    }
    return true;
}

- (BOOL)checkLoninFormdate
{
    if (![self checkSendCodeFormdate]){
        return false;
    }
    if (self.identifyingView.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return false;
    }
    return true;
}

@end
