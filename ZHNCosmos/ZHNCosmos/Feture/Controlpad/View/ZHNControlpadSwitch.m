//
//  ZHNControlpadSwitch.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadSwitch.h"
#import "ZHNControlpadNormalBtn.h"
#import "ZHNCosmosConfigManager.h"

@interface ZHNControlpadSwitch()
@property (nonatomic,strong) ZHNControlpadNormalBtn *leftBtn;
@property (nonatomic,strong) ZHNControlpadNormalBtn *rightBtn;
@end

@implementation ZHNControlpadSwitch
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 5;
        self.leftBtn = [[ZHNControlpadNormalBtn alloc]init];
        self.leftBtn.isNoNeedCornerRadius = YES;
        [self addSubview:self.leftBtn];
      
        self.rightBtn = [[ZHNControlpadNormalBtn alloc]init];
        self.rightBtn.isNoNeedCornerRadius = YES;
        [self addSubview:self.rightBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.leftBtn.mas_right);
    }];
    
    //ui
    ZHNCosmosConfigCommonModel *commonModel = [ZHNCosmosConfigManager commonConfigModel];
    BOOL value = [[commonModel valueForKey:self.configDBname] boolValue];
    if (value == self.leftItemForValue) {
        self.leftBtn.isHightlight = YES;
        self.rightBtn.isHightlight = NO;
        self.leftBtn.userInteractionEnabled = NO;
    }else {
        self.leftBtn.isHightlight = NO;
        self.rightBtn.isHightlight = YES;
        self.rightBtn.userInteractionEnabled = NO;
    }
    
    self.leftBtn.imageName = self.leftImageName;
    self.leftBtn.title = self.leftTitleName;
    self.rightBtn.imageName = self.rightImageName;
    self.rightBtn.title = self.rightTitleName;
    
    // action
    @weakify(self);
    self.leftBtn.normalHandle = ^{
        @strongify(self);
        if (self.valueChangeHandle) {
            self.valueChangeHandle(self.leftItemForValue);
        }
        self.leftBtn.userInteractionEnabled = NO;
        self.rightBtn.userInteractionEnabled = YES;
        self.leftBtn.isHightlight = YES;
        self.rightBtn.isHightlight = NO;
    };
    self.rightBtn.normalHandle = ^{
        @strongify(self);
        if (self.valueChangeHandle) {
            self.valueChangeHandle(self.leftItemForValue);
        }
        self.rightBtn.userInteractionEnabled = NO;
        self.leftBtn.userInteractionEnabled = YES;
        self.rightBtn.isHightlight = YES;
        self.leftBtn.isHightlight = NO;
    };
}
@end
