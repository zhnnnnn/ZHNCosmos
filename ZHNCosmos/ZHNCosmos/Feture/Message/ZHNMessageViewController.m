//
//  ZHNMessageViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/26.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNMessageViewController.h"

@interface ZHNMessageViewController ()

@end

@implementation ZHNMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(NormalViewBG);
    
    UILabel *todoLabel = [[UILabel alloc]init];
    todoLabel.text = @"Message TODO~";
    todoLabel.font = [UIFont systemFontOfSize:25];
    todoLabel.dk_textColorPicker = DKColorPickerWithKey(CellTextColor);
    [self.view addSubview:todoLabel];
    [todoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}
@end
