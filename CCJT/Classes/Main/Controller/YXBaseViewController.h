//
//  YXBaseViewController.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXNoDataView.h"

@interface YXBaseViewController : UIViewController


- (void)openAvtivityViewControllerWithTitle:(NSString *)title url:(NSString *)url;

- (void)setupUI;

@end
