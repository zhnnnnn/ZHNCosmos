//
//  ZHNSudokuPicView.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSudokuPicView.h"
#import "ZHNTimelineLayoutModel.h"
#import "UIImageView+ZHNWebimage.h"
#import "YYLabel+highQualityImagefileSize.h"
#import "NSString+imageQuality.h"
#import "ZHNCosmosConfigManager.h"
#import "UIImage+YYWebimageCache.h"
#import "UIImage+YYWebimageCache.h"
#import "ZHNPreloadHighQualityPicManager.h"
#import "ZHNPicDataAsyncLoadManager.h"

@interface ZHNSudokuPicView ()
@property (nonatomic,strong) NSMutableArray *picItemsArray;
@end

@implementation ZHNSudokuPicView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int index = 0; index < 9; index++) {
            ZHNPicItemView *picItem = [[ZHNPicItemView alloc]init];
            [self.picItemsArray addObject:picItem];
            [self addSubview:picItem];
            picItem.tag = index;
            // tap
            @weakify(self);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) {
                @strongify(self);
                NSInteger idnex = [tap view].tag;
                ZHNTimelineStatus *status = self.layout.status.retweetedStatus ? self.layout.status.retweetedStatus : self.layout.status;
                [self zhn_routerEventWithName:KCellTapPicAction
                                     userInfo:@{KCellTapPicIndexKey:@(idnex),
                                                KCellTapPicPhotosKey:self.picItemsArray,
                                                KCellTapPicMeteDatas:status.picMetaDatas}];
            }];
            [picItem addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)setLayout:(ZHNTimelineLayoutModel *)layout {
    _layout = layout;
    self.frame = layout.sudokuPicsF;
    ZHNTimelineStatus *status = self.layout.status.retweetedStatus ? self.layout.status.retweetedStatus : self.layout.status;
    [self.picItemsArray enumerateObjectsUsingBlock:^(ZHNPicItemView *itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < status.picMetaDatas.count) {
            itemView.hidden = NO;
            itemView.frame = [self.layout.picItemFArray[idx] CGRectValue];
            [itemView.ribbonLabel intitallizeRibbonWithSuperViewFrame:itemView.frame rabbionHeight:10 rabbionCornerPadding:15];
            itemView.picMeteData = status.picMetaDatas[idx];
        }else {
            itemView.hidden = YES;
        }
    }];
}

#pragma mark - public methods
+ (CGFloat)sudokuPicViewHeightForPicsCount:(NSInteger)count {
    if (count <= 0) {return 0;}
    CGFloat height = [self picViewSizeForArrayCount:count Isheight:YES];
    CGFloat line = [self lineofSudokuPicViewForArrayCount:count];
    CGFloat viewHight = (height * line) + (line - 1) * KPicPadding;
    return viewHight;
}

#pragma mark - pravite methods
+ (CGFloat)picViewSizeForArrayCount:(NSInteger)count Isheight:(BOOL)isHeight{
    CGFloat picViewW = 0;
    CGFloat picViewH = 0;
    if (count == 1) {
        picViewW = 0.7 * KCellContentWidth;
        picViewH = 0.5 * KCellContentWidth;
    }else if (count == 2){
        picViewH = picViewW = (KCellContentWidth - KPicPadding)/2;
    }else if(count > 2) {
        picViewH = picViewW = (KCellContentWidth - 2 * KPicPadding)/3;
    }
    if (isHeight) {
        return picViewH;
    }else {
        return picViewW;
    }
}

+ (NSInteger)lineofSudokuPicViewForArrayCount:(NSInteger)count {
    if (count <= 3) {
        return 1;
    }else if (count <= 6) {
        return 2;
    }else {
        return 3;
    }
}

#pragma mark - getters
- (NSMutableArray *)picItemsArray {
    if (_picItemsArray == nil) {
        _picItemsArray = [NSMutableArray array];
    }
    return _picItemsArray;
}

@end

////////////////////////////////////////////////////////
@interface ZHNPicItemView()
@property (nonatomic,strong) UIImageView *forPreloadImageView;
@end

@implementation ZHNPicItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.ribbonLabel];
        [self addSubview:self.imageTypeLabel];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        
        // Dont display just for preload big pic
        [self addSubview:self.forPreloadImageView];
    }
    return self;
}

- (void)haveLoadedBigPic {
    if ([self isKindOfClass:[ZHNPicItemView class]]) {
        self.ribbonLabel.hidden = YES;
    }
}

- (void)setPicMeteData:(ZHNTimelinePicMetaData *)picMeteData {
    _picMeteData = picMeteData;
    
    // Image type tag
    self.imageTypeLabel.hidden = YES;
    [self zhn_setImageWithPicMeteData:picMeteData placeholderStr:@"placeholder_image" complete:^(TimelinePicType picType) {
        BOOL isHiddenImageTypeLabel = YES;
        NSString *imageTypeStr;
        switch (picType) {
            case TimelinePicTypeNormal:
            {
                isHiddenImageTypeLabel = YES;
            }
                break;
            case TimelinePicTypeLong:
            {
                imageTypeStr = @"长图";
                isHiddenImageTypeLabel = NO;
            }
                break;
            case TimelinePicTypeGif:
            {
                imageTypeStr = @"GIF";
                isHiddenImageTypeLabel = NO;
            }
                break;
            case TimelinePicTypeLivePhoto:
            {
                imageTypeStr = @"Live";
                isHiddenImageTypeLabel = NO;
            }
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageTypeLabel.text = imageTypeStr;
            self.imageTypeLabel.hidden = isHiddenImageTypeLabel;
        });
    }];

    [[ZHNPicDataAsyncLoadManager shareManager].picloadQueue addOperationWithBlock:^{
        // Ribbor Show Policy
        ZHNCosmosConfigCommonModel *common = [ZHNCosmosConfigManager commonConfigModel];
        if (common.isShowFlowCorner && ![[ZHNNetworkManager shareInstance] isWIFI]) {
            [self.ribbonLabel zhn_showHightQualityImageSizeForMeteData:picMeteData];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ribbonLabel.hidden = YES;
            });
        }
        
        // Big pic preload
        NSString *bigPicUrlString = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:picMeteData.picUrl];
        switch (common.bigpicPreload) {
            case bigpicPreloadOn:
            {
                [self.forPreloadImageView yy_setImageWithURL:[NSURL URLWithString:bigPicUrlString] options:YYWebImageOptionIgnoreDiskCache];
            }
                break;
            case bigpicPreloadSmart:
            {
                if ([[ZHNNetworkManager shareInstance] isWIFI]) {
                    [self.forPreloadImageView yy_setImageWithURL:[NSURL URLWithString:bigPicUrlString] options:YYWebImageOptionIgnoreDiskCache];
                }
            }
                break;
            default:
                break;
        }
    }];
    
//    Big pic preload  lagggggg
//    [[ZHNPreloadHighQualityPicManager manager] preloadHighQualityPicForImageURLStr:picMeteData.picUrl];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat x = 7;
    CGFloat w = 22;
    CGFloat h = 12;
    CGFloat y = frame.size.height - x - h;
    self.imageTypeLabel.frame = CGRectMake(x, y, w, h);
}

- (ZHNRibbonLabel *)ribbonLabel {
    if (_ribbonLabel == nil) {
        _ribbonLabel = [[ZHNRibbonLabel alloc]init];
        _ribbonLabel.font = [UIFont systemFontOfSize:7];
        _ribbonLabel.displaysAsynchronously = YES;
        _ribbonLabel.textColor = [UIColor whiteColor];
        _ribbonLabel.isCustomThemeColor = YES;
        _ribbonLabel.textAlignment = NSTextAlignmentCenter;
        _ribbonLabel.hidden = YES;
    }
    return _ribbonLabel;
}

- (YYLabel *)imageTypeLabel {
    if (_imageTypeLabel == nil) {
        _imageTypeLabel = [[YYLabel alloc]init];
        _imageTypeLabel.font = [UIFont systemFontOfSize:8];
        _imageTypeLabel.layer.cornerRadius = 3;
        _imageTypeLabel.layer.masksToBounds = YES;
        _imageTypeLabel.textColor = [UIColor whiteColor];
        _imageTypeLabel.isCustomThemeColor = YES;
        _imageTypeLabel.textAlignment = NSTextAlignmentCenter;
        _imageTypeLabel.displaysAsynchronously = YES;
        _imageTypeLabel.hidden = YES;
    }
    return _imageTypeLabel;
}

- (UIImageView *)forPreloadImageView {
    if (_forPreloadImageView == nil) {
        _forPreloadImageView = [[UIImageView alloc]init];
        _forPreloadImageView.hidden = YES;
    }
    return _forPreloadImageView;
}
@end
