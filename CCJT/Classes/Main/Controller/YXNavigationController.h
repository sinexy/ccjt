//
//  YXBaseNavigationController.h
//  JPlus_Objective-C
//
//  Created by yunxin bai on 2018/2/27.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXNavigationController : UINavigationController

/**
 * 透明导航栏
 */
- (void)transparentNavigationBar;
/**
 * 不透明导航栏
 */
- (void)opaqueNavigationBar;
@end
