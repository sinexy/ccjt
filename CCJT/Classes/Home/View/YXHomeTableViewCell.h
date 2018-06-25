//
//  YXHomeTableViewCell.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/19.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLatelyView.h"
@class YXLousDetalisModel;

@interface YXHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) YXLatelyView *homeCellView;
@property (nonatomic, strong) YXLousDetalisModel *model;

@end
