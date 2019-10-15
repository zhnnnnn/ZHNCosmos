//
//  ZHNDoodleMenuBar.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/20.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHNDoodleMenuBarDelegate <NSObject>
- (void)ZHNDoodleMenuBarClickIndex:(NSInteger)index barItemIsSelectAfter:(BOOL)select;
@end

@class ZHNDoodleMenuButtonItem;
@interface ZHNDoodleMenuBar : UIView
@property (nonatomic,weak) id <ZHNDoodleMenuBarDelegate> delegate;
@property (nonatomic,strong) UIColor *tintColor;
+ (instancetype)zhn_doodleMenuBarWithMenuButtonItemArray:(NSArray <ZHNDoodleMenuButtonItem *>*)menuItemArray;
- (void)zhn_animateShowDoodleMenuBarWithAnchroPoint:(CGPoint)anchroPoint;
@end

////////////////////////////////////////////////////////
@interface ZHNDoodleMenuButtonItem : NSObject
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,assign) BOOL selected;
+ (instancetype)zhn_doodleMenuButtonItemWithImageName:(NSString *)imageName
                                     imageNormalColor:(UIColor *)normalColor
                                     imageSelectColor:(UIColor *)selectColor
                                            isSelectd:(BOOL)selected;
@end
