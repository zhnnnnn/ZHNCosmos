//
//  ZHNThemeColorPickerView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNThemeColorPickerView.h"
#import "ZHNColorPickerView.h"
#import "UIColor+ZHNHexColor.h"
#import "UIColor+ZHNHexColor.h"
#import "ZHNMainControllerColorPickerTrasitionHelper.h"
#import "ZHNRecommendColorModel.h"
#import "UIColor+LightDarkColor.h"

@interface ZHNThemeColorPickerView()<ZHNColorPickerViewDelegate>
@property (nonatomic,strong) ZHNColorPickerView *colorPickerView;
@property (nonatomic,strong) UITextField *hexColorField;
@property (nonatomic,strong) UILabel *hexColorLabel;
@property (nonatomic,strong) UIImageView *rocketImageView;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *disMissButton;
@property (nonatomic,strong) ZHNRecommendColorView *recommendColorView;
@end

@implementation ZHNThemeColorPickerView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.colorPickerView];
        [self addSubview:self.hexColorField];
        [self addSubview:self.hexColorLabel];
        [self addSubview:self.disMissButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.rocketImageView];
        [self addSubview:self.recommendColorView];
        [self p_initActions];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.colorPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(@((int)(0.9 * K_SCREEN_WIDTH * 0.8)));
        make.height.mas_equalTo(@((int)(0.9 * K_SCREEN_WIDTH * 0.8)));
    }];
    [self.disMissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.hexColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorPickerView.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
    }];
    [self.hexColorField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hexColorLabel);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(30));
        make.width.mas_equalTo(@(100));
    }];
    [self.rocketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hexColorLabel);
        make.bottom.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rocketImageView);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@90);
    }];
    [self.recommendColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rocketImageView);
        make.right.equalTo(self.confirmButton);
        make.bottom.equalTo(self.rocketImageView.mas_top).offset(-15);
        make.height.mas_equalTo(@30);
    }];
}
#pragma mark - delegates
- (void)ZHNColorPickerPickColor:(UIColor *)color {
    [self p_colorPickerReloadColor:color];
}

#pragma mark - pravite methods
- (void)p_colorPickerReloadColor:(UIColor *)color {
    [self.colorChangeSubject sendNext:color];
    self.hexColorLabel.text = [color hexString];
    UIImage *normalImage = [[UIImage imageNamed:@"close"] imageWithTintColor:color];
    [_disMissButton setImage:normalImage forState:UIControlStateNormal];
    self.rocketImageView.backgroundColor = color;
    self.confirmButton.backgroundColor = color;
    [self.recommendColorView selectItemView].backgroundColor = color;
}

- (void)p_initActions {
    @weakify(self)
    [[_hexColorField rac_signalForControlEvents:UIControlEventPrimaryActionTriggered] subscribeNext:^(UITextField *colorField) {
        // no input
        if (colorField.text.length == 0) {
            [colorField resignFirstResponder];
            return;
        }
        // reload color picker show color
        @strongify(self);
        UIColor *selectColor = [UIColor colorWithHexString:colorField.text];
        if (selectColor) {
            [self.colorPickerView reloadShowColor:selectColor];
        }else {
            [self.colorPickerView reloadShowColor:[UIColor colorWithHexString:@"#000000"]];
        }
        [colorField resignFirstResponder];
    }];
    
    [[_disMissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [ZHNMainControllerColorPickerTrasitionHelper disMissColorPciker];
    }];
    
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.recommendColorView updateRecommendColors];
        [ZHNMainControllerColorPickerTrasitionHelper disMissColorPickerWithCompletion:^{
            [ZHNThemeManager zhn_cacheThemeColor:self.colorPickerView.pickerSelectColor];
            [ZHNThemeManager zhn_reloadColorTheme];
        }];
    }];
    
    [_recommendColorView.recommendColorSelectSubject subscribeNext:^(ZHNRecommendColorItemView *recommendItemView) {
        @strongify(self);
        [self p_colorPickerReloadColor:recommendItemView.backgroundColor];
        [self.colorPickerView reloadShowColor:recommendItemView.backgroundColor];
    }];
}
#pragma mark - getters
- (ZHNColorPickerView *)colorPickerView {
    if (_colorPickerView == nil) {
        _colorPickerView = [[ZHNColorPickerView alloc]init];
        _colorPickerView.showColor = [ZHNThemeManager zhn_getThemeColor];
        _colorPickerView.delegate = self;
    }
    return _colorPickerView;
}

- (UITextField *)hexColorField {
    if (_hexColorField == nil) {
        _hexColorField = [[UITextField alloc]init];
        _hexColorField.layer.cornerRadius = 6;
        _hexColorField.layer.borderColor = RGBCOLOR(212, 212, 212).CGColor;
        _hexColorField.layer.borderWidth = 1;
        _hexColorField.returnKeyType = UIReturnKeyDone;
    }
    return _hexColorField;
}

- (UILabel *)hexColorLabel {
    if (_hexColorLabel == nil) {
        _hexColorLabel = [[UILabel alloc]init];
        _hexColorLabel.text = [[ZHNThemeManager zhn_getThemeColor] hexString];
        [_hexColorLabel sizeToFit];
        _hexColorLabel.font = [UIFont systemFontOfSize:20];
    }
    return _hexColorLabel;
}

- (UIButton *)disMissButton {
    if (_disMissButton == nil) {
        _disMissButton = [[UIButton alloc]init];
        UIImage *normalImage = [[UIImage imageNamed:@"close"] imageWithTintColor:[ZHNThemeManager zhn_getThemeColor]];
        [_disMissButton setImage:normalImage forState:UIControlStateNormal];
    }
    return _disMissButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
        _confirmButton.layer.cornerRadius = 5;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (UIImageView *)rocketImageView {
    if (_rocketImageView == nil) {
        _rocketImageView = [[UIImageView alloc]init];
        _rocketImageView.contentMode = UIViewContentModeCenter;
        _rocketImageView.image = [UIImage imageNamed:@"tabbar_icon_post"];
        _rocketImageView.layer.cornerRadius = 20;
        _rocketImageView.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
    }
    return _rocketImageView;
}

- (ZHNRecommendColorView *)recommendColorView {
    if (_recommendColorView == nil) {
        _recommendColorView = [[ZHNRecommendColorView alloc]init];
    }
    return _recommendColorView;
}

- (RACSubject *)colorChangeSubject {
    if (_colorChangeSubject == nil) {
        _colorChangeSubject = [RACSubject subject];
    }
    return _colorChangeSubject;
}
@end

////////////////////////////////////////////////////////
@interface ZHNRecommendColorView()
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,assign) NSInteger selectIndex;
@end

@implementation ZHNRecommendColorView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[ZHNRecommendColorModel recommendColorModelArray] enumerateObjectsUsingBlock:^(ZHNRecommendColorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZHNRecommendColorModel *colorModel = (ZHNRecommendColorModel *)obj;
            ZHNRecommendColorItemView *itemView = [[ZHNRecommendColorItemView alloc]init];
            itemView.backgroundColor = [UIColor colorWithHexString:colorModel.hexString];
            if (colorModel.isThemeColor) {
                itemView.tagView.hidden = NO;
                self.selectIndex = idx;
            }
            itemView.tag = idx;
            [self addSubview:itemView];
            [self.itemArray addObject:itemView];
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectItemAction:)];
            [itemView addGestureRecognizer:tapGes];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width / self.itemArray.count;
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * width;
        [obj setFrame:CGRectMake(x, 0, width, self.height)];
    }];
}

#pragma mark - public methods
- (void)updateRecommendColors {
    NSArray *colorModelArray = [ZHNRecommendColorModel recommendColorModelArray];
    [colorModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHNRecommendColorModel *model = (ZHNRecommendColorModel *)obj;
        if (model.isThemeColor) {
            if (idx == self.selectIndex) {
                model.hexString = [self.selectItemView.backgroundColor hexString];
                [model updateToDB];
            }else {
                model.isThemeColor = NO;
                [model updateToDB];
            }
        }else {
            if (idx == self.selectIndex) {
                model.isThemeColor = YES;
                model.hexString = [self.selectItemView.backgroundColor hexString];
                [model updateToDB];
            }
        }
    }];
}

#pragma mark - target action
- (void)selectItemAction:(UITapGestureRecognizer *)tap {
    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == [tap view].tag) {
            self.selectIndex = idx;
            [(ZHNRecommendColorItemView *)obj tagView].hidden = NO;
            [self.recommendColorSelectSubject sendNext:[tap view]];
        }else {
            [(ZHNRecommendColorItemView *)obj tagView].hidden = YES;
        }
    }];
}

#pragma mark - getters
- (ZHNRecommendColorItemView *)selectItemView {
    return self.itemArray[self.selectIndex];
}

- (NSMutableArray *)itemArray {
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (RACSubject *)recommendColorSelectSubject {
    if (_recommendColorSelectSubject == nil) {
        _recommendColorSelectSubject = [RACSubject subject];
    }
    return _recommendColorSelectSubject;
}
@end

////////////////////////////////////////////////////////
static CGFloat const KtagSquraWH = 10;
static CGFloat const KtagPadding = 3;
@implementation ZHNRecommendColorItemView
- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.tagView];
    self.tagView.frame = CGRectMake(self.width - KtagPadding - KtagSquraWH , KtagPadding, KtagSquraWH, KtagSquraWH);
    // mask
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(KtagSquraWH, 0)];
    [path addLineToPoint:CGPointMake(KtagSquraWH, KtagSquraWH)];
    [path closePath];
    layer.path = path.CGPath;
    self.tagView.layer.mask = layer;
    // observe color for change tag view color
    @weakify(self)
    [RACObserve(self, self.backgroundColor) subscribeNext:^(UIColor *color) {
        @strongify(self)
        if ([color isLightColor]) {
            self.tagView.backgroundColor = [UIColor blackColor];
        }else {
            self.tagView.backgroundColor = [UIColor whiteColor];
        }
    }];
}

- (UIView *)tagView {
    if (_tagView == nil) {
        _tagView = [[UIView alloc]init];
        _tagView.backgroundColor = [UIColor blackColor];
        _tagView.hidden = YES;
    }
    return _tagView;
}
@end




