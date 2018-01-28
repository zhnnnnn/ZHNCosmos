//
//  ZHNSudokuPicView.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNTimelineLayoutModel.h"
#import "ZHNRibbonLabel.h"

@interface ZHNSudokuPicView : UIView
+ (CGFloat)sudokuPicViewHeightForPicsCount:(NSInteger)count;
+ (CGFloat)picViewSizeForArrayCount:(NSInteger)count Isheight:(BOOL)isHeight;
+ (NSInteger)lineofSudokuPicViewForArrayCount:(NSInteger)count;
@property (nonatomic,strong) ZHNTimelineLayoutModel *layout;
@end

////////////////////////////////////////////////////////
@interface ZHNPicItemView : UIImageView
@property (nonatomic,strong) ZHNTimelinePicMetaData *picMeteData;
@property (nonatomic,strong) ZHNRibbonLabel *ribbonLabel;
@property (nonatomic,strong) YYLabel *imageTypeLabel;
- (void)haveLoadedBigPic;
@end


