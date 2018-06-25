//
//  YXLousViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousViewController.h"
#import "YXTextFieldView.h"
#import "PGDatePickManager.h"
#import "YXLousUsesViewController.h"
#import "YXRealNameViewController.h"
#import "YXNavigationController.h"
#import "YXQRCodeViewController.h"

@interface YXLousViewController ()<UIScrollViewDelegate, PGDatePickerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) YXTextFieldView *money;
@property (nonatomic, strong) YXTextFieldView *lendingDate;
@property (nonatomic, strong) YXTextFieldView *refundDate;
@property (nonatomic, strong) YXTextFieldView *rate;
@property (nonatomic, strong) YXTextFieldView *uses;
@property (nonatomic, strong) YXTextFieldView *name;
@property (nonatomic, strong) YXTextFieldView *identification;
@property (nonatomic, strong) UIView *role;
@property (nonatomic, strong) UIView *interest;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSDateComponents *lendingDateComponents;
@property (nonatomic, strong) NSDateComponents *refundDateComponents;
@property (nonatomic, strong) UILabel *interestLabel;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSString *imageUrls;

@property (nonatomic, strong) NSString *urlString;

@end

@implementation YXLousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageUrls = @"";
}



#pragma mark - goto

#pragma mark -  get data

- (void)createLous
{
    if (![self check]) {
        return;
    }
    if (![YXUserManager shared].isRealName) {
        [SVProgressHUD showErrorWithStatus:@"请先实名认证"];
        return;
    }
    NSString *uses = self.uses.textField.text;
    if ([YXAppInfoManager shared].purpose) {
        for (NSDictionary *dict in [YXAppInfoManager shared].purpose) {
            if ([uses isEqualToString:dict[@"value"]]) {
                uses = dict[@"key"];
            }
        }
    }
    
    NSString *lendingTime = [NSString stringWithFormat:@"%zd%2zd%2zd",self.lendingDateComponents.year,self.lendingDateComponents.month,self.lendingDateComponents.day];
    NSString *refundTime = [NSString stringWithFormat:@"%zd%2zd%2zd",self.refundDateComponents.year,self.refundDateComponents.month,self.refundDateComponents.day];
    NSString *sign = [NSString stringWithFormat:@"amount:%@,lendingTime:%@,refundTime:%@,otherPartyName:%@,otherPartyIdCard:%@",self.money.textField.text,lendingTime,refundTime,self.name.textField.text,self.identification.textField.text];
    NSDictionary *params = @{@"amount":self.money.textField.text,
                             @"lendingTime":lendingTime,
                             @"refundTime":refundTime,
                             @"rateYear":self.rate.textField.text,
                             @"otherPartyName":self.name.textField.text,
                             @"otherPartyIdCard":self.identification.textField.text,
                             @"isSenderOrReceiver":@"sender",
                             @"isBorrowerOrLender": self.selectedButton.tag == 11 ? @"lender" : @"borrower",
                             @"sessionId":[YXUserManager shared].userModel.sessionId,
                             @"userUuid":[YXUserManager shared].userModel.userUuid,
                             @"authUuid":[YXUserManager shared].userModel.authUuid,
                             @"sign": [sign md532BitUpper],
                             @"imageUrl" : self.imageUrls,
                             @"loanPurpose": uses,
                             @"remark":self.desc,
                             };
    YXWeakSelf(self);
    [YXNetworking postWithUrl:@"order/createIou" params:params success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            weakSelf.urlString = response[@"data"][@"url"];
            [weakSelf clearFormat];
            [[NSNotificationCenter defaultCenter] postNotificationName:CREATEORDERSUCCESSNOTIFICATION object:nil];
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
    self.navigationItem.title = @"打借条";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18*kScale]}];
    
    [self.view addSubview:self.scrollView];
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YXScreenW, 10)];
    sep1.backgroundColor = YXGray(248);
    [self.scrollView addSubview:sep1];
    [self.scrollView addSubview:self.money];
    [self.scrollView addSubview:self.lendingDate];
    [self.scrollView addSubview:self.refundDate];
    [self.scrollView addSubview:self.rate];
    [self.scrollView addSubview:self.uses];
    [self.scrollView addSubview:self.name];
    [self.scrollView addSubview:self.identification];
    [self.scrollView addSubview:self.role];
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10+8*48*kScale, YXScreenW, 10)];
    sep2.backgroundColor = YXGray(248);
    [self.scrollView addSubview:sep2];
    [self.scrollView addSubview:self.interest];
    [self.scrollView addSubview:self.bottomView];

}

#pragma mark - setters and getters
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(0, (2*10)+(9*48*kScale)+(284*kScale)+64+49);
        if (iphoneX) {
            _scrollView.contentSize = CGSizeMake(0, (2*10)+(9*48*kScale)+(284*kScale)+88+83);
        }
        
    }
    return _scrollView;
}

- (YXTextFieldView *)money
{
    if (!_money) {
        _money = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10, YXScreenW, 48*kScale) text:@"借款金额:" placeHolderText:@"请输入您的借款金额" rightView:nil andIsSecret:NO];
        _money.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _money.textField.delegate = self;
    }
    return _money;
}

- (YXTextFieldView *)lendingDate
{
    if (!_lendingDate) {
        _lendingDate = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+48*kScale, YXScreenW, 48*kScale) text:@"借款日期:" placeHolderText:@"请输入您的借款日期" rightView:nil andIsSecret:NO];
        _lendingDate.textField.userInteractionEnabled = false;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lendingDateViewDidClicked)];
        [_lendingDate addGestureRecognizer:tap];
    }
    return _lendingDate;
}

- (YXTextFieldView *)refundDate
{
    if (!_refundDate) {
        _refundDate = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+2*48*kScale, YXScreenW, 48*kScale) text:@"还款日期:" placeHolderText:@"请输入您的还款日期" rightView:nil andIsSecret:NO];
        _refundDate.textField.userInteractionEnabled = false;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refundDateViewDidClicked)];
        [_refundDate addGestureRecognizer:tap];

    }
    return _refundDate;
}

- (YXTextFieldView *)rate
{
    if (!_rate) {
        _rate = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+3*48*kScale, YXScreenW, 48*kScale) text:@"年化利率(%):" placeHolderText:@"请输入年化利率" rightView:nil andIsSecret:NO];
        _rate.textField.delegate = self;
    }
    return _rate;
}

- (YXTextFieldView *)uses
{
    if (!_uses) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [UIImage imageNamed:@"more"];
        _uses = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+4*48*kScale, YXScreenW, 48*kScale) text:@"借款用途:" placeHolderText:@"请选择您的借款用途" rightView:imageView andIsSecret:NO];
        _uses.textField.userInteractionEnabled = false;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usesViewDidClicked)];
        [_uses addGestureRecognizer:tap];
    }
    return _uses;
}

- (YXTextFieldView *)name
{
    if (!_name) {
        _name = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+5*48*kScale, YXScreenW, 48*kScale) text:@"对方姓名:" placeHolderText:@"请输入对方姓名" rightView:nil andIsSecret:NO];
    }
    return _name;
}

- (YXTextFieldView *)identification
{
    if (!_identification) {
        _identification = [[YXTextFieldView alloc] initWithFrame:CGRectMake(0, 10+6*48*kScale, YXScreenW, 48*kScale) text:@"对方身份证:" placeHolderText:@"请输入身份证号码" rightView:nil andIsSecret:NO];
    }
    return _identification;
}

- (UIView *)role
{
    if (!_role) {
        _role = [[UIView alloc] initWithFrame:CGRectMake(0, 10+7*48*kScale, YXScreenW, 48*kScale)];
        UILabel *label  = [UILabel new];
        [_role addSubview:label];
        label.font = kFont16;
        label.text = @"我是:";
        label.textColor = kCommonTextColor;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_role).offset(16*kScale);
            make.centerY.mas_equalTo(_role);
        }];
        
        UIButton *lender = [UIButton buttonWithType:UIButtonTypeCustom];
        [_role addSubview:lender];
        lender.tag = 11;
        [lender setTitle:@" 出借人" forState:UIControlStateNormal];
        [lender setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        lender.titleLabel.font = kFont16;
        [lender setImage:[UIImage imageNamed:@"role_normal"] forState:UIControlStateNormal];
        [lender setImage:[UIImage imageNamed:@"role_selected"] forState:UIControlStateSelected];
        [lender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(10);
            make.centerY.mas_equalTo(_role);
        }];
        [lender addTarget:self action:@selector(roleButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        lender.selected = true;
        self.selectedButton = lender;
        
        UIButton *borrower = [UIButton buttonWithType:UIButtonTypeCustom];
        [_role addSubview:borrower];
        borrower.tag = 22;
        [borrower setTitle:@" 借款人" forState:UIControlStateNormal];
        [borrower setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        borrower.titleLabel.font = kFont16;
        [borrower setImage:[UIImage imageNamed:@"role_normal"] forState:UIControlStateNormal];
        [borrower setImage:[UIImage imageNamed:@"role_selected"] forState:UIControlStateSelected];
        [borrower addTarget:self action:@selector(roleButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [borrower mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lender.mas_right).offset(20);
            make.centerY.mas_equalTo(_role);
        }];
    }
    return _role;
}

- (UIView *)interest
{
    if (!_interest) {
        _interest = [[UIView alloc] initWithFrame:CGRectMake(16*kScale, 2*10+8*48*kScale, YXScreenW-32*kScale, 48*kScale)];
        UILabel *label  = [UILabel new];
        [_interest addSubview:label];
        label.font = kFont16;
        label.text = @"到期本息:";
        label.textColor = kCommonTextColor;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_interest).offset(5);
            make.centerY.mas_equalTo(_interest);
        }];
        
        UILabel *interestLabel  = [UILabel new];
        [_interest addSubview:interestLabel];
        interestLabel.font = kFont16;
        interestLabel.textColor = kCommonColor;
        [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right).offset(10);
            make.centerY.mas_equalTo(_interest);
        }];
        self.interestLabel = interestLabel;
    }
    return _interest;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = YXRGB(244, 245, 250);
        _bottomView.frame = CGRectMake(0, 2*10+9*48*kScale, YXScreenW, 284*kScale);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning"]];
        [_bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView).offset(16*kScale);
            make.top.mas_equalTo(_bottomView).offset(5);
            make.width.mas_equalTo(20*kScale);
            make.height.mas_equalTo(20*kScale);
        }];
        UILabel *label = [UILabel new];
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(2);
            make.centerY.mas_equalTo(imageView);
        }];
        label.textColor = kCommonColor;
        label.font = kFont16;
        label.text = @"郑重声明";
        
        UILabel *content = [UILabel new];
        [_bottomView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView).offset(16*kScale);
            make.top.mas_equalTo(imageView.mas_bottom).offset(10);
            make.width.mas_equalTo(YXScreenW-32*kScale);
        }];
        content.numberOfLines = 0;
        content.textColor = kSDeepTextColor;
        content.font = kFont16;
        content.text = @"1、草船借条平台不从事任何放贷业务，如果有他人以“草船借条”名义进行放贷，均与草船借条无关，草船借条平台保留追究其法律责任的权利。\n2、逾期和展期的费用由甲乙双方自行协商确定。\n3、在对方尚未确认借条前，发起者可以取消借条。\n4、出具借条后不予退还交易服务费";
        
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commitButton.frame = CGRectMake(25*kScale, 230*kScale, YXScreenW-50*kScale, 44*kScale);
        commitButton.layer.cornerRadius = 4*kScale;
        [commitButton setGradientLayerWithStartColor:kCommonColor endColor:YXRGB(109, 159, 255)];
        [commitButton setTitle:@"打借条" forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitButton.titleLabel.font = kFont18;
        [commitButton addTarget:self action:@selector(commitButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:commitButton];
    }
    return _bottomView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"借款金额:",@"借款日期:",@"还款日期:",@"年化利率:",@"借款用途:",@"对方姓名:",@"对方身份证:",@"我是:"];
    }
    return _titleArray;
}

#pragma mark - private method
- (void)lendingDateViewDidClicked
{
    PGDatePickManager *dateManager = [[PGDatePickManager alloc] init];
    dateManager.titleLabel.text = @"借款日期";
    
    PGDatePicker *datePicker = dateManager.datePicker;
    datePicker.tag = 1;
    datePicker.datePickerType = PGDatePickerType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    datePicker.isHiddenMiddleText = false;
    [self presentViewController:dateManager animated:false completion:nil];
}

- (void)refundDateViewDidClicked
{
    PGDatePickManager *dateManager = [[PGDatePickManager alloc] init];
    dateManager.titleLabel.text = @"还款日期";

    PGDatePicker *datePicker = dateManager.datePicker;
    datePicker.tag = 2;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:self.lendingDateComponents];
    datePicker.minimumDate = date;
    datePicker.datePickerType = PGDatePickerType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    datePicker.isHiddenMiddleText = false;
    [self presentViewController:dateManager animated:false completion:nil];
}

- (void)usesViewDidClicked
{
    
        YXLousUsesViewController *uses = [[YXLousUsesViewController alloc] initWithIndex:self.index desc:self.desc images:self.images assets:self.assets];
        YXWeakSelf(self);
        uses.lousUsesBlock = ^(NSUInteger index, NSString *use, NSString *desc, NSMutableArray *images, NSMutableArray *assets, NSString *imageUrls) {
            weakSelf.index = index;
            weakSelf.uses.textField.text = use;
            weakSelf.desc = desc;
            weakSelf.images = images;
            weakSelf.assets = assets;
            weakSelf.imageUrls = imageUrls;
        };
        [self.navigationController pushViewController:uses animated:YES];
//    }
}

- (BOOL)check
{
    if (self.money.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return false;
    }
    if (![self.money.textField.text isNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        return false;
        
    }
    if (self.lendingDate.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入借款日期"];
        return false;
    }
    if (self.refundDate.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入还款日期"];
        return false;
    }
    if (self.rate.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入年化利率"];
        return false;
    }
    if (![self.rate.textField.text isNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的年化利率"];
        return false;
    }
    if (self.uses.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择借款用途"];
        return false;
    }
    if (self.name.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入对方姓名"];
        return false;
    }
    if (self.identification.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入对方身份证号码"];
        return false;
    }
    if (![self.identification.textField.text isIdentification]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号码"];
        return false;
    }
    return true;
}

- (void)roleButtonDidClicked:(UIButton *)button
{
    if (button == self.selectedButton) {
        return;
    }
    button.selected = true;
    self.selectedButton.selected = false;
    self.selectedButton = button;
}

- (void)commitButtonDidClicked
{
    if (![YXUserManager shared].isRealName) {
        YXRealNameViewController *vc = [[YXRealNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self createLous];
    }
}

- (void)calculator
{
    if (self.lendingDate.textField.text.length > 0 &&
        self.refundDate.textField.text.length > 0 &&
        self.rate.textField.text.length > 0 &&
        self.money.textField.text.length > 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *lendingDate = [gregorian dateFromComponents:self.lendingDateComponents];
        NSDate *refundDate = [gregorian dateFromComponents:self.refundDateComponents];
        
//        NSUInteger day = [NSDate getDateToDateDays:lendingDate withSaveDate:refundDate];
        NSUInteger day = [NSDate getDateFormDate:lendingDate toDate:refundDate];

        
        CGFloat rate = [self.rate.textField.text floatValue]/100/365;
        CGFloat capital =  [self.money.textField.text floatValue];
        CGFloat interset = (day+1) * rate * capital + capital;
        self.interestLabel.text = [NSString stringWithFormat:@"%.2f元",interset];
        
        YXLog(@"%zd", day);
    }
}

- (void)clearFormat
{
    self.money.textField.text = @"";
    self.lendingDate.textField.text = @"";
    self.refundDate.textField.text = @"";
    self.rate.textField.text = @"";
    self.uses.textField.text = @"";
    self.name.textField.text = @"";
    self.identification.textField.text = @"";
    self.index = 0;
    self.desc = @"";
    self.images = nil;
    self.assets = nil;
    self.interestLabel.text = @"";
    YXWeakSelf(self);
    [YXNetworking getWithUrl:@"index/payConfig" params:@{@"sessionId":[YXUserManager shared].userModel.sessionId,} success:^(id response) {
        if ([response[@"code"] isEqualToString:@"msg_0001"]) {
            NSInteger isPay = [response[@"data"][@"paySwitch"] integerValue];
            if (isPay == 1) {
                [weakSelf pay];
                }else{
                [weakSelf toQRVC];
            }
            
        }else{
                [SVProgressHUD showErrorWithStatus:response[@"message"]];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误..."];

    }];

}

- (void)pay
{
    [SVProgressHUD showSuccessWithStatus:@"调用微信支付"];
}

- (void)toQRVC
{
    YXQRCodeViewController *vc = [[YXQRCodeViewController alloc] initWithUrlString:self.urlString];
    [self.navigationController presentViewController:vc animated:true completion:nil];
}

#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    YXLog(@"%@", dateComponents);
    if (datePicker.tag == 1) {  // 借款日期
        self.lendingDate.textField.text = [NSString stringWithFormat:@"%zd年%zd月%zd日",dateComponents.year,dateComponents.month,dateComponents.day];
        self.lendingDateComponents = dateComponents;
    }else{  // 还款日期
        self.refundDate.textField.text = [NSString stringWithFormat:@"%zd年%zd月%zd日",dateComponents.year,dateComponents.month,dateComponents.day];
        self.refundDateComponents = dateComponents;
    }
    [self calculator];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return;
    }
    if (![textField.text isNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的数字"];
        textField.text = @"";
        return;
    }
    [self calculator];
}

@end
