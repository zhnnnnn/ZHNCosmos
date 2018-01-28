//
//  ZHNControlpadCheckmark.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadCheckmark.h"
#import "ZHNCosmosConfigManager.h"

@implementation ZHNControlpadCheckmark
- (void)awakeFromNib {
    [super awakeFromNib];
    BOOL isYes = NO;
    if (self.isNightVersion) {
        isYes = [[DKNightVersionManager sharedManager] themeVersion] == DKThemeVersionNight ? YES : NO;
    }else {
        if (!self.configDBName) {return;}
        ZHNCosmosConfigCommonModel *model = [ZHNCosmosConfigManager commonConfigModel];
        isYes = [[model valueForKey:self.configDBName] boolValue];
    }
    
    self.isHightlight = isYes;
    if (isYes) {
        self.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
    }else {
        self.backgroundColor = ZHNHexColor(@"#9b9b9b");
    }
}

- (void)btnClickHandle {
    self.isHightlight = !self.isHightlight;
    ZHNCosmosConfigCommonModel *model = [ZHNCosmosConfigManager commonConfigModel];
    if (self.configDBName) {
       [model setValue:@(self.isHightlight) forKey:self.configDBName];
    }
    if (self.checkMarkHandle) {
        self.checkMarkHandle(self.isHightlight);
    }
}

@end
