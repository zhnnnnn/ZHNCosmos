//
//  ZHNHomepageRelationshipButton.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/7.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ZHNUserRelationShip) {
    ZHNUserRelationShipUnknown,
    ZHNUserRelationShipFollowing,
    ZHNUserRelationShipFollowMe,
    ZHNUserRelationShipFollowEachOther,
    ZHNUserRelationShipNone,
};
@interface ZHNHomepageRelationshipButton : UIButton
@property (nonatomic,assign) ZHNUserRelationShip relationShip;
@property (nonatomic,assign,readonly) CGFloat fitWidth;
@end
