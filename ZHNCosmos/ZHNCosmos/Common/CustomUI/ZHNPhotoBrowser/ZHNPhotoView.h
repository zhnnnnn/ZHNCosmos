//
//  ZHNPhotoView.h
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNPhotoProgressBar.h"

@protocol ZHNPhotoViewDelegate <NSObject>
@optional
- (void)ZHNPhotoViewLongImageScrollToDismiss;
@end

typedef NS_ENUM(NSInteger,ZHNPhotoType) {
    ZHNPhotoTypeNormal,
    ZHNPhotoTypeGIF,
    ZHNPhotoTypeLivePhoto
};

typedef NS_ENUM(NSInteger,ZHNHighQualityPolicy) {
    ZHNHighQualityPolicySetting,// Policy setting in config
    ZHNHighQualityPolicyLarge// Policy load largest image
};

typedef void(^ZHNPhotoLoadCompletionHandle)(BOOL isLarge);
static CGFloat const KMaxZoomScale = 3;
@interface ZHNPhotoView : UIView
@property (nonatomic,strong) ZHNPhotoProgressBar *progressBar;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImage *placeHolderImage;
@property (nonatomic,assign) ZHNPhotoType photoType;
@property (nonatomic,copy) NSString *imageUrlStr;
@property (nonatomic,copy) NSString *livePhotoMovUrlStr;
@property (nonatomic,weak) id <ZHNPhotoViewDelegate> delegate;


+ (instancetype)photoViewWithImageUrlStr:(NSString *)imageUrlStr
                         livePhotoUrlStr:(NSString *)livePhotoUrlStr
                        placeholderImage:(UIImage *)plageHolder
                                   frame:(CGRect)frame;

/**
 Load hight quality image or LivePhoto.

 @param imageURLStr image url string. (If image is livephoto this url is also need to set, as a placeholder, because load livephoto need a some time.)
 @param livePhotoMovUrlStr livePhoto mov url string.
 @param policy setting policy
 @param completion completion handle
 */
- (void)loadHighQualityImageWithImageURLstr:(NSString *)imageURLStr
                         livePhotoMovUrlStr:(NSString *)livePhotoMovUrlStr
                                 loadPolicy:(ZHNHighQualityPolicy)policy
                                 completion:(ZHNPhotoLoadCompletionHandle)completion;

/**
 Resize imageView
 */
- (void)resizeImageView;

/**
 Get image fit size

 @param image image
 @return fit frame
 */
- (CGRect)zhn_getBrowserImageViewFrameWithImage:(UIImage *)image;
@end
