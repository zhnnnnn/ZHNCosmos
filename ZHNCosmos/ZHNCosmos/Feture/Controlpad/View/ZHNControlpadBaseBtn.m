//
//  ZHNControlpadBaseBtn.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadBaseBtn.h"

@interface ZHNControlpadBaseBtn()
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation ZHNControlpadBaseBtn
#pragma mark - pure code
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_initViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_layoutViews];
}

#pragma mark - xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_layoutViews];
}

#pragma mark - pravite methods
- (void)p_initViews {
    self.btn = [[UIButton alloc]init];
    [self addSubview:self.btn];
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.isCustomThemeColor = YES;
    self.layer.masksToBounds = YES;
    
    @weakify(self);
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self btnClickHandle];
    }];
}

- (void)p_layoutViews {
    if (!self.isNoNeedCornerRadius) {
        self.layer.cornerRadius = 5;
    }
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-7);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(3);
        make.left.equalTo(self).offset(3);
        make.right.equalTo(self).offset(-3);
    }];
}

#pragma mark - setters
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsHightlight:(BOOL)isHightlight {
    _isHightlight = isHightlight;
    if (isHightlight) {
        self.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
    }else {
        self.backgroundColor = ZHNHexColor(@"#9b9b9b");
    }
}

#pragma mark -
- (void)btnClickHandle {}
@end
