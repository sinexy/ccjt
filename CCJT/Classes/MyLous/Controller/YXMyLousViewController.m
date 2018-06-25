//
//  YXMyLousViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXMyLousViewController.h"
#import "YXTabbarView.h"
#import "YXMyLousTableViewCell.h"
#import "PGDatePickManager.h"
#import "YXLousDetailsViewController.h"
#import "YXLousDetalisModel.h"

@interface YXMyLousViewController ()<YXTabbarViewDelegate, UITableViewDelegate, UITableViewDataSource,PGDatePickerDelegate>

@property (nonatomic, strong) YXTabbarView *tabbarView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *accountString;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, strong) NSString *recordSign;
@property (nonatomic, assign) CGFloat sumAmount;   // 总额
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) NSString *searchTime; // 查询时间


@end

@implementation YXMyLousViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabbar:) name:@"homeTopViewDidClickedNotification" object:nil];
    self.pageNumber = 0;
    self.recordSign = @"all";
    self.searchTime = [[NSDate getCurrentYearMonthDay] stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

#pragma mark - goto


#pragma mark -  get data
- (void)loadNewData
{
    self.pageNumber = 0;
    NSDictionary *params = @{
                             @"userUuid" : [YXUserManager shared].userModel.userUuid,
                             @"recordSign" : self.recordSign,
                             @"pageNumber" : @(self.pageNumber),
                             @"queryTime" : self.searchTime,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/findIouRecordsDetail" params:params success:^(id response) {
         if ([response[@"code"] isEqualToString:@"msg_0001"]) {
             weakSelf.sumAmount = [response[@"data"][@"iouOrderTotalAmount"] floatValue];
             weakSelf.totalLabel.text = [NSString stringWithFormat:@"%.2f元",weakSelf.sumAmount];
             [weakSelf.dataArray removeAllObjects];
             weakSelf.pageNumber++;
             [weakSelf.tableView.mj_header endRefreshing];
             NSArray *array = [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderRecordPage"][@"content"]];
             [weakSelf.tableView.mj_footer endRefreshing];
             if (array.count == 0) {
                 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
             }else{
                 [weakSelf.tableView.mj_footer resetNoMoreData];
             }
             [weakSelf.dataArray addObjectsFromArray:array];
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
    NSDictionary *params = @{
                             @"userUuid" : [YXUserManager shared].userModel.userUuid,
                             @"recordSign" : self.recordSign,
                             @"pageNumber" : @(self.pageNumber),
                             @"queryTime" : self.searchTime,
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/findIouRecordsDetail" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            weakSelf.sumAmount = [response[@"data"][@"iouOrderTotalAmount"] floatValue];
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"%.2f元",weakSelf.sumAmount];
            NSArray *array = [YXLousDetalisModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderRecordPage"][@"content"]];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (array.count == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.dataArray addObjectsFromArray: array];
            weakSelf.pageNumber++;
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
    self.navigationItem.title = @"我的借条";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale]}];
    [self.view addSubview:self.tabbarView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
}

#pragma mark - setters and getters
- (YXTabbarView *)tabbarView
{
    if (!_tabbarView) {
        _tabbarView = [[YXTabbarView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 42*kScale)];
        _tabbarView.delegate = self;
    }
    return _tabbarView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 42*kScale, YXScreenW, 149*kScale)];
        [_topView set_yxbackgroundImage:@"myLous_bg" ofType:@".png"];
        
        self.dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topView addSubview:self.dateButton];
        self.dateButton.frame = CGRectMake(20*kScale, 20*kScale, 165*kScale, 26*kScale);
        self.dateButton.layer.cornerRadius = 5 * kScale;
        [self.dateButton setTitle:[NSDate getCurrentYearMonthDay] forState:UIControlStateNormal];

        self.dateButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
//        [self.dateButton setImage:[UIImage imageNamed:@"white_downArrow"] forState:UIControlStateNormal];
        [self.dateButton addTarget:self action:@selector(selectedDate) forControlEvents:UIControlEventTouchUpInside];
//        [self.dateButton layoutButtonImageView:imageRight : 15*kScale];
        [self.dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30*kScale)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_downArrow"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(155*kScale, 23*kScale, 20*kScale, 20*kScale);
        [_topView addSubview:imageView];
        
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        allButton.frame = CGRectMake(CGRectGetMaxX(self.dateButton.frame)+10, 20*kScale, 50*kScale, 26*kScale);
        allButton.titleLabel.font = kFont16;
        [allButton addTarget:self action:@selector(allButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [allButton setTitle:@"全部" forState:UIControlStateNormal];
        [_topView addSubview:allButton];

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(33*kScale, 68*kScale, 100*kScale, 20*kScale)];
        label.text = @"借条总计总额";
        label.font = kFont14;
        label.textColor = [UIColor whiteColor];
        [_topView addSubview:label];
        
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*kScale, 94*kScale, 200*kScale, 42*kScale)];
        self.totalLabel.textColor = [UIColor whiteColor];
        self.totalLabel.font = [UIFont boldSystemFontOfSize:30*kScale];
        self.totalLabel.text = @"0.00元";
        [_topView addSubview:self.totalLabel];
        
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (42+149)*kScale, YXScreenW, YXScreenH-49-64-(42+149)*kScale) style:UITableViewStylePlain];
        if (iphoneX) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (42+149)*kScale, YXScreenW, YXScreenH-88-83-(42+149)*kScale) style:UITableViewStylePlain];
        }
        [_tableView registerClass:[YXMyLousTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 88*kScale;
        _tableView.backgroundColor = YXGray(248);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - private method
- (void)selectedDate
{
    PGDatePickManager *dateManager = [[PGDatePickManager alloc] init];
    dateManager.titleLabel.text = @"选择日期";
    
    PGDatePicker *datePicker = dateManager.datePicker;
    datePicker.tag = 2;
    datePicker.datePickerType = PGDatePickerType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    datePicker.isHiddenMiddleText = false;
    [self presentViewController:dateManager animated:false completion:nil];
}

- (void)allButtonDidClicked
{
    [self.dateButton setTitle:@"" forState:UIControlStateNormal];
    self.searchTime = @"";
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMyLousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YXLousDetalisModel *model = self.dataArray[indexPath.row];
    
    NSString *name;
    
    if ([self.recordSign isEqualToString:@"repayment"]) {
        name = model.lenderName;
    }else if ([self.recordSign isEqualToString:@"receivable"]){
        name = model.borrowerName;
    }else{
        if ([[YXUserManager shared].userModel.authUuid isEqualToString:model.borrowerAuthUuid]) {
            name = model.lenderName;
        }else{
            name = model.borrowerName;
        }

    }
    
    cell.name.text = name;
    cell.money.text = model.amount;
    cell.date.text = [model.refundTime timeStampString2Date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLousDetalisModel *model = self.dataArray[indexPath.row];
    YXLousDetailsViewController *vc = [[YXLousDetailsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    YXLog(@"%@", dateComponents);
    [self.dateButton setTitle:[NSString stringWithFormat:@"%zd/%zd/%zd",dateComponents.year,dateComponents.month,dateComponents.day] forState:UIControlStateNormal];
    self.searchTime = [NSString stringWithFormat:@"%zd%02zd%02zd",dateComponents.year,dateComponents.month,dateComponents.day];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - YXTabbarViewDelegate
- (void)tabbarView:(YXTabbarView *)tabbarView didSelectedIndex:(NSUInteger)index
{

    switch (index) {
        case 0:
            self.recordSign = @"all";
            break;
        case 1:
            self.recordSign = @"repayment";
            break;
        case 2:
            self.recordSign = @"receivable";
            break;
        default:
            break;
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - notification
- (void)changeTabbar:(NSNotification *)notification
{
    YXLog(@"%@",notification.object);
    
    NSUInteger index = [notification.object[@"index"] integerValue];
    [self.tabbarView setIndex:index];

}

@end
