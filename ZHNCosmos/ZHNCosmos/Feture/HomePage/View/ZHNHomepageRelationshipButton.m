
//
//  ZHNHomepageRelationshipButton.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/7.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomepageRelationshipButton.h"
#import "ZHNStatusHelper.h"

static CGFloat const KTitleFont = 14;
@implementation ZHNHomepageRelationshipButton
- (instancetype)init {
    if (self = [super init]) {
        self.titleLabel.font = [UIFont systemFontOfSize:KTitleFont];
        [self setTitle:@"未知" forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.layer.borderColor = ZHNHexColor(@"969696").CGColor;
        [self setTitleColor:ZHNHexColor(@"969696") forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2;
}

- (void)setRelationShip:(ZHNUserRelationShip)relationShip {
    _relationShip = relationShip;
    NSString *string = [self fitString];
    [self setTitle:string forState:UIControlStateNormal];
}

- (NSString *)fitString {
    NSString *string;
    switch (_relationShip) {
        case ZHNUserRelationShipUnknown:
        {
            string = @"未知";
        }
            break;
        case ZHNUserRelationShipFollowing:
        {
            string = @"已关注";
        }
            break;
        case ZHNUserRelationShipFollowMe:
        {
            string = @"+关注(关注我)";
        }
            break;
        case ZHNUserRelationShipFollowEachOther:
        {
            string = @"互相关注";
        }
            break;
        case ZHNUserRelationShipNone:
        {
            string = @"+关注(未关注我)";
        }
            break;
    }
    return string;
}

- (CGFloat)fitWidth {
    NSString *string = [self fitString];
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KTitleFont]}];
    CGFloat width = size.width + 15;
    return width;
}

@end
