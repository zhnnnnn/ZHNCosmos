//
//  ZHNHomePageHeadPlaceHolder.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/4.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHNPlaceholderBlur) {
    ZHNPlaceholderBlurChanging,
    ZHNPlaceholderBlurFull,
    ZHNPlaceholderBlurTypeChange
};
@interface ZHNHomePageHeadPlaceHolder : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) ZHNPlaceholderBlur blurType;
- (void)zhn_fantasyChangeWithOffsetY:(CGFloat)offsetY
                 imageOriginalHeight:(CGFloat)originalHeight
                    imageBlurPercent:(CGFloat)blurPercent;
@end
