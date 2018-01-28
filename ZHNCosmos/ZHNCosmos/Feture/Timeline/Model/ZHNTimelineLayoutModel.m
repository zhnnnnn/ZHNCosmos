//
//  ZHNTimelineLayoutModel.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNTimelineLayoutModel.h"
#import "ZHNStatusHelper.h"
#import "ZHNSudokuPicView.h"
#import "ZHNStatusVideoView.h"
#import "ZHNFrameManager.h"
#import "ZHNHomeTimelineLayoutCacheModel.h"

@interface ZHNTimelineLayoutModel()
@property (nonatomic,assign) ZHNTimelineLayoutType layoutType;
@end

@implementation ZHNTimelineLayoutModel
+ (NSString *)getPrimaryKey {
    return @"statusID";
}

+ (CGFloat)richTextMaxWidth {
    return KCellContentWidth;
}

+ (instancetype)zhn_layoutWithStatusModel:(ZHNTimelineStatus *)status layoutType:(ZHNTimelineLayoutType)layoutType{
    ZHNTimelineLayoutModel *statusLayout = [[ZHNTimelineLayoutModel alloc]init];
    statusLayout.status = status;
    statusLayout.layoutType = layoutType;
    [statusLayout layout];    
    return statusLayout;
}

- (void)layout {
    // Set PrimaryKey
    self.statusID = self.status.statusID;
    // Reweet status can`t send `video` `pics`.
    [self p_layoutHead];
    [self p_layoutTextIsReweet:NO];
    BOOL isReweet = self.status.retweetedStatus ? YES : NO;
    if (isReweet) {
        [self p_layoutTextIsReweet:YES];
    }
    [self p_layoutSudokuPicsIsReweet:isReweet];
    [self p_layoutVideoPartIsReweet:isReweet];
    if (isReweet) {
        [self p_layoutToolBarIsReweet:YES];
    }
    if (isReweet) {
        [self p_layoutReweetBackViewIfNeed];
    }
    [self p_layoutToolBarIsReweet:NO];
    [self p_layoutCardContainerView];
}

- (void)p_layoutHead {    
    self.AvatarF = CGRectMake(KContentPadding, KContentPadding, KHeadIconSize, KHeadIconSize);
    
    CGFloat nameX = ZHNFloat(self.AvatarF, ZHNFrame_right) + KHeadImagePadding;
    CGFloat nameY = ZHNFloat(self.AvatarF, ZHNFrame_top);
    CGFloat nameH = [ZHNStatusHelper oneLineTextHeightWithFont:KHeadNameFont];
    self.nameF = CGRectMake(nameX, nameY, KNameMaxWidth, nameH);
    
    CGFloat dsX = ZHNFloat(self.nameF, ZHNFrame_left);
    CGFloat dsY = ZHNFloat(self.nameF, ZHNFrame_bottom) + KNameDatePadding;
    CGFloat dsH = [ZHNStatusHelper oneLineTextHeightWithFont:KHeadDateFont];
    self.dateSourceF = CGRectMake(dsX, dsY, KNameMaxWidth, dsH);
    
    CGFloat proX = 0;
    CGFloat proY = 0;
    CGFloat proW = KCellContentWidth;
    CGFloat proH = ZHNFloat(self.AvatarF, ZHNFrame_bottom) + KConnectPadding;
    self.profileF = CGRectMake(proX, proY, proW, proH);
}

- (void) p_layoutTextIsReweet:(BOOL)isReweet{
    NSAttributedString *richText = isReweet ? [NSAttributedString yy_unarchiveFromData:self.status.retweetedStatus.richTextData] : [NSAttributedString yy_unarchiveFromData:self.status.richTextData];
    CGFloat x = KContentPadding;
    CGFloat w = KCellContentWidth;
    CGFloat h = [ZHNStatusHelper heightForAttributeText:richText maxWidth:w];
    if (isReweet) {
        CGFloat y = ZHNFloat(self.textF, ZHNFrame_bottom) + 2 * KConnectPadding;
        self.reweetTextF = CGRectMake(x, y, w, h);
        self.rowHeight  = ZHNFloat(self.reweetTextF, ZHNFrame_bottom);
    }else {
        CGFloat y = ZHNFloat(self.profileF, ZHNFrame_bottom);
        self.textF = CGRectMake(x, y, w, h);
        self.rowHeight = ZHNFloat(self.textF, ZHNFrame_bottom);
    }
}

- (void)p_layoutSudokuPicsIsReweet:(BOOL)isReweet {
    ZHNTimelineStatus *status = isReweet ? self.status.retweetedStatus : self.status;
    CGFloat height = [ZHNSudokuPicView sudokuPicViewHeightForPicsCount:status.picUrlStrings.count];
    if (height == 0) {
        self.sudokuPicsF = CGRectZero;
        self.picItemFArray = nil;
    }else {
        CGRect rect = isReweet ? self.reweetTextF : self.textF;
        // frame
        CGFloat y = ZHNFloat(rect, ZHNFrame_bottom) + KConnectPadding;
        CGFloat x = ZHNFloat(rect, ZHNFrame_left);
        self.sudokuPicsF = CGRectMake(x, y, KCellContentWidth, height);
        self.rowHeight = CGRectGetMaxY(self.sudokuPicsF);
        // item frame
        NSMutableArray *itemFrameArray = [NSMutableArray array];
        NSInteger dataCount = status.picMetaDatas.count;
        CGFloat w = [ZHNSudokuPicView picViewSizeForArrayCount:dataCount Isheight:NO];
        CGFloat h = [ZHNSudokuPicView picViewSizeForArrayCount:dataCount Isheight:YES];
        [status.picMetaDatas enumerateObjectsUsingBlock:^(ZHNTimelinePicMetaData *meteData, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect itemFrame = CGRectZero;
            if (dataCount == 1) {
                itemFrame = CGRectMake(0, 0, w, h);
            }else if (dataCount == 2){
                itemFrame = CGRectMake((KPicPadding + w) * idx, 0, w, h);
            }else {
                NSInteger row = idx/3;
                NSInteger col = idx%3;
                itemFrame = CGRectMake(col * (KPicPadding + w), row * (KPicPadding + h), w, h);
            }
            [itemFrameArray addObject:@(itemFrame)];
        }];
        self.picItemFArray  = [itemFrameArray copy];
    }
}

- (void)p_layoutVideoPartIsReweet:(BOOL)isReweet {
    self.videoCardF = CGRectZero;
    ZHNTimelineStatus *status = isReweet ? self.status.retweetedStatus : self.status;
    BOOL isHaveVideo = status.isHaveVideo ? YES : NO;
    if (isHaveVideo && status.picUrlStrings.count == 0) {// Show pics first
        CGRect rect = isReweet ? self.reweetTextF : self.textF;
        // frame
        CGFloat y = ZHNFloat(rect, ZHNFrame_bottom) + KConnectPadding;
        CGFloat x = ZHNFloat(rect, ZHNFrame_left);
        CGFloat height = [ZHNStatusVideoView videoCardHeight];
        self.videoCardF = CGRectMake(x, y, KCellContentWidth, height);
        self.rowHeight = CGRectGetMaxY(self.videoCardF);
    }
}

- (void)p_layoutReweetBackViewIfNeed {
    CGFloat x = KCardContainerPadding;
    CGFloat y = ZHNFloat(self.textF, ZHNFrame_bottom) + KConnectPadding;
    CGFloat w = K_SCREEN_WIDTH - 2 * KCardContainerPadding;
    CGFloat h = self.rowHeight - y;
    self.reweetBackViewF = CGRectMake(x, y, w, h);
}

- (void)p_layoutToolBarIsReweet:(BOOL)isReweet {
    if (self.layoutType == ZHNTimelineLayoutTypeDetail) {return;}
    if (isReweet) {
        CGFloat x = K_SCREEN_WIDTH/2;
        CGFloat y = self.rowHeight;
        CGFloat w = KCellContentWidth/2;
        CGFloat h = 40;
        self.reweetToolBarF = CGRectMake(x, y, w, h);
        self.rowHeight += h;
    }else {
        CGFloat x = ZHNFloat(self.textF, ZHNFrame_left);
        CGFloat y = self.rowHeight;
        CGFloat w = KCellContentWidth;
        CGFloat h = 50;
        self.rowHeight += h + KConnectPadding;
        self.toolBarF = CGRectMake(x, y, w, h);
    }
}

- (void)p_layoutCardContainerView {
    if (self.layoutType == ZHNTimelineLayoutTypeDetail) {return;}
    self.cardContainerF = CGRectMake(KCardContainerPadding, KCardContainerPadding, K_SCREEN_WIDTH - 2*KCardContainerPadding, ZHNFloat(self.toolBarF, ZHNFrame_bottom) - KCardContainerPadding);
    
}
@end
