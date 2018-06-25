//
//  YXLousCollectionViewCell.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/12.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXLousCollectionViewCell.h"

@implementation YXLousCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*kScale, 10*kScale, 90*kScale, 90*kScale)];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = true;
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete_photo"] forState:UIControlStateNormal];
        self.deleteButton.frame = CGRectMake(0, 0, 20, 20);
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

@end
