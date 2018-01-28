//
//  UITableViewCell+ZHNSelectColor.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/27.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "UITableViewCell+ZHNSelectColor.h"
#import <objc/runtime.h>

@implementation UITableViewCell (ZHNSelectColor)
- (void)setSelectColorFitnightVersion:(BOOL)selectColorFitnightVersion {
    if (selectColorFitnightVersion) {
        UIView *selectView = [[UIView alloc]init];
        @weakify(selectView);
        selectView.extraNightVersionChangeHandle = ^{
            @strongify(selectView);
            selectView.backgroundColor = ZHNCurrentThemeFitColorForkey(CellSelectedColor);
        };
        self.selectedBackgroundView = selectView;
    }
    objc_setAssociatedObject(self, @selector(selectColorFitnightVersion), @(selectColorFitnightVersion), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selectColorFitnightVersion {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
