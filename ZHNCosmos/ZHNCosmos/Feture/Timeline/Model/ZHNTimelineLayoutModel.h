//
//  ZHNTimelineLayoutModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNTimelineModel.h"

typedef NS_ENUM(NSInteger,ZHNTimelineLayoutType) {
    ZHNTimelineLayoutTypeNormal,
    ZHNTimelineLayoutTypeDetail
};

static CGFloat const KCardContainerPadding = 10;
static CGFloat const KContentPadding = 20;
static CGFloat const KHeadNameFont = 17;
static CGFloat const KHeadDateFont = 14;
static CGFloat const KHeadIconSize = 40;
static CGFloat const KHeadImagePadding = 15;
static CGFloat const KIconNamePadding = 10;
static CGFloat const KNameDatePadding = 5;
static CGFloat const KConnectPadding = 10;
static CGFloat const KPicPadding = 6;
#define KCellContentWidth (K_SCREEN_WIDTH - 2 * KContentPadding)
#define KNameMaxWidth (K_SCREEN_WIDTH - 110)

@interface ZHNTimelineLayoutModel : ZHNArchivedDataRootObject
+ (CGFloat)richTextMaxWidth;
+ (instancetype)zhn_layoutWithStatusModel:(ZHNTimelineStatus *)status layoutType:(ZHNTimelineLayoutType)layoutType;
@property (nonatomic,strong) ZHNTimelineStatus *status;
// -- Caluated frame
// primary Key
@property (nonatomic,assign) unsigned long long statusID;
// cell row height
@property (nonatomic,assign) CGFloat rowHeight;
// card
@property (nonatomic,assign) CGRect cardContainerF;
// profile
@property (nonatomic,assign) CGRect profileF;
@property (nonatomic,assign) CGRect AvatarF;
@property (nonatomic,assign) CGRect nameF;
@property (nonatomic,assign) CGRect dateSourceF;
// text
@property (nonatomic,assign) CGRect textF;
// reweet text
@property (nonatomic,assign) CGRect reweetTextF;
// reweet back view
@property (nonatomic,assign) CGRect reweetBackViewF;
// toolbar
@property (nonatomic,assign) CGRect toolBarF;
// reweet toobar
@property (nonatomic,assign) CGRect reweetToolBarF;
// pics
@property (nonatomic,assign) CGRect sudokuPicsF;
@property (nonatomic,strong) NSArray *picItemFArray;
// video
@property (nonatomic,assign) CGRect videoCardF;
@end
