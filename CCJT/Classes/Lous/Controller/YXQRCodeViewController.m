//
//  YXQRCodeViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/20.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXQRCodeViewController.h"
#import "WXApi.h"

@interface YXQRCodeViewController ()
@property (nonatomic, strong) UIImage *image;
@end

@implementation YXQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done) name:kWeiXinSendMessageResultNotification object:nil];
}

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

- (void)setupUI
{
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"QRcode_bg"];
    [self.view addSubview:bg];
    YXWeakSelf(self);
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(110*kScale);
        
    }];
    
    
    self.view.backgroundColor = YXGray(248);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    if (iphoneX) {
        button.frame = CGRectMake(20*kScale, 50, 44, 44);
    }else{
        button.frame = CGRectMake(20*kScale, 25, 44, 44);
    }
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:YXRGB(91, 91, 93) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [UILabel new];
    label.text = @"发送给好友或面对面扫一扫\n下方二维码";
    label.textColor = YXRGB(91, 91, 93);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(130*kScale);
        make.width.mas_equalTo(300*kScale);
    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(160*kScale);
        make.height.mas_equalTo(160*kScale);
        make.top.mas_equalTo(label.mas_bottom).mas_offset(50*kScale);
    }];
    self.image = [UIImage imageWithURLString:self.urlString];
    imageView.image = self.image;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(25*kScale, 480*kScale, YXScreenW-50*kScale, 44*kScale);
    commitButton.layer.cornerRadius = 4*kScale;
    [commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
    [commitButton setTitle:@"发送给微信用户" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.titleLabel.font = kFont18;
    [commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
}

- (void)closeButtonDidClicked
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)commitButtonDidClicked
{
    [SVProgressHUD showInfoWithStatus:@"正在打开微信"];
    [self sharedLinkToWeChat:@"草船借条" description:@"快来借钱啊！！！" detailUrl:self.urlString image:self.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//网页类型分享
- (BOOL)sharedLinkToWeChat:(NSString *)title
               description:(NSString *)description
                 detailUrl:(NSString *)detailUrl
                     image:(UIImage *)image
{
//    UIImage *compressedImage = [image imageWithFileSize:32*1024 scaledToSize:CGSizeMake(300, 300)];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = detailUrl;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText= NO;
    req.message = message;
    req.scene = WXSceneSession;
    BOOL success = [WXApi sendReq:req];
    return success;
}

- (void)done
{
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self closeButtonDidClicked];
//    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
