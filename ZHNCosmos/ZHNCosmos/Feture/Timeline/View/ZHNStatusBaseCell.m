//
//  ZHNStatusBaseCell.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStatusBaseCell.h"
#import "ZHNTimer.h"

@interface ZHNStatusBaseCell()
@property (nonatomic,strong) ZHNTimer *touchTimer;
@property (nonatomic,assign) BOOL isLongPress;
@end

@implementation ZHNStatusBaseCell
#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isLongPress = NO;
    [self.touchTimer invalidate];
    @weakify(self);
    self.touchTimer = [ZHNTimer zhn_timerWIthTimeInterval:0.5 repeats:NO handler:^{
        @strongify(self);
        self.isLongPress = YES;
    }];
    [self.touchTimer fire];
    
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *touchView = [self p_touchingViewForTouches:touches event:event];
    [self touchingAnimateForView:touchView touchPoint:touchPoint];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.touchTimer invalidate];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *touchView = [self p_touchingViewForTouches:touches event:event];
    if (!self.isLongPress) {
        [self tapCellInView:touchView point:touchPoint];
    }else {
        [self longPressCellInView:touchView point:touchPoint];
    }
}


- (UIView *)p_touchingViewForTouches:(NSSet<UITouch *> *)touches event:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *view = [self hitTest:touchPoint withEvent:event];
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        view = self;
    }
    return view;
}

- (void)touchingAnimateForView:(UIView *)view touchPoint:(CGPoint)touchPoint{}
- (void)tapCellInView:(UIView *)view point:(CGPoint)tapPoint{}
- (void)longPressCellInView:(UIView *)view point:(CGPoint)point{}
@end
