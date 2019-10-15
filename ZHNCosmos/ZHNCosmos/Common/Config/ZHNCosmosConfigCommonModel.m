//
//  ZHNCosmosConfigCommonModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCosmosConfigCommonModel.h"

@implementation ZHNCosmosConfigCommonModel
+ (void)configIfNeed {
    if ([ZHNCosmosConfigCommonModel searchWithWhere:nil].count == 0) {
        ZHNCosmosConfigCommonModel *model = [[ZHNCosmosConfigCommonModel alloc]init];
        // font padding
        model.font = 17;
        model.padding = 7;
        model.fontName = @"Heiti SC";
        // controlpad
        model.isOnSound = YES;
        model.isTimelineShowImage = YES;
        model.isWebReadingMode = YES;
        model.isTimelineWideCardType = YES;
        //
        model.isNeedTapicEngine = YES;
        // refresh
        model.isHightlightShowUrl = YES;
        model.isRefreshPositiveSequence = NO;
        model.isNeedAutoRefreshAfterPublish = YES;
        model.everytimeRefeshCount = everytimeRefeshCount100;
        model.maxTimelineCacheCount = maxTimelineCacheCount350;
        // pic
        model.bigpicQuality = bigpicQualitySmart;
        model.isShowFlowCorner = YES;
        model.bigpicPreload = bigpicPreloadSmart;
        model.isLoadbigpicshowMask = YES;
        model.picuploadQuality = picuploadQualitySmart;
        // visual animate
        model.everydayRandomThemeColor = NO;
        model.navigationbarFitThemeColor = YES;
        model.dynamicScrollNavibar = YES;
        model.touchViewTransfromAnimate = YES;
        model.transitionType = controllerTransitionTypeLeftRight;
        model.tabbarControllerTransionAnimate = YES;
        
        [model saveToDB];
    }
}

+ (NSString *)zhn_resetConfigSuccessNotificationNameForPropertyName:(NSString *)propertyName {
    return [NSString stringWithFormat:@"ZHNCosmos_reset_%@_success",propertyName];
}

@end
