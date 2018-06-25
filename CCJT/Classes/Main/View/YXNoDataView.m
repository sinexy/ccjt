//
//  YXNoDataView.m
//  CCJT
//
//  Created by yunxin bai on 2018/3/9.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXNoDataView.h"

@interface YXNoDataView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YXNoDataView

+ (instancetype)shared
{
    static YXNoDataView *nodataView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nodataView = [[YXNoDataView alloc] init];
    });
    return nodataView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 200*kScale, 174*kScale+8);
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.imageView];
    self.imageView.frame = CGRectMake(28*kScale, 0, 144*kScale, 144*kScale);
    
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake((self.yx_width-200*kScale)*0.5, self.imageView.yx_height+8, 200*kScale, 30*kScale);
    
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = true;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFont17;
        _titleLabel.textColor = kSDeepTextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.titleLabel.text = text;
}

@end
