//
//  YXLousDetailsViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousDetailsViewController.h"
#import "YXLousDetailsTableViewCell.h"
#import "YXLousDetailsHeaderView.h"
#import "YXLousDetalisModel.h"
#import "YXActivityViewController.h"
#import "YXNavigationController.h"

@interface YXLousDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXLousDetailsHeaderView *headerView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView *lenderFooterView;
@property (nonatomic, strong) UIView *borrowerFooterView;
@property (nonatomic, strong) NSString *footButtonString;

@end

@implementation YXLousDetailsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithModel:(YXLousDetalisModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark - goto
- (void)openAvtivityViewControllerWithTitle:(NSString *)title url:(NSString *)url
{
    YXActivityViewController *activityViewController = [[YXActivityViewController alloc] initWithNavigationTitle:title url:url];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activityViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -  get data


#pragma mark - layout subviews
- (void)setupUI
{
    self.navigationItem.title = @"借条详情";
    [self.navigationController performSelector:@selector(opaqueNavigationBar)];

    [self.view addSubview:self.tableView];
}

#pragma mark - setters and getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 48*kScale;
        [_tableView registerClass:[YXLousDetailsTableViewCell class] forCellReuseIdentifier:@"cell"];
       

        if (self.model.status == 1) {   // 待接受
            if ([self.model.sendUuid isEqualToString:[YXUserManager shared].userModel.authUuid]) {    // 当前用户是发起人
                self.footButtonString = @"取消";
                _tableView.tableFooterView = self.lenderFooterView;
            }else{
                _tableView.tableFooterView = self.borrowerFooterView;
            }
        }else if (self.model.status == 2) { // 进行中
            if ([self.model.lenderAuthUuid isEqualToString:[YXUserManager shared].userModel.authUuid]) {    // 当前用户是出借人
                self.footButtonString = @"结束借条";
                _tableView.tableFooterView = self.lenderFooterView;
            }else{
                _tableView.tableFooterView = [UIView new];
            }
        }else{
            _tableView.tableFooterView = [UIView new]; 
        }
        _tableView.tableHeaderView = self.headerView;
        
    }
    return _tableView;
}

- (YXLousDetailsHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[YXLousDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 83*kScale+20)];
        
        switch (self.model.status) {
            case 1:
                _headerView.iconImageView.image = [UIImage imageNamed:@"lous_wating"];
                _headerView.state.text = @"待确认";
                self.footButtonString = @"取消借条";
                break;
            case 2:
                _headerView.iconImageView.image = [UIImage imageNamed:@"lous_doing"];
                _headerView.state.text = @"进行中";
                self.footButtonString = @"结束借条";
                break;
            case 3:
                _headerView.iconImageView.image = [UIImage imageNamed:@"lous_end"];
                _headerView.state.text = @"取消";
                break;
            case 4:
                _headerView.iconImageView.image = [UIImage imageNamed:@"lous_end"];
                _headerView.state.text = @"驳回";
                break;
            case 5:
                _headerView.iconImageView.image = [UIImage imageNamed:@"lous_end"];
                _headerView.state.text = @"结束";
                break;
            default:
                break;
        }
        
        _headerView.date.text = [NSString stringWithFormat:@"创建时间：%@",[self.model.createTime timeStampString2Date]];
    }
    return _headerView;
}

- (UIView *)lenderFooterView
{
    if (!_lenderFooterView) {
        _lenderFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 64*kScale)];
        
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commitButton.frame = CGRectMake(25*kScale, 0*kScale, YXScreenW-50*kScale, 44*kScale);
        commitButton.layer.cornerRadius = 4*kScale;
        [commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [commitButton setTitle:self.footButtonString forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitButton.titleLabel.font = kFont18;
        [commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_lenderFooterView addSubview:commitButton];
    }
    return _lenderFooterView;
}

- (UIView *)borrowerFooterView
{
    if (!_borrowerFooterView) {
        _borrowerFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 64*kScale)];
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(25*kScale, 0*kScale, (YXScreenW-50*kScale)*0.5-10, 44*kScale);
        cancel.layer.cornerRadius = 4*kScale;
        [cancel setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [cancel setTitle:@"驳回" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = kFont18;
        [cancel addTarget:self action:@selector(cancelDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_borrowerFooterView addSubview:cancel];

        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commitButton.frame = CGRectMake((YXScreenW-50*kScale)*0.5+30, 0*kScale, (YXScreenW-50*kScale)*0.5-10, 44*kScale);
        commitButton.layer.cornerRadius = 4*kScale;
        [commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [commitButton setTitle:@"接受" forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitButton.titleLabel.font = kFont18;
        [commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_borrowerFooterView addSubview:commitButton];
    }
    return _borrowerFooterView;
}


- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"借款人:",@"出借人:",@"借款金额:",@"借款日期:",@"还款日期:",@"借款利率:",@"借款用途:",@"补充说明:",@"借款协议:",];
    }
    return _titleArray;
}

#pragma mark - private method
- (void)commitButtonDidClicked
{
    if (![YXUserManager shared].isRealName) {
        [SVProgressHUD showErrorWithStatus:@"请先实名认证"];
        return;
    }
   __block NSString *isSenderOrReceiver;
   __block NSString *status;
    /**
     * status  :  1-待确认  2-确认  3-取消  4-驳回  5-结束
     */
    if (self.model.status == 1) {   // 待接受
        if ([self.model.sendUuid isEqualToString:[YXUserManager shared].userModel.authUuid]) {    // 当前用户是发起者
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您正在取消借条，请确认！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                isSenderOrReceiver = @"sender";
                status = @"3";
                [SVProgressHUD showWithStatus:@"正在取消借条"];
                [self sure:isSenderOrReceiver status:status];
            }];
            [alert addAction:cancel];
            [alert addAction:commit];
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您正在确认借条，请确认！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                isSenderOrReceiver = @"receiver";
                status = @"2";
                [SVProgressHUD showWithStatus:@"正在确认借条"];
                [self sure:isSenderOrReceiver status:status];
            }];
            [alert addAction:cancel];
            [alert addAction:commit];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }else if (self.model.status == 2) { // 进行中
        if ([self.model.lenderAuthUuid isEqualToString:[YXUserManager shared].userModel.authUuid]) {    // 当前用户是出借人
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您正在结束借条，请确认！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                isSenderOrReceiver = @"sender";
                status = @"5";
                [SVProgressHUD showWithStatus:@"正在结束借条"];
                [self sure:isSenderOrReceiver status:status];
            }];
            [alert addAction:cancel];
            [alert addAction:commit];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
   
}

- (void)sure:(NSString *)isSenderOrReceiver status:(NSString *)status
{
    NSDictionary *params = @{
                             @"isSenderOrReceiver":isSenderOrReceiver,
                             @"orderId": self.model.uuid,
                             @"status":status,
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/updateOrderStatus" params:params success:^(id response) {
        
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEORDERSUCCESSNOTIFICATION object:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
        
    }];
}

- (void)cancelDidClicked
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您正在驳回借条，请确认！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *params = @{
                                 @"isSenderOrReceiver":@"receiver",
                                 @"orderId": self.model.uuid,
                                 @"status":@4,
                                 @"userUuid":[YXUserManager shared].userModel.userUuid,
                                 @"sessionId":[YXUserManager shared].userModel.sessionId,
                                 };
        YXWeakSelf(self);
        [SVProgressHUD showWithStatus:@"正在驳回借条"];
        
        [YXNetworking postWithUrl:@"order/updateOrderStatus" params:params success:^(id response) {
            if ([response[@"code"] isEqualToString:@"msg_0001"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
                [SVProgressHUD showSuccessWithStatus:@"成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEORDERSUCCESSNOTIFICATION object:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"message"]];
            }
        } fail:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误..."];
            
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:commit];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLousDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.itemLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.contentLabel.text = self.model.borrowerName;

    }else if (indexPath.row == 1){
        cell.contentLabel.text = self.model.lenderName;

    }
    else if (indexPath.row == 2){
        cell.contentLabel.text = self.model.amount;

    }
    else if (indexPath.row == 3){
        cell.contentLabel.text = [self.model.lendingTime timeStampString2Date];
    }
    else if (indexPath.row == 4){
        cell.contentLabel.text = [self.model.refundTime timeStampString2Date];
    }
    else if (indexPath.row == 5){
        cell.contentLabel.text = [NSString stringWithFormat:@"年化%@%%",self.model.rateYear];
    }
    else if (indexPath.row == 6){
        cell.contentLabel.text = self.model.loanPurpose;
    }
    else if (indexPath.row == 7){
        cell.contentLabel.text = self.model.remark;
    }else if (indexPath.row == 8){
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"点击查看" attributes:@{NSForegroundColorAttributeName : kCommonColor}];
        cell.contentLabel.attributedText = string;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 8) {
        NSString *url = [NSString stringWithFormat:@"%@/order/iouAgreement?iouUuid=%@",kApiUrl,self.model.uuid];

        [self openAvtivityViewControllerWithTitle:@"借款协议" url:url];
    }
}
@end
