//
//  ZHNCosmosConfigCommonModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/25.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,everytimeRefeshCount) {
    everytimeRefeshCount20 = 20,
    everytimeRefeshCount50 = 50,
    everytimeRefeshCount100 = 100,
};

typedef NS_ENUM(NSInteger,maxTimelineCacheCount) {
    maxTimelineCacheCount200 = 200,
    maxTimelineCacheCount350 = 350,
    maxTimelineCacheCount500 = 500,
};

typedef NS_ENUM(NSInteger,bigpicQuality) {
    bigpicQualityMiddle_720P,
    bigpicQualityOriginal_large,
    bigpicQualitySmart,
};

typedef NS_ENUM(NSInteger,bigpicPreload) {
    bigpicPreloadOn,
    bigpicPreloadOff,
    bigpicPreloadSmart,
};

typedef NS_ENUM(NSInteger,picuploadQuality) {
    picuploadQualityMiddle,
    picuploadQualityHigh,
    picuploadQualitySmart
};

typedef NS_ENUM(NSInteger,controllerTransitionType) {
    controllerTransitionTypeLeftRight,
    controllerTransitionTypeUpDown,
};

@interface ZHNCosmosConfigCommonModel : NSObject
// timeline font padding font name
@property (nonatomic,assign) NSInteger font; // 12 - 30
@property (nonatomic,assign) NSInteger padding;// 5 - 30
@property (nonatomic,strong) NSString *fontName;

// controlpad
@property (nonatomic,assign) BOOL isTimelineShowImage;
@property (nonatomic,assign) BOOL isWebReadingMode;
@property (nonatomic,assign) BOOL isOnSound;
@property (nonatomic,assign) BOOL isTimelineWideCardType;

// refresh
@property (nonatomic,assign) BOOL isHightlightShowUrl;
@property (nonatomic,assign) BOOL isNeedAutoRefreshAfterPublish;
@property (nonatomic,assign) BOOL isRefreshPositiveSequence;
@property (nonatomic,assign) everytimeRefeshCount everytimeRefeshCount;
@property (nonatomic,assign) maxTimelineCacheCount maxTimelineCacheCount;

// pic
@property (nonatomic,assign) bigpicQuality bigpicQuality;
@property (nonatomic,assign) BOOL isShowFlowCorner;
@property (nonatomic,assign) bigpicPreload bigpicPreload;
@property (nonatomic,assign) BOOL isLoadbigpicshowMask;
@property (nonatomic,assign) picuploadQuality picuploadQuality;

// visual and animate
@property (nonatomic,assign) BOOL everydayRandomThemeColor;
@property (nonatomic,assign) BOOL navigationbarFitThemeColor;
@property (nonatomic,assign) BOOL dynamicScrollNavibar;
@property (nonatomic,assign) BOOL touchViewTransfromAnimate;
@property (nonatomic,assign) controllerTransitionType transitionType;
@property (nonatomic,assign) BOOL tabbarControllerTransionAnimate;

// tapic engine
@property (nonatomic,assign) BOOL isNeedTapicEngine;
+ (void)configIfNeed;

// Config rest success notification name
+ (NSString *)zhn_resetConfigSuccessNotificationNameForPropertyName:(NSString *)propertyName;
@end
