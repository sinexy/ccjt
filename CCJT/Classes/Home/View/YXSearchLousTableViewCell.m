//
//  YXSearchLousTableViewCell.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/13.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXSearchLousTableViewCell.h"

@implementation YXSearchLousTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.name = [UILabel new];
        [self.contentView addSubview:self.name];
        CGFloat w = YXScreenW/4;
        CGFloat h = 30*kScale;
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.frame = CGRectMake(0, 7*kScale, w, h);
        self.name.textColor = kCommonTextColor;
        self.name.font = kFont15;
        self.name.text = @"李四";
        
        self.money = [UILabel new];
        [self.contentView addSubview:self.money];
        self.money.textAlignment = NSTextAlignmentCenter;
        self.money.frame = CGRectMake(w, 7*kScale, w, h);
        self.money.textColor = kCommonTextColor;
        self.money.font = kFont15;
        self.money.text = @"100000.00";
        
        self.date = [UILabel new];
        [self.contentView addSubview:self.date];
        self.date.textAlignment = NSTextAlignmentCenter;
        self.date.frame = CGRectMake(2*w, 7*kScale, w, h);
        self.date.textColor = kCommonTextColor;
        self.date.font = kFont15;
        self.date.text = @"2018/12/31";
        
        self.state = [UILabel new];
        [self.contentView addSubview:self.state];
        self.state.textAlignment = NSTextAlignmentCenter;
        self.state.frame = CGRectMake(3*w, 7*kScale, w, h);
        self.state.textColor = kCommonTextColor;
        self.state.font = kFont15;
        self.state.text = @"进行中";
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
