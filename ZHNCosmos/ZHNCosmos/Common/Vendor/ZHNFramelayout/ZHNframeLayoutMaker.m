//
//  ZHNframeLayoutMaker.m
//  ZHNframeLayout
//
//  Created by zhn on 16/4/22.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNframeLayoutMaker.h"

typedef NS_ENUM(NSUInteger,makeType){
    makeTypeLeft,
    makeTypeRight,
    makeTypeTop,
    makeTypeBottom,
    makeTypeCenter,
    makeTypeHeight,
    makeTypeWeight,
    makeTypeCenterX,
    makeTypeCenterY
};

@interface ZHNframeLayoutMaker()

@property (nonatomic,assign) makeType type;
@property (nonatomic,assign) CGRect frameRect;
@property (nonatomic,strong) UIView * supView;
@property (nonatomic,strong) NSMutableDictionary * statusArrayDic;

@end

@implementation ZHNframeLayoutMaker

- (instancetype)init{
    if (self = [super init]) {
        _frameRect = CGRectMake(0, 0, 0, 0);
    }
    return self;
}

- (instancetype)initWithSupView:(UIView *)view{
    if (self = [super init]) {
        _supView = view;
    }
    return self;
}
// 懒加载
- (NSMutableDictionary *)statusArrayDic{
    if (_statusArrayDic== nil) {
        _statusArrayDic= [NSMutableDictionary dictionary];
    }
    return _statusArrayDic;
}

- (ZHNframeLayoutMaker *)left{
    self.type = makeTypeLeft;
    return self;
}
- (ZHNframeLayoutMaker *)right{
    self.type = makeTypeRight;
    return self;
}
- (ZHNframeLayoutMaker *)top{
    self.type = makeTypeTop;
    return self;
}
- (ZHNframeLayoutMaker *)bottom{
    self.type = makeTypeBottom;
    return self;
}
- (ZHNframeLayoutMaker *)height{
    self.type = makeTypeHeight;
    return self;
}
- (ZHNframeLayoutMaker *)width{
    self.type = makeTypeWeight;
    return self;
}
- (ZHNframeLayoutMaker *)center{
    self.type = makeTypeCenter;
    return self;
}
- (ZHNframeLayoutMaker *)centerX{
    self.type = makeTypeCenterX;
    return self;
}

- (ZHNframeLayoutMaker *)centerY{
    self.type = makeTypeCenterY;
    return self;
}


- (ZHNframeLayoutMaker *(^)(CGFloat))eaqualTo{
    
    ZHNframeLayoutMaker *(^frameBlock)(CGFloat) = ^(CGFloat temp){
        [self.statusArrayDic setObject:@(temp) forKey:[NSString stringWithFormat:@"%lu",(unsigned long)self.type]];
        return self;
    };
    return frameBlock;
}
- (void(^)(CGFloat))zhn_eaqualTo{
    
    void(^frameBlock)(CGFloat status) = ^(CGFloat status){
        [self.statusArrayDic setValue:@(status) forKey:[NSString stringWithFormat:@"%lu",self.type]];
    };
    return frameBlock;
}

- (void(^)(CGFloat))withOffset{
    void(^frameBlock)(CGFloat) = ^(CGFloat status){
        CGFloat temp = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",self.type]]floatValue];
        temp = temp + status;
        [self.statusArrayDic setValue:@(temp) forKey:[NSString stringWithFormat:@"%lu",self.type]];
    };
    return frameBlock;
}

- (void)countFrame{
    
    CGFloat left = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeLeft]]floatValue];
    CGFloat right = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeRight]]floatValue];
    CGFloat top = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeTop]]floatValue];
    CGFloat bottom = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeBottom]]floatValue];
    CGFloat centerX = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeCenterX]]floatValue];
    CGFloat centerY = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeCenterY]]floatValue];
    CGFloat height = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeHeight]]floatValue];
    CGFloat weight = [[self.statusArrayDic objectForKey:[NSString stringWithFormat:@"%lu",makeTypeWeight]]floatValue];
    
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat currentW = 0;
    CGFloat currentH = 0;
    
    if (left) {
        currentX = left;
        if (right) {
            currentW = right - left;
        }
    }
    
    if (top) {
        currentY = top;
        if (bottom) {
            currentH = bottom - top;
        }
    }
    
    if (weight) {
        currentW = weight;
    }
    
    if (height) {
        currentH = height;
    }
    
    if (centerX) {
        currentX = centerX - 0.5 * weight;
        if (centerY) {
            self.supView.center = CGPointMake(centerX, centerY);
        }
    }
    if (centerY) {
        currentY = centerY - 0.5 * height;
    }
    
    self.frameRect = CGRectMake(currentX, currentY, currentW, currentH);
}

- (CGRect)getViewFrame{
    [self countFrame];
    return self.frameRect;
}
@end
