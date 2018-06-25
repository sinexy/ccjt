//
//  YXHomeViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXHomeViewController.h"
#import "YXActivityViewController.h"
#import "YXCountView.h"
#import "YXLatelyView.h"
#import "YXSearchLousViewController.h"
#import "YXLousDetailsViewController.h"
#import "YXLousDetalisModel.h"
#import "YXHomeTableViewCell.h"
#import "TestViewController.h"

@interface YXHomeViewController ()<YXCountViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) YXCountView *countView;
@property (nonatomic, strong) YXNoDataView *noDataView;
@property (nonatomic, strong) YXLatelyView *latelyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) CGFloat repaymentSumAmount;   // 待还
@property (nonatomic, assign) CGFloat receivableSumAmount;  // 待收
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation YXHomeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([YXAppInfoManager shared].isActivity) {
        NSDictionary *dict = [YXAppInfoManager shared].activities;
        if([dict[@"position"] isEqualToString:@"1"]){
            [self openAvtivityViewControllerWithTitle:dict[@"remark"] url:dict[@"activityAdUrl"]];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:UPDATEORDERSUCCESSNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:CREATEORDERSUCCESSNOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(transparentNavigationBar)];
}

#pragma mark - goto
- (void)commitButtonDidClicked
{
//    TestViewController *test = [[TestViewController alloc] init];
//    [self.navigationController pushViewController:test animated:YES];
    self.tabBarController.selectedIndex = 1;
}


#pragma mark -  get data
- (void)loadNewData
{
    self.noDataView.hidden = NO;
    self.latelyView.hidden = YES;
    self.pageNumber = 0;
    NSDictionary *params = @{
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"pageNumber":@(self.pageNumber),
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/findRecords" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [weakSelf.dataArray removeAllObjects];
            NSArray *array = [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderRecordPage"][@"content"]];
            if (array.count == 0) {
                self.noDataView.hidden = NO;
                self.tableView.hidden = YES;
            }else{
                self.noDataView.hidden = YES;
                self.tableView.hidden = NO;
            }
            [weakSelf.dataArray addObjectsFromArray: array];
            weakSelf.receivableSumAmount = [response[@"data"][@"receivableSumAmount"] floatValue];
            weakSelf.repaymentSumAmount = [response[@"data"][@"repaymentSumAmount"] floatValue];
            weakSelf.pageNumber++;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            weakSelf.countView.leftLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.repaymentSumAmount];
            weakSelf.countView.rightLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.receivableSumAmount];

        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [weakSelf.tableView.mj_header endRefreshing];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData
{
    NSDictionary *params = @{
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"pageNumber":@(self.pageNumber),
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/findRecords" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            
            [weakSelf.dataArray addObjectsFromArray: [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderRecordPage"][@"content"]]];
            weakSelf.receivableSumAmount = [response[@"data"][@"receivableSumAmount"] floatValue];
            weakSelf.repaymentSumAmount = [response[@"data"][@"repaymentSumAmount"] floatValue];
            weakSelf.pageNumber++;
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            weakSelf.countView.leftLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.repaymentSumAmount];
            weakSelf.countView.rightLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.receivableSumAmount];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - layout subviews
- (void)setupUI
{
    self.navigationItem.title = @"借条";

    self.view.backgroundColor = YXGray(248);
    YXWeakSelf(self);
    
    [self.view addSubview:self.topBackView];
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(174*kScale);
    }];
    
    [self.view addSubview:self.noDataView];
    [self.view addSubview:self.countView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitButton];

}

#pragma mark - setters and getters

- (YXCountView *)countView
{
    if (!_countView) {
        _countView = [[YXCountView alloc] initWithFrame:CGRectMake((YXScreenW-325*kScale)*0.5, 114*kScale, 325*kScale, 125*kScale)];
        _countView.leftTextLabel.text = @"待还(元)";
        _countView.rightTextLabel.text = @"待收(元)";
        _countView.delegate = self;
    }
    return _countView;
}

- (UIView *)topBackView
{
    if (!_topBackView) {
        _topBackView = [UIView new];
        _topBackView.backgroundColor = kCommonColor;
    }
    return _topBackView;
}

- (YXNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[YXNoDataView alloc] init];
        _noDataView.center = CGPointMake(self.view.yx_centerX, 420*kScale);
        _noDataView.hidden = YES;
        _noDataView.text = @"您还没有相关借条";
        _noDataView.image = [UIImage imageNamed:@"nodata_lous"];
        _noDataView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNewData)];
        [_noDataView addGestureRecognizer:tap];
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        if (iphoneX) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 247*kScale, YXScreenW, YXScreenH-314*kScale-88) style:UITableViewStylePlain];

        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 247*kScale, YXScreenW, YXScreenH-314*kScale-44) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 160*kScale;
        [_tableView registerClass:[YXHomeTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (YXLatelyView *)latelyView
{
    if (!_latelyView) {
        _latelyView = [[YXLatelyView alloc] initWithFrame:CGRectMake(25*kScale, 274*kScale, 325*kScale, 160*kScale)];
        _latelyView.hidden = YES;
    }
    return _latelyView;
}

- (UIButton *)commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(25*kScale, CGRectGetMaxY(self.tableView.frame)+9*kScale, YXScreenW-50*kScale, 44*kScale);
        _commitButton.layer.cornerRadius = 4*kScale;
        [_commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [_commitButton setTitle:@"打借条" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitButton.titleLabel.font = kFont18;
        [_commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - countViewDelegate
- (void)countView:(YXCountView *)countView didSelectedIndex:(NSUInteger)index
{
    self.tabBarController.selectedIndex = 2;
    NSDictionary *object = @{@"index": @(index)};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeTopViewDidClickedNotification" object:object];
    });
   
//    [self gotoSearchLousViewController:index];
}

#pragma mark - tableViewDelegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLousDetalisModel *model = self.dataArray[indexPath.row];
    YXLousDetailsViewController *detailsViewController = [[YXLousDetailsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailsViewController animated:YES];

}

@end
