//
//  ZHNHomePageNavibar.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/2.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNHomePageHeaderView.h"
@class ZHNHomePageHead,ZHNHomePageHeadPlaceHolder;

@protocol ZHNHomePageNavibarDelegate <NSObject>
@optional
- (void)ZHNHomepageNavibarClickPopController;
@end

@interface ZHNHomePageNavibar : UIView
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *avatarURLStr;
@property (nonatomic,assign) ZHNHomePageType homepageType;
@property (nonatomic,weak) id <ZHNHomePageNavibarDelegate> delegate;
+ (instancetype)loadView;
- (void)zhn_observePlaceholder:(ZHNHomePageHeadPlaceHolder *)placeholder;
- (void)zhn_nameLabelMagicTransWithPercent:(CGFloat)percent;
- (void)zhn_avatarMagicTransWithPercent:(CGFloat)percent;
@end
