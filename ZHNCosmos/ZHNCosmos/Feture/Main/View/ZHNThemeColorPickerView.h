//
//  ZHNThemeColorPickerView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNThemeColorPickerView : UIView
@property (nonatomic,strong) RACSubject *colorChangeSubject;
@end

////////////////////////////////////////////////////////
@class ZHNRecommendColorItemView;
@interface ZHNRecommendColorView : UIView
@property (nonatomic,strong) RACSubject *recommendColorSelectSubject;
@property (nonatomic,strong) ZHNRecommendColorItemView *selectItemView;
- (void)updateRecommendColors;
@end

////////////////////////////////////////////////////////
@interface ZHNRecommendColorItemView : UIView
@property (nonatomic,strong) UIView *tagView;
@end
