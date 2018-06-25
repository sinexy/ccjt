//
//  YXActivityViewController.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/8.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXActivityViewController.h"
#import <WebKit/WebKit.h>

@interface YXActivityViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation YXActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (instancetype)initWithNavigationTitle:(NSString *)title url:(NSString *)url
{
    if (self = [super init]) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithtitle:@"返回" normalColor:[UIColor grayColor] highlightColor:[UIColor blackColor] target:self action:@selector(backButtonClicked)];
        self.navigationItem.title = title;
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.webView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    }
    return _webView;
}

- (void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
