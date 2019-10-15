//
//  ZHNSelectColorFitNightVersionCellNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/27.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNSelectColorFitNightVersionCellNode.h"

@implementation ZHNSelectColorFitNightVersionCellNode
- (UIView *)selectedBackgroundView {
    UIView *selectView = [[UIView alloc]init];
    selectView.backgroundColor = ZHNCurrentThemeFitColorForkey(CellSelectedColor);
    return selectView;
}
@end
