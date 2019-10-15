//
//  ZHNAwesome3DMenu.m
//  ZHNAwesome3DMenu
//
//  Created by zhn on 2017/9/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNAwesome3DMenu.h"
#import "ZHNShineButton.h"
#import "UIImage+Tint.h"
#define K_3DMenu_WIDTH self.frame.size.width
#define K_3DMenu_HEIGHT self.frame.size.height
#define K_Activity_Count self.menuActivityArray.count
@interface ZHNAwesome3DMenu()
@property (nonatomic,copy) NSArray *menuActivityArray;
@property (nonatomic,strong) NSMutableArray *menuItemArray;
@property (nonatomic,strong) NSMutableArray *itemResponsePathArray;
@property (nonatomic,strong) ZHNShineButton *selectedItem;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation ZHNAwesome3DMenu
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // gesture
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheMenu:)];
        [self addGestureRecognizer:panGes];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.itemResponsePathArray.count > 0) {
        return;
    }
    self.layer.cornerRadius = self.frame.size.width / 2;
    CGFloat initalTh = M_PI / ((K_Activity_Count - 1) * 2 + 2);
    CGFloat th = (M_PI - 2 * initalTh) / (K_Activity_Count - 1);
    // menu item frame
    for (int index = 0; index < K_Activity_Count; index++) {
        CGFloat radius = (K_3DMenu_WIDTH / 2) * 0.75;
        ZHNShineButton *item = self.menuItemArray[index];
        [self addSubview:item];
        item.transform = CGAffineTransformIdentity;
        item.center = CGPointMake(K_3DMenu_WIDTH/2, K_3DMenu_HEIGHT/2);
        item.bounds = CGRectMake(0, 0, 35, 35);
        CGFloat revolve = initalTh + th * index;
        CGFloat yTranslate = sin(revolve) * radius;
        CGFloat xTranslate = cos(revolve) * radius;
        item.transform = CGAffineTransformMakeTranslation(-xTranslate, -yTranslate);
    }
    // item touch path
    [self.itemResponsePathArray removeAllObjects];
    CGPoint centerPoint = CGPointMake(K_3DMenu_WIDTH/2, K_3DMenu_HEIGHT/2);
    CGFloat radius = K_3DMenu_WIDTH/2;
    CGFloat touchTh = M_PI / K_Activity_Count;
    for (int index = 0; index < K_Activity_Count; index++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:centerPoint];
        CGFloat startAngle = M_PI + index * touchTh;
        CGFloat endAngle = M_PI + (index + 1) * touchTh;
        [path addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path closePath];
        [self.itemResponsePathArray addObject:path];
    }
    // icon image
    [self addSubview:self.iconImageView];
    self.iconImageView.center = CGPointMake(self.width/2, self.height/2);
    self.iconImageView.bounds = CGRectMake(0, 0, 40, 40);
    // title label
    [self addSubview:self.titleLabel];
    self.titleLabel.center = CGPointMake(self.iconImageView.center.x, -30);
    self.titleLabel.bounds = CGRectMake(0, 0, K_SCREEN_WIDTH, 30);
    
}

#pragma mark - target action
- (void)panTheMenu:(UIPanGestureRecognizer *)panGes {
    [self p_effectWithGesture:panGes];
}

#pragma mark - public methods
+ (ZHNAwesome3DMenu *)zhn_3dMenuWithActivityArray:(NSArray<ZHN3DMenuActivity *> *)activityArray {
    ZHNAwesome3DMenu *menu = [[ZHNAwesome3DMenu alloc]init];
    menu.menuActivityArray = activityArray;
    return menu;
}

- (void)animateAllItem {
    [self.menuItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHNShineButton *btn = (ZHNShineButton *)obj;
        [btn animateHightLight];
    }];
}

#pragma mark - pravite methods
- (CATransform3D)p_transformWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf{
    CATransform3D t = CATransform3DIdentity;
    t.m34  = m34;
    t = CATransform3DRotate(t, M_PI/9 * yf, -1, 0, 0);
    t = CATransform3DRotate(t, M_PI/9 * xf, 0, 1, 0);
    return t;
}

- (void)p_effectWithGesture:(UIGestureRecognizer *)panGes{
    CGPoint touchPoint = [panGes locationInView:self];
    switch (panGes.state) {
        case UIGestureRecognizerStateChanged:
        {
            // change coordinate system
            CGFloat xFactor = MIN(1, MAX(-1,(touchPoint.x - (self.bounds.size.width/2)) / (self.bounds.size.width/2)));
            CGFloat yFactor = MIN(1, MAX(-1,(touchPoint.y - (self.bounds.size.height/2)) / (self.bounds.size.height/2)));
            // change transform
            self.layer.transform = [self p_transformWithM34:1.0/-500 xf:xFactor yf:yFactor];
            // judge touch item
            __block int index = -1;
            [self.itemResponsePathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIBezierPath *path = (UIBezierPath *)obj;
                if ([path containsPoint:touchPoint]) {
                    index = (int)idx;
                    *stop = YES;
                }
            }];
            // animate
            ZHN3DMenuActivity *oldActivity = self.menuActivityArray[self.selectedItem.tag];
            self.selectedItem.unconventionalImage = oldActivity.normalImage;
            if (index >= 0 && index < K_Activity_Count) {
                self.selectedItem = self.menuItemArray[index];
                ZHN3DMenuActivity *currentActivity = self.menuActivityArray[self.selectedItem.tag];
                self.titleLabel.text = currentActivity.title;
                self.selectedItem.unconventionalImage = currentActivity.highLightImage;
            }
            if (index < 0) {
                self.titleLabel.text = @"取消";
                self.selectedItem = nil;
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.selectedItem) {
                if ([self.delegate respondsToSelector:@selector(ZHNAwesome3DMenuSelectedIndex:)]) {
                    [self.delegate ZHNAwesome3DMenuSelectedIndex:self.selectedItem.tag];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - setters
- (void)setMenuActivityArray:(NSArray *)menuActivityArray {
    _menuActivityArray = menuActivityArray;
    // clear status
    [self.menuItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        [view removeFromSuperview];
        view = nil;
    }];
    [self.menuItemArray removeAllObjects];
    // menu item init
    for (int index = 0; index < K_Activity_Count; index++) {
        ZHN3DMenuActivity *activity = self.menuActivityArray[index];
        ZHNShineButton *item = [ZHNShineButton zhn_shineButtonWithTintColor:activity.titnColor normalImage:activity.normalImage hightLightImage:activity.normalImage normalTypeTapAction:nil hightLightTypeTapAction:nil];
        item.tag = index;
        [self.menuItemArray addObject:item];
    }
}

- (void)setHostGesture:(UIGestureRecognizer *)hostGesture {
    _hostGesture = hostGesture;
    [self p_effectWithGesture:hostGesture];
}

- (void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
}

#pragma mark - getters
- (NSMutableArray *)menuItemArray {
    if (_menuItemArray == nil) {
        _menuItemArray = [NSMutableArray array];
    }
    return _menuItemArray;
}

-(NSMutableArray *)itemResponsePathArray {
    if (_itemResponsePathArray == nil) {
        _itemResponsePathArray = [NSMutableArray array];
    }
    return _itemResponsePathArray;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"菜单";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:22];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
@end

/////////////////////////////////////////////////////
@interface ZHN3DMenuActivity()

@end

@implementation ZHN3DMenuActivity
+ (ZHN3DMenuActivity *)zhn_activityWithTitle:(NSString *)title tintColor:(UIColor *)tintColor normalImage:(UIImage *)normalImage highLightImage:(UIImage *)hightLightImage selectAction:(ZHN3DMenuSelectBlock)selectAction {
    ZHN3DMenuActivity *activity = [[ZHN3DMenuActivity alloc]init];
    activity.title = title;
    activity.normalImage = normalImage;
    activity.highLightImage = hightLightImage;
    activity.selectAction = selectAction;
    activity.titnColor = tintColor;
    return activity;
}

+ (ZHN3DMenuActivity *)zhn_activityWithTitle:(NSString *)title tintColor:(UIColor *)tintColor imageName:(NSString *)imageName normalColor:(UIColor *)normalColor highLoghtColor:(UIColor *)highLoghtColor selectionAction:(ZHN3DMenuSelectBlock)selectAction{
    ZHN3DMenuActivity *activity = [[ZHN3DMenuActivity alloc]init];
    activity.title = title;
    activity.titnColor = tintColor;
    activity.normalImage = [[UIImage imageNamed:imageName] imageWithTintColor:normalColor];
    activity.highLightImage = [[UIImage imageNamed:imageName] imageWithTintColor:highLoghtColor];
    activity.selectAction = selectAction;
    return activity;
}
@end
