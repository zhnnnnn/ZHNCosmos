//
//  ZHNHomePageInformationTool.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/5.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHomePageInformationTool.h"
#import "ZHNHomePageToolButton.h"

@interface ZHNHomePageInformationTool()
@property (weak, nonatomic) IBOutlet ZHNHomePageToolButton *allTimeLineBtn;
@property (weak, nonatomic) IBOutlet ZHNHomePageToolButton *followingBtn;
@property (weak, nonatomic) IBOutlet ZHNHomePageToolButton *fansBtn;

@end

@implementation ZHNHomePageInformationTool
+ (instancetype)loadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (IBAction)timelineAction:(id)sender {

}
- (IBAction)focusesAction:(id)sender {
    
}
- (IBAction)fansAction:(id)sender {
    
}

- (void)setUserDetail:(ZHNTimelineUser *)userDetail {
    _userDetail = userDetail;
    NSString *allString = [NSString stringWithFormat:@"%d 微博",userDetail.statusesCount];
    NSString *followString = [NSString stringWithFormat:@"%d 正在关注",userDetail.friendsCount];
    NSString *fansString = [NSString stringWithFormat:@"%lld 粉丝",userDetail.followersCount];
    [self.allTimeLineBtn setTitle:allString forState:UIControlStateNormal];
    [self.followingBtn setTitle:followString forState:UIControlStateNormal];
    [self.fansBtn setTitle:fansString forState:UIControlStateNormal];
}
@end
