//
//  YXHomeTableViewCell.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/19.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXHomeTableViewCell.h"
#import "YXLousDetalisModel.h"

@implementation YXHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _homeCellView = [[YXLatelyView alloc] initWithFrame:CGRectMake(25*kScale, 3*kScale, 325*kScale, 150*kScale)];
        [self.contentView addSubview: _homeCellView];
    }
    return self;
}

- (void)setModel:(YXLousDetalisModel *)model
{
    _model = model;
    self.homeCellView.money.text = model.amount;
    self.homeCellView.data.text = [model.refundTime timeStampString2Date];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
