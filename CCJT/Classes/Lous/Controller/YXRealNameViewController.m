//
//  YXRealNameViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/13.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXRealNameViewController.h"
#import "YXTextFieldView.h"
#import "YXTimeButton.h"

@interface YXRealNameViewController ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) YXTextFieldView *name;
@property (nonatomic, strong) YXTextFieldView *imageIndentifyView;
@property (nonatomic, strong) YXTextFieldView *identification;
@property (nonatomic, strong) YXTextFieldView *phone;
@property (nonatomic, strong) YXTextFieldView *code;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) YXTimeButton *timeButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *imgSessionId;

@end

@implementation YXRealNameViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getRandomImage];
}

#pragma mark - layout subviews

- (void)setupUI
{
    self.navigationItem.title = @"实名认证";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale]}];
    
    self.view.backgroundColor = YXGray(248);
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.name];
    [self.view addSubview:self.identification];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.imageIndentifyView];
    [self.view addSubview:self.code];
    [self.view addSubview:self.commitButton];
    [self layoutSubViews];
}

- (void)layoutSubViews
{
    YXWeakSelf(self);
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view).offset(20*kScale);
    }];
}

#pragma mark - goto

#pragma mark - get date


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
                           @"width": @(100*kScale),
                           @"sessionId":[YXUserManager shared].userModel.sessionId,
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

- (void)commitButtonDidClicked
{
    if(![self checkDataFormat]){
        return;
    }
    NSDictionary *params = @{
                             @"idCard":self.identification.textField.text,
                             @"mobile":self.phone.textField.text,
                             @"name":self.name.textField.text,
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             @"smsCode":self.code.textField.text,
                             };
    YXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"正在确认..."];
    [YXNetworking postWithUrl:@"user/carrierAuth" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            YXUserModel *model = [YXUserModel mj_objectWithKeyValues:response[@"data"][@"userDto"]];
            model.idCard = weakSelf.identification.textField.text;
            model.realName = weakSelf.name.textField.text;
            [[YXUserManager shared] setUserModel: model];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];

    }];
}


- (void)sendIdentifyCode
{
    if(![self checkIdentification]){
        return;
    }
    
    NSDictionary *params = @{
                             @"mobileNum": self.phone.textField.text,
                             @"imgSessionId": self.imgSessionId,
                             @"pictureCode": self.imageIndentifyView.textField.text,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"user/smsValidate" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [weakSelf.timeButton startReduce];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"data"][@"errorMsg"]];
            [weakSelf getRandomImage];
        }
    } fail:^(NSError *error) {
        [weakSelf getRandomImage];
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
    }];
}

#pragma mark - setter and getter

- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.font = kFont20;
        _topLabel.textColor = YXRGB(247, 113, 25);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"您尚未进行实名认证！\n请完成实名之后，确认借条";
        _topLabel.numberOfLines = 0;
    }
    return _topLabel;
}

- (YXTextFieldView *)name
{
    if (!_name) {
        _name = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 97, YXScreenW, 48*kScale) text:@"姓名:" placeHolderText:@"请输入您的姓名" rightView:nil andIsSecret:NO];
    }
    return _name;
}

- (YXTextFieldView *)identification
{
    if (!_identification) {
        _identification = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 97+1*48*kScale, YXScreenW, 48*kScale) text:@"身份证号:" placeHolderText:@"请输入您的身份证号码" rightView:nil andIsSecret:NO];
    }
    return _identification;
}

- (YXTextFieldView *)phone
{
    if (!_phone) {
        _phone = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 97+2*48*kScale, YXScreenW, 48*kScale) text:@"手机号码:" placeHolderText:@"请输入您的手机号码" rightView:nil andIsSecret:NO];
    }
    return _phone;
}

- (YXTextFieldView *)imageIndentifyView
{
    if (!_imageIndentifyView) {
        _imageIndentifyView = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 97+3*48*kScale, YXScreenW, 48*kScale) text:@"图形验证码:" placeHolderText:@"请输入右侧验证码" rightView:self.imageView andIsSecret:NO];
    }
    return _imageIndentifyView;
}

- (YXTextFieldView *)code
{
    if (!_code) {
        _code = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 97+4*48*kScale, YXScreenW, 48*kScale) text:@"验证码:" placeHolderText:@"请输入验证码" rightView:self.timeButton andIsSecret:NO];
    }
    return _code;
}

- (UIButton *)commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(25*kScale, 97+6*48*kScale, YXScreenW-50*kScale, 44*kScale);
        _commitButton.layer.cornerRadius = 4*kScale;
        [_commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [_commitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        _commitButton.titleLabel.font = kFont18;
        [_commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (YXTimeButton *)timeButton
{
    if (!_timeButton) {
        _timeButton = [YXTimeButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timeButton setTitleColor:kCommonColor forState:UIControlStateNormal];
        _timeButton.titleLabel.font = kFont14;
        [_timeButton addTarget:self action:@selector(sendIdentifyCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeButton;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100*kScale, 40*kScale)];
        _imageView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getRandomImage)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

#pragma mark - private method

- (BOOL)checkIdentification
{
    if (self.name.textField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return false;
    }
    if (self.identification.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
        return false;
    }
    if (![self.identification.textField.text isIdentification]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
        return false;
    }
    if (self.phone.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return false;
    }
    if (![self.phone.textField.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return false;
    }
    if (self.imageIndentifyView.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入右侧验证码"];
        return false;
    }
    return true;
}

- (BOOL)checkDataFormat
{
    if (![self checkIdentification]) {
        return false;
    }
    if (self.code.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return false;
    }
    return true;
}

@end
