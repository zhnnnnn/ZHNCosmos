//
//  YYLabel+highQualityImagefileSize.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "YYLabel+highQualityImagefileSize.h"
#import <objc/runtime.h>

@interface YYLabel()
@property (nonatomic,strong) ZHNOpetation *loadOperation;
@end

@implementation YYLabel (highQualityImagefileSize)
- (void)zhn_showHightQualityImageSizeForMeteData:(ZHNTimelinePicMetaData *)picMeteData {
    [self.loadOperation cancel];
    self.loadOperation = [[ZHNImageFileSizeManager shareManager] zhn_showImagefileSizeForPicMeteData:picMeteData InRobbionLabel:self];
}

#pragma mark -
- (NSOperation *)loadOperation {
    return objc_getAssociatedObject(self, @selector(loadOperation));
}

- (void)setLoadOperation:(NSOperation *)loadOperation {
    objc_setAssociatedObject(self, @selector(loadOperation), loadOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
