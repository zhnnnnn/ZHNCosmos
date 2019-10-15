//
//  YYLabel+highQualityImagefileSize.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <YYText/YYText.h>
#import "ZHNImageFileSizeManager.h"
#import "ZHNTimelineModel.h"

@interface YYLabel (highQualityImagefileSize)
- (void)zhn_showHightQualityImageSizeForMeteData:(ZHNTimelinePicMetaData *)picMeteData;
@end
