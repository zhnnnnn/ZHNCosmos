//
//  ZHNStatusToolView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/14.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStatusToolView.h"
#import "UIView+ZHNFirework.h"
#import "NSString+Count.h"
#import "ZHNTimelineModel.h"
#import "ZHNTimelineDetailContainViewController.h"
#import "UIView+ZHNDoodleMenuBar.h"

typedef NS_ENUM(NSInteger,ZHNToolItemType) {
    ZHNToolItemTypeReweet = 0,
    ZHNToolItemTypeComment = 1,
    ZHNToolItemTypeLike = 2,
    ZHNToolItemTypeMore = 3
};

@implementation ZHNStatusToolView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *imageNameArray = @[@"weibostatus_retweet",@"weibostatus_comment",@"weibo_status_attitude",@"weibostatus_more_small"];
        for (int index = 0; index < 4; index++) {
            ZHNStatusToolBarButton *btn = [[ZHNStatusToolBarButton alloc]init];
            [self addSubview:btn];
            btn.tag = index;
            UIImage *image = [[UIImage imageNamed:imageNameArray[index]] imageWithTintColor:KTabbarItemNormalColor];
            [btn setTitleColor:KTabbarItemNormalColor forState:UIControlStateNormal];
            [btn setImage:image forState:UIControlStateNormal];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (index == 0) {
                    [self p_seeStatusDetailWithDefultType:ZHNDefaultShowTypeTransmit];
                }else if (index == 1) {
                    [self p_seeStatusDetailWithDefultType:ZHNDefaultShowTypeComments];
                }else if (index == 2) {
                    [btn fireInTheHole];
                }else {
                    [btn zhn_showDoodleMenuBarWithMenuButtonItemArray:[self p_getDoodleMenuButtonItemArray] tintColor:[ZHNThemeManager zhn_getThemeColor] clickItemHandle:^(NSInteger index, BOOL isTypeSelectAfter) {
                        [ZHNHudManager showWarning:@"TODO~"];
                    }];
                }
            }];
        }
    }
    return self;
}

- (NSArray *)p_getDoodleMenuButtonItemArray {
    NSArray *imageNameArray = @[@"activity_favorite",@"linkIcon_weibo",@"linkIcon_link",@"bubble_popover_copy",@"bubble_popover_share_activity"];
    NSMutableArray *itemArray = [NSMutableArray array];
    [imageNameArray enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHNDoodleMenuButtonItem *item = [ZHNDoodleMenuButtonItem zhn_doodleMenuButtonItemWithImageName:imageName imageNormalColor:ZHNHexColor(@"#BEBEBE") imageSelectColor:[UIColor whiteColor] isSelectd:NO];
        [itemArray addObject:item];
    }];
    return itemArray;
}

- (void)p_seeStatusDetailWithDefultType:(ZHNDefaultShowType)defaultType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params zhn_safeSetObjetct:self.status forKey:KCellToSeeStatusDetailStatusKey];
    [params zhn_safeSetObjetct:@(defaultType) forKey:KCellToSeeStatusDetailDefaultTypeKey];
    [self zhn_routerEventWithName:KCellToSeeStatusDetailAction userInfo:params];
}

#pragma mark - setters
- (void)setToolbarFrame:(CGRect)toolbarFrame {
    _toolbarFrame = toolbarFrame;
    self.frame = toolbarFrame;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![view isKindOfClass:[UIButton class]]) {return ;}
        UIButton *btn = (UIButton *)view;
        CGFloat w = self.width/4;
        CGFloat x = w * idx;
        btn.frame = CGRectMake(x, 0, w, self.height);
        if (self.isReweet) {
            btn.titleLabel.font = [UIFont systemFontOfSize:9];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        }else {
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        }
    }];
}

- (void)setStatus:(ZHNTimelineStatus *)status {
    _status = status;
    [self.subviews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[ZHNStatusToolBarButton class]]) {
            ZHNStatusToolBarButton *btn = (ZHNStatusToolBarButton *)view;
            switch (btn.tag) {
                case ZHNToolItemTypeReweet:
                {
                    NSString *countStr = [NSString showStringForCount:status.repostsCount];
                    [btn setTitle:countStr forState:UIControlStateNormal];
                }
                    break;
                case ZHNToolItemTypeComment:
                {
                    NSString *countStr = [NSString showStringForCount:status.commentsCount];
                    [btn setTitle:countStr forState:UIControlStateNormal];
                }
                    break;
                case ZHNToolItemTypeLike:
                {
                    NSString *countStr = [NSString showStringForCount:status.attitudesCount];
                    [btn setTitle:countStr forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

@end

////////////////////////////////////////////////////////
@implementation ZHNStatusToolBarButton
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0, 0, self.height * 0.30, self.height * 0.30);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
@end


