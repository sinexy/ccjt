//
//  YXSearchLousViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/13.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXSearchLousViewController.h"
#import "YXSearchLousTableViewCell.h"
#import "YXLousDetailsViewController.h"
#import "YXLousDetalisModel.h"

@interface YXSearchLousViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *interest;
@property (nonatomic, strong) UILabel *time;    // 次数
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *formHeader;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, strong) YXMyLousModel *model;
@end

@implementation YXSearchLousViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(transparentNavigationBar)];
}

- (instancetype)initWithType:(NSUInteger)type withModel:(YXMyLousModel *)model
{
    if (self = [super init]) {
        _type = type;
        _model = model;
    }
    return self;
}
#pragma mark - goto


#pragma mark -  get data

#pragma mark -  get data

- (void)loadNewData
{
    self.pageNumber = 0;
    if (![YXUserManager shared].isRealName) {
        [SVProgressHUD showErrorWithStatus:@"请先实名认证"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    NSDictionary *params = @{
                              @"userUuid" :[YXUserManager shared].userModel.userUuid,
                              @"pageNumber":@(self.pageNumber),
                              @"queryName": self.searchTextField.text,
                              @"authUuid" :[YXUserManager shared].userModel.authUuid,
                              @"isLenderOrBorrower" : self.type == 1 ?  @"borrower" : @"lender" ,
                              @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/queryByName" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            [weakSelf.dataArray removeAllObjects];
            NSArray *array = [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"iouOrderDetail"][@"content"]];
            
            weakSelf.interest.text = [NSString stringWithFormat:@"%.2f",[response[@"data"][@"sumInterest"] floatValue]];
            weakSelf.time.text = [NSString stringWithFormat:@"%zd",[response[@"data"][@"totalCount"] integerValue]];
            if (array.count == 0) {
                    weakSelf.noDataView.hidden = NO;
                    weakSelf.tableView.hidden = YES;
            }else{
                weakSelf.noDataView.hidden = YES;
                weakSelf.tableView.hidden = NO;
            }
            [weakSelf.dataArray addObjectsFromArray: array];
          
            weakSelf.pageNumber++;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            
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
    if (![YXUserManager shared].isRealName) {
        [SVProgressHUD showErrorWithStatus:@"请先实名认证"];
        return;
    }
    NSDictionary *params = @{
                             @"userUuid" :[YXUserManager shared].userModel.userUuid,
                             @"pageNumber":@(self.pageNumber),
                             @"queryName": self.searchTextField.text,
                             @"authUuid" :[YXUserManager shared].userModel.authUuid,
                             @"isLenderOrBorrower" : self.type ==  1 ?  @"borrower" : @"lender" ,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/queryByName" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            
            [weakSelf.dataArray addObjectsFromArray: [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"iouOrderDetail"][@"content"]]];
            weakSelf.interest.text = [NSString stringWithFormat:@"%.2f",[response[@"data"][@"sumInterest"] floatValue]];
            weakSelf.time.text = [NSString stringWithFormat:@"%zd",[response[@"data"][@"totalCount"] integerValue]];
            weakSelf.pageNumber++;
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];

            
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
    self.navigationItem.title = self.type == 1 ? @"借入总额" : @"借出总额";
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = YXGray(248);
    [self.view addSubview:self.topView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.formHeader];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = NO;
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
}

#pragma mark - setters and getters
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 205*kScale)];
        if (iphoneX) {
            _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 141*kScale+88)];
        }
        [_topView setGradientLayerWithStartColor:YXRGB(74, 130, 239) endColor:YXRGB(97, 178, 238)];
        self.money = [UILabel new];
        [_topView addSubview:self.money];
        [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_topView);
            if (iphoneX) {
                make.top.mas_equalTo(25*kScale+88);
            }else{
                make.top.mas_equalTo(25*kScale+64);
            }
        }];
        
        self.money.text = self.type == 1 ? [NSString stringWithFormat:@"%.2f元",self.model.repaymentSumAmount] : [NSString stringWithFormat:@"%.2f元",self.model.receivableSumAmount];
        self.money.font = kFont26;
        self.money.textColor = [UIColor whiteColor];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.yx_height-64*kScale, YXScreenW, 64*kScale)];
        bottomView.backgroundColor = kCommonColor;
        [_topView addSubview:bottomView];
        
        self.interest = [UILabel new];
        [bottomView addSubview:self.interest];
        [self.interest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView).multipliedBy(1.0/2.0);
            make.top.mas_equalTo(bottomView).offset(13*kScale);
        }];
        self.interest.font = kFont14;
        self.interest.text = self.type == 1 ? [NSString stringWithFormat:@"%.2f",self.model.repaymentSumInterest] : [NSString stringWithFormat:@"%.2f",self.model.receivableSumInterest];
        self.interest.textColor = [UIColor whiteColor];
        
        UILabel *interestLabel = [UILabel new];
        [bottomView addSubview:interestLabel];
        [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.interest);
            make.top.mas_equalTo(self.interest.mas_bottom).offset(5*kScale);
        }];
        interestLabel.font = kFont14;
        interestLabel.text = @"总利息(元)";
        interestLabel.textColor = YXRGB(194, 225, 255);
        
        self.time = [UILabel new];
        [bottomView addSubview:self.time];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView).multipliedBy(1 + 1.0/2.0);
            make.top.mas_equalTo(bottomView).offset(13*kScale);
        }];
        self.time.font = kFont14;
        if (self.model) {
            self.time.text = self.type == 1 ? self.model.repaymentTotalCount : self.model.receivableTotalCount;
        }else{
            self.time.text = @"0";
        }
        self.time.textColor = [UIColor whiteColor];
        
        UILabel *timeLabel = [UILabel new];
        [bottomView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.time);
            make.top.mas_equalTo(self.time.mas_bottom).offset(5*kScale);
        }];
        timeLabel.font = kFont14;
        timeLabel.text = self.type == 1 ? @"借入次数" : @"借出次数";
        timeLabel.textColor = YXRGB(194, 225, 255);
        
        UIView *sep = [UIView new];
        [bottomView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.centerX.mas_equalTo(bottomView);
            make.height.mas_equalTo(40*kScale);
            make.width.mas_equalTo(1);
        }];
        sep.backgroundColor = YXRGB(194, 225, 255);
        
    }
    return _topView;
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.yx_height+10, YXScreenW, 42*kScale)];
        _searchView.backgroundColor = [UIColor whiteColor];
        UIImageView *icon = [UIImageView new];
        [_searchView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_searchView).offset(20*kScale);
            make.centerY.mas_equalTo(_searchView);
        }];
        icon.image = [UIImage imageNamed:@"search"];
        
        self.searchTextField = [UITextField new];
        [_searchView addSubview:self.searchTextField];
        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(10*kScale);
            make.centerY.mas_equalTo(icon);
            make.width.mas_equalTo(300*kScale);
            make.height.mas_equalTo(30*kScale);
        }];
        self.searchTextField.delegate = self;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.placeholder = self.type == 1 ? @"搜索出借人姓名" : @"搜索借款人姓名";
    }
    return _searchView;
}

- (UIView *)formHeader
{
    if (!_formHeader) {
        _formHeader = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchView.yx_y+self.searchView.yx_height, YXScreenW, 44*kScale)];
        _formHeader.backgroundColor = [UIColor whiteColor];
        
        UIView *sep1 = [UIView new];
        sep1.frame = CGRectMake(18*kScale, 0, _formHeader.yx_width-36*kScale, 1);
        sep1.backgroundColor = kCommonUnableColor;
        [_formHeader addSubview:sep1];
        
        NSArray *title;
        if (self.type == 1) {
            title = @[@"出借人",@"借款金额",@"时间",@"状态",];
        }else{
            title = @[@"借款人",@"借款金额",@"时间",@"状态",];
        }
        CGFloat w = _formHeader.yx_width / 4;
        CGFloat h = 30*kScale;
        for (int i = 0; i < title.count; i++) {
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(i*w, 7*kScale, w, h);
            label.text = title[i];
            label.font = kFont14;
            label.textColor = kCommonColor;
            label.textAlignment = NSTextAlignmentCenter;
            [_formHeader addSubview:label];
        }
        UIView *sep2 = [UIView new];
        sep2.frame = CGRectMake(w, 8*kScale, 1, 28*kScale);
        sep2.backgroundColor = kCommonUnableColor;
        [_formHeader addSubview:sep2];
        UIView *sep3 = [UIView new];
        sep3.frame = CGRectMake(2*w, 8*kScale, 1, 28*kScale);
        sep3.backgroundColor = kCommonUnableColor;
        [_formHeader addSubview:sep3];
        UIView *sep4 = [UIView new];
        sep4.frame = CGRectMake(3*w, 8*kScale, 1, 28*kScale);
        sep4.backgroundColor = kCommonUnableColor;
        [_formHeader addSubview:sep4];
        
        UIView *sep5 = [UIView new];
        sep5.frame = CGRectMake(18*kScale, _formHeader.yx_height-2, _formHeader.yx_width-36*kScale, 1);
        sep5.backgroundColor = kCommonUnableColor;
        [_formHeader addSubview:sep5];
        
    }
    return _formHeader;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.formHeader.yx_height+self.formHeader.yx_y, YXScreenW, YXScreenH-self.formHeader.yx_height-self.formHeader.yx_y) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44*kScale;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[YXSearchLousTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (YXNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[YXNoDataView alloc] init];
        _noDataView.center = CGPointMake(self.view.yx_centerX, 500*kScale);
        _noDataView.hidden = YES;
        _noDataView.text = @"暂无相关内容";
        _noDataView.image = [UIImage imageNamed:@"nodata_search_lous"];
    }
    return _noDataView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - private method


#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXSearchLousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YXLousDetalisModel *model = self.dataArray[indexPath.row];
    cell.name.text = self.type == 1 ? model.lenderName : model.borrowerName;
    cell.money.text = model.amount;
    cell.date.text = [model.refundTime timeStampString2Date];
    cell.state.text = model.statusString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLousDetalisModel *model = self.dataArray[indexPath.row];

    YXLousDetailsViewController *vc = [[YXLousDetailsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - textfield delegate
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    [_tableView.mj_header beginRefreshing];

    return YES;
}
@end
