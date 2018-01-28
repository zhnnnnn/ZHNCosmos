//
//  ZHNHomePageHeaderView.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/1.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNJellyMagicSwitch.h"
#import "ZHNTimelineModel.h"

typedef NS_ENUM(NSInteger,ZHNHomePageType) {
    ZHNHomePageTypeMine,
    ZHNHomePageTypeOther
};

@interface ZHNHomePageHeaderView : UIView
// Config
@property (nonatomic,assign,readonly) CGFloat curveHeight;
@property (nonatomic,assign,readonly) CGFloat switcherHeight;
@property (nonatomic,assign,readonly) CGFloat switcherPadding;
@property (nonatomic,assign,readonly) CGFloat avatorStartTransHeight;
@property (nonatomic,assign,readonly) CGFloat avatorEndTransHeight;
@property (nonatomic,assign,readonly) CGFloat nameStartTransHeight;
@property (nonatomic,assign,readonly) CGFloat nameEndTransHeight;

/**
 User type
 */
@property (nonatomic,assign) ZHNHomePageType type;

// User status
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) ZHNTimelineUser *userDetail;

/**
 Header height.
 */
@property (nonatomic,assign,readonly) CGFloat headerFullHeight;

/**
 Status switcher
 */
@property (nonatomic,strong) ZHNJellyMagicSwitch *timelineTypeSwitcher;

- (void)zhn_fantasyChangeWithPercent:(CGFloat)percent;
@end
