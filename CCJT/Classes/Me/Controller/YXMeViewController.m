//
//  YXMeViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXMeViewController.h"
#import "YXCountView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "YXLoginViewController.h"
#import "YXSearchLousViewController.h"
#import "YXMyLousModel.h"

@interface YXMeViewController ()<YXCountViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) YXCountView *countView;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) YXMyLousModel *model;

@end

@implementation YXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(transparentNavigationBar)];
    [self loadNewData];

}

#pragma mark - goto
- (void)gotoSearchLousViewController:(NSUInteger)type
{
    YXSearchLousViewController *vc = [[YXSearchLousViewController alloc] initWithType:type withModel:self.model];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark -  get data

- (void)loadNewData
{
    NSDictionary *params = @{
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/myRecordDetail" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            weakSelf.model = [YXMyLousModel mj_objectWithKeyValues:response[@"data"]];
            weakSelf.countView.leftLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.model.repaymentSumAmount];
            weakSelf.countView.rightLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.model.receivableSumAmount];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
    }];
}

#pragma mark - layout subviews
- (void)setupUI
{
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = YXGray(248);
    [self.view addSubview:self.topView];
    [self.view addSubview:self.countView];
    [self.view addSubview:self.logoutButton];
}

#pragma mark - setters and getters
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 181*kScale)];
        if (iphoneX) {
            _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 117*kScale+88)];
        }
        [_topView set_yxbackgroundImage:@"me_top_bg" ofType:nil];
        self.avatarImageView = [UIImageView new];
        [_topView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topView).offset(55*kScale);
            if (iphoneX) {
                make.top.mas_equalTo(_topView).offset(5*kScale+88);
            }else{
                make.top.mas_equalTo(_topView).offset(65*kScale);
            }
            make.width.mas_equalTo(52*kScale);
            make.height.mas_equalTo(52*kScale);
        }];
        self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
        self.avatarImageView.layer.cornerRadius = 52*0.5*kScale;
        self.avatarImageView.clipsToBounds = true;
//        self.avatarImageView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageDidClicked)];
        [self.avatarImageView addGestureRecognizer:tap];
        
        self.phoneLabel = [UILabel new];
        [_topView addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(8*kScale);
            make.centerY.mas_equalTo(self.avatarImageView);
        }];
        self.phoneLabel.textColor = [UIColor whiteColor];
        self.phoneLabel.font = kFont20;
        NSString *phoneNumber;
        if ([YXUserManager shared].isLogin) {
            phoneNumber = [[YXUserManager shared].userModel.mobileNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        if ([YXUserManager shared].isRealName) {
            phoneNumber = [[YXUserManager shared].userModel.realName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        }
        self.phoneLabel.text = phoneNumber;
    }
    return _topView;
}

- (YXCountView *)countView
{
    if (!_countView) {
        _countView = [[YXCountView alloc] initWithFrame:CGRectMake(25*kScale, 20+117*kScale, YXScreenW-50*kScale, 125*kScale)];
        if (iphoneX) {
            _countView = [[YXCountView alloc] initWithFrame:CGRectMake(25*kScale, 24+20+117*kScale, YXScreenW-50*kScale, 125*kScale)];
        }
        _countView.delegate = self;
    }
    return _countView;
}

- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(25*kScale, YXScreenH-114*kScale-44*kScale, YXScreenW-50*kScale, 44*kScale);
        if (iphoneX) {
            _logoutButton.frame = CGRectMake(25*kScale, YXScreenH-114*kScale-44*kScale-34, YXScreenW-50*kScale, 44*kScale);
        }
        _logoutButton.layer.cornerRadius = 4*kScale;
        [_logoutButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = kFont18;
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

#pragma mark - private method
- (void)avatarImageDidClicked
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}

- (void)logout
{
    [[YXUserManager shared] setUserModel: [YXUserModel new]];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[YXLoginViewController alloc] init];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}


#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    
    
    // 1.设置目前已经选中的图片数组
    //    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingImage = true;
    imagePickerVc.allowPickingOriginalPhoto = true;
    imagePickerVc.showSelectBtn = NO;
    
#pragma mark - 到这里为止
    
    //    // You can get the photos by block, the same as by delegate.
    //    // 你可以通过block或者代理，来得到用户选择的照片.
    //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    //
    //    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        self.avatarImageView.image = [image yx_imageCompressForSize:CGSizeMake(100, 100)];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.avatarImageView.image = [photos.firstObject yx_imageCompressForSize:CGSizeMake(100, 100)];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - countViewDelegate
- (void)countView:(YXCountView *)countView didSelectedIndex:(NSUInteger)index
{
    [self gotoSearchLousViewController:index];

}
@end
