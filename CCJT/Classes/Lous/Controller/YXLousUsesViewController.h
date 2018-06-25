//
//  YXLousUsesViewController.h
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXBaseViewController.h"
typedef void(^LousUsesBlock)(NSUInteger index, NSString *use, NSString *desc, NSMutableArray *images, NSMutableArray *assets, NSString *imageUrls);

@interface YXLousUsesViewController : YXBaseViewController


@property (nonatomic, copy) LousUsesBlock lousUsesBlock;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSMutableArray *images;

- (instancetype)initWithIndex:(NSUInteger)index desc:(NSString *)desc images:(NSMutableArray *)images assets:(NSMutableArray *)assets;

@end
