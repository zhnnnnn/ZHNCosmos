//
//  ZHNStatusBaseCell.h
//  ZHNCosmos
//
//  Created by zhn on 2017/12/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNStatusBaseCell : UITableViewCell
- (void)touchingAnimateForView:(UIView *)view touchPoint:(CGPoint)touchPoint;

- (void)tapCellInView:(UIView *)view point:(CGPoint)tapPoint;
- (void)longPressCellInView:(UIView *)view point:(CGPoint)point;
@end
