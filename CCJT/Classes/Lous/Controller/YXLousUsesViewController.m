//
//  YXLousUsesViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousUsesViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "YXLousCollectionViewCell.h"

#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@interface YXLousUsesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *usesView;
@property (nonatomic, strong) UIView *explainView;
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) NSArray *usesArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation YXLousUsesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithIndex:(NSUInteger)index desc:(NSString *)desc images:(NSMutableArray *)images assets:(NSMutableArray *)assets
{
    if (self = [super init]) {
        _index = index;
        _desc = desc;
        _images = images;
        self.selectedPhotos = [NSMutableArray arrayWithArray:images];
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    }
    return self;
}

#pragma mark - goto


#pragma mark -  get data


#pragma mark - layout subviews
- (void)setupUI
{
    self.navigationItem.title = @"借条用途";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.usesView];
    [self.scrollView addSubview:self.explainView];
    [self.scrollView addSubview:self.pictureView];
    [self.scrollView addSubview:self.saveButton];
}

#pragma mark - setters and getters
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = YXRGB(245, 247, 248);
        _scrollView.contentSize = CGSizeMake(0, 560*kScale+20+40+64);
    }
    return _scrollView;
}

- (UIView *)usesView
{
    if (!_usesView) {
        _usesView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, YXScreenW, 184*kScale)];
        _usesView.backgroundColor = [UIColor whiteColor];
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 5*kScale, 20*kScale)];
        titleView.backgroundColor = kCommonColor;
        [_usesView addSubview:titleView];
        
        UILabel *label = [UILabel new];
        [_usesView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleView.mas_right).offset(10*kScale);
            make.centerY.mas_equalTo(titleView);
        }];
        label.font = kFont14;
        label.text = @"借款用途";
        label.textColor = kSDeepTextColor;
        
        CGFloat w = 90*kScale;
        CGFloat h = 30*kScale;

        for (int i = 0; i < self.usesArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake((16*kScale)+(i%3)*(w+10*kScale), 42*kScale+(i/3)*(20*kScale+h), w, h);
            [button setTitle:self.usesArray[i] forState:UIControlStateNormal];
            button.layer.borderColor = kSDeepTextColor.CGColor;
            button.layer.borderWidth = 1.f;
            button.titleLabel.font = kFont16;
            button.layer.cornerRadius = 5 * kScale;
            [button setTitleColor:kSDeepTextColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_usesView addSubview:button];
            if (i == self.index) {
                button.selected = true;
                button.backgroundColor = kCommonColor;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.selectedButton = button;
            }
        }
        
    }
    return _usesView;
}

- (UIView *)explainView
{
    if (!_explainView) {
        _explainView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+184*kScale, YXScreenW, 160*kScale)];
        _explainView.backgroundColor = [UIColor whiteColor];
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 5*kScale, 20*kScale)];
        titleView.backgroundColor = kCommonColor;
        [_explainView addSubview:titleView];
        
        UILabel *label = [UILabel new];
        [_explainView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleView.mas_right).offset(10*kScale);
            make.centerY.mas_equalTo(titleView);
        }];
        label.font = kFont14;
        label.text = @"补充说明(不超过300字)";
        label.textColor = kSDeepTextColor;
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15*kScale, 42*kScale, 345*kScale, 98*kScale)];
        self.textView.backgroundColor = YXRGB(245, 247, 248);
        self.textView.text = self.desc;
        [_explainView addSubview:self.textView];
    }
    return _explainView;
}

- (UIView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+(184+160)*kScale, YXScreenW, 172*kScale)];
        _pictureView.backgroundColor = [UIColor whiteColor];
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 5*kScale, 20*kScale)];
        titleView.backgroundColor = kCommonColor;
        [_pictureView addSubview:titleView];
        
        UILabel *label = [UILabel new];
        [_pictureView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleView.mas_right).offset(10*kScale);
            make.centerY.mas_equalTo(titleView);
        }];
        label.font = kFont14;
        label.text = @"图片说明(不超过20张)";
        label.textColor = kSDeepTextColor;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100*kScale, 100*kScale);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10*kScale, 40*kScale, YXScreenW-10*kScale, 100*kScale) collectionViewLayout:layout];
        [collectionView registerClass:[YXLousCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.showsHorizontalScrollIndicator = false;
        [_pictureView addSubview:collectionView];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        self.collectionView = collectionView;
    }
    return _pictureView;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(25*kScale, 40+(184+160+172)*kScale, 325*kScale, 44*kScale);
        _saveButton.layer.cornerRadius = 4 * kScale;
        [_saveButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (NSArray *)usesArray
{
    if (!_usesArray) {
        if([YXAppInfoManager shared].purpose.count){
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in [YXAppInfoManager shared].purpose) {
                [arrayM addObject:dict[@"value"]];
            }
            _usesArray = [arrayM copy];
        }else{
            _usesArray = @[@"个体经营",@"消费",@"助学",@"创业",@"租房",@"旅游",@"装修",@"医疗",@"其他",];
        }
    }
    return _usesArray;
}

- (NSMutableArray *)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
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
- (void)buttonDidClicked:(UIButton *)button
{
    self.selectedButton.selected = NO;
    self.selectedButton.backgroundColor = [UIColor clearColor];
    [self.selectedButton setTitleColor:kSDeepTextColor forState:UIControlStateNormal];
    
    button.selected = YES;
    button.backgroundColor = kCommonColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.selectedButton = button;
}

- (void)deleteBtnClik:(UIButton *)sender {
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (void)saveButtonDidClicked
{
    if (!self.selectedButton) {
        [SVProgressHUD showErrorWithStatus:@"请选择借款用途"];
        return;
    }
    NSString *desc = self.textView.text.length ? self.textView.text : @"";
    NSMutableArray *images = [NSMutableArray arrayWithArray:self.selectedPhotos];
    NSMutableArray *assets = [NSMutableArray arrayWithArray:self.selectedAssets];
    
    if (images.count == 0) {
        if (self.lousUsesBlock) {
            self.lousUsesBlock(self.selectedButton.tag,self.selectedButton.currentTitle, desc, images, assets, @"");
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
        return;
    }
    
    YXWeakSelf(self);
    NSString *url = [NSString stringWithFormat:@"systems/upload/%@",[YXUserManager shared].userModel.sessionId];
    [YXNetworking uploadWith:url params:nil pics:images name:@"file" progress:^(NSProgress *progress) {
        YXLog(@"%f",progress.fractionCompleted);
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在保存图片\n%.0f%%",progress.fractionCompleted*100]];
        
    } success:^(id response) {
        YXLog(@"%@",response);
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            if (weakSelf.lousUsesBlock) {
                weakSelf.lousUsesBlock(weakSelf.selectedButton.tag,weakSelf.selectedButton.currentTitle, desc, images, assets, response[@"data"][@"url"]);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        YXLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"保存失败..."];
    }];

}


#pragma mark - uicollectionView delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXLousCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == self.selectedPhotos.count) {
        cell.photoImageView.image = [UIImage imageNamed:@"add_photo"];
        cell.deleteButton.hidden = YES;
    }else{
        cell.photoImageView.image = self.selectedPhotos[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    [cell.deleteButton addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectedPhotos.count) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
        
       
    } else { // preview photos or video / 预览照片或者视频
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 20;
        
        imagePickerVc.allowPickingOriginalPhoto = true;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
//            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
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

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    
    
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    
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
      
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    [_collectionView reloadData];
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [self.selectedAssets addObject:asset];
    [self.selectedPhotos addObject:image];
    [self.collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
