//
//  ZHNPhotoView.m
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPhotoView.h"
#import "UIScrollView+ZHNTransitionManager.h"
#import "UIImage+YYWebimageCache.h"
#import "NSString+imageQuality.h"
#import <PhotosUI/PhotosUI.h>
#import "ZHNDownloadManager.h"
#import "PHLivePhotoView+ZHNLivePhoto.h"

@interface ZHNPhotoView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *normalImageView;
@property (nonatomic,strong) YYAnimatedImageView *gifImageView;
@property (nonatomic,strong) PHLivePhotoView *livePhotoView;
@end

@implementation ZHNPhotoView
+ (instancetype)photoViewWithImageUrlStr:(NSString *)imageUrlStr livePhotoUrlStr:(NSString *)livePhotoUrlStr placeholderImage:(UIImage *)plageHolder frame:(CGRect)frame {
    ZHNPhotoView *photoView = [[ZHNPhotoView alloc]init];
    photoView.livePhotoMovUrlStr = livePhotoUrlStr;
    photoView.imageUrlStr = imageUrlStr;
    photoView.placeHolderImage = plageHolder;
    photoView.frame = frame;
    [photoView resizeImageView];
    return photoView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.normalImageView];
    [self.scrollView addSubview:self.gifImageView];
    [self.scrollView addSubview:self.livePhotoView];
    [self addSubview:self.progressBar];
    
    self.scrollView.frame = self.bounds;
    self.progressBar.frame = CGRectMake(0, self.height - 4, self.width, 4);
}

#pragma mark - public methods
- (void)resizeImageView {
    switch (self.photoType) {
        case ZHNPhotoTypeNormal:
        {
            CGRect frame = [self zhn_getBrowserImageViewFrameWithImage:self.normalImageView.image];
            self.normalImageView.frame = frame;
            self.scrollView.contentSize = self.normalImageView.frame.size;
        }
            break;
        case ZHNPhotoTypeGIF:
        {
            CGRect frame = [self zhn_getBrowserImageViewFrameWithImage:self.gifImageView.image];
            self.gifImageView.frame = frame;
            self.scrollView.contentSize = self.gifImageView.frame.size;
        }
            break;
        case ZHNPhotoTypeLivePhoto:
        {
            CGRect frame = [self zhn_getBrowserImageViewFrameWithImage:self.normalImageView.image];
            self.normalImageView.frame = frame;
            self.livePhotoView.frame = frame;
            self.scrollView.contentSize = self.normalImageView.frame.size;
        }
            break;
    }
    
    if (self.scrollView.contentSize.height > self.frame.size.height) {
        @weakify(self);
        [self.scrollView zhn_needTransitionManagerWithDirection:ZHNScrollDirectionTop pointerMarging:15 transitonHanldle:^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ZHNPhotoViewLongImageScrollToDismiss)]) {
                [self.delegate ZHNPhotoViewLongImageScrollToDismiss];
            }
        }];
        [self.scrollView zhn_needTransitionManagerWithDirection:ZHNScrollDirectionBottom pointerMarging:15 transitonHanldle:^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ZHNPhotoViewLongImageScrollToDismiss)]) {
                [self.delegate ZHNPhotoViewLongImageScrollToDismiss];
            }
        }];
    }
}

- (CGRect)zhn_getBrowserImageViewFrameWithImage:(UIImage *)image {
    CGSize imageSize = image.size;
    CGFloat scale = imageSize.height/imageSize.width;
    CGFloat width = self.frame.size.width;
    CGFloat height = width * scale;
    CGRect frame = CGRectZero;
    if (height <= self.height) {
        CGFloat x = self.width/2 - width/2;
        CGFloat y = self.height/2 - height/2;
        frame = CGRectMake(x, y, width, height);
    }else {
        frame = CGRectMake(0, 0, width, height);
    }
    return frame;
}

- (void)loadHighQualityImageWithImageURLstr:(NSString *)imageURLStr livePhotoMovUrlStr:(NSString *)livePhotoMovUrlStr loadPolicy:(ZHNHighQualityPolicy)policy completion:(ZHNPhotoLoadCompletionHandle)completion {
    if (self.photoType == ZHNPhotoTypeLivePhoto) { // Live Photo
        self.gifImageView.hidden = YES;
        self.normalImageView.hidden = NO;
        self.livePhotoView.hidden = YES;
        
        dispatch_group_t livephotoGroup = dispatch_group_create();
        
        // 1. image
        dispatch_group_enter(livephotoGroup);
        [self.normalImageView yy_setImageWithURL:[NSURL URLWithString:[imageURLStr middle_360P]] placeholder:nil options:YYWebImageOptionIgnorePlaceHolder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (stage == YYWebImageStageFinished) {
                [self resizeImageView];
            }
            dispatch_group_leave(livephotoGroup);
        }];
        
        // 2. live photo
        @weakify(self);
        dispatch_group_enter(livephotoGroup);
        [[ZHNDownloadManager manager] zhn_downloadForURLStr:livePhotoMovUrlStr progress:^(NSInteger total, NSInteger current) {
            @strongify(self);
            CGFloat percent = (CGFloat)current/(CGFloat)total;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBar.percent = percent;
            });
            NSLog(@"%f",percent);
        } state:^(ZHNDownloadState state) {
            if (state == ZHNDownloadStateComplete) {
                dispatch_group_leave(livephotoGroup);
            }
        }];
        
        // 3. load live photo
        dispatch_group_notify(livephotoGroup, dispatch_get_main_queue(), ^{
            NSString *livePhotoPath = [[ZHNDownloadManager manager] zhn_getDownloadSourcePathForUrlStr:livePhotoMovUrlStr];
            @weakify(self);
            [self.livePhotoView zhn_setLivePhotoWithVideoURL:[NSURL fileURLWithPath:livePhotoPath] placeHolder:nil completion:^(PHLivePhoto *livePhoto) {
                @strongify(self);
                [self resizeImageView];
                self.livePhotoView.hidden = NO;
                self.normalImageView.hidden = YES;
                if (completion) {
                    completion(YES);
                }
            }];
        });
        
    }else {// Normal GIF
        UIImageView *imageView;
        switch (self.photoType) {
            case ZHNPhotoTypeNormal:
            {
                self.livePhotoView.hidden = YES;
                self.normalImageView.hidden = NO;
                self.gifImageView.hidden = YES;
                imageView = self.normalImageView;
            }
                break;
            case ZHNPhotoTypeGIF:
            {
                self.livePhotoView.hidden = YES;
                self.normalImageView.hidden = YES;
                self.gifImageView.hidden = NO;
                imageView = self.gifImageView;
            }
                break;
            default:
                break;
        }
        
        switch (policy) {
            case ZHNHighQualityPolicySetting:
            {
                imageURLStr = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:imageURLStr];
            }
                break;
            case ZHNHighQualityPolicyLarge:
            {
                imageURLStr = [imageURLStr large];
            }
                break;
        }
        
        [imageView yy_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholder:nil options:YYWebImageOptionIgnorePlaceHolder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat percent = (CGFloat)receivedSize/(CGFloat)expectedSize;
            self.progressBar.percent = percent;
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (stage == YYWebImageStageFinished) {
                [self resizeImageView];
                if (completion) {
                    BOOL isLarge = NO;
                    if ([imageURLStr isEqualToString:[imageURLStr large]]) {
                        isLarge = YES;
                    }
                    completion(isLarge);
                }
            }
        }];
    }
}

#pragma mark - delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    switch (self.photoType) {
        case ZHNPhotoTypeNormal:
        {
            return self.normalImageView;
        }
            break;
        case ZHNPhotoTypeGIF:
        {
            return self.gifImageView;
        }
            break;
        case ZHNPhotoTypeLivePhoto:
        {
            return self.livePhotoView;
        }
            break;
    }
}

// import. If not reset imageview position it will show mismatch.
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *imageView = self.photoType == ZHNPhotoTypeGIF ? self.gifImageView : self.normalImageView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - setters
- (void)setImageUrlStr:(NSString *)imageUrlStr {
    _imageUrlStr = imageUrlStr;
    self.photoType = [imageUrlStr containsString:@".gif"] ? ZHNPhotoTypeGIF : ZHNPhotoTypeNormal;
    if (self.livePhotoMovUrlStr) {
        self.photoType = ZHNPhotoTypeLivePhoto;
    }
}

- (void)setPlaceHolderImage:(UIImage *)placeHolderImage {
    _placeHolderImage = placeHolderImage;
    switch (self.photoType) {
        case ZHNPhotoTypeGIF:
        {
            self.gifImageView = [[YYAnimatedImageView alloc]initWithImage:placeHolderImage];
        }
            break;
        case ZHNPhotoTypeNormal:
        {
            self.normalImageView = [[UIImageView alloc]init];
            self.normalImageView.image = placeHolderImage;
            self.normalImageView.clipsToBounds = YES;
        }
            break;
        case ZHNPhotoTypeLivePhoto:
        {
            self.normalImageView = [[UIImageView alloc]init];
            self.normalImageView.image = placeHolderImage;
            self.normalImageView.clipsToBounds = YES;
            self.livePhotoView = [[PHLivePhotoView alloc]init];
            self.livePhotoView.hidden = YES;
        }
            break;
    }
}
#pragma mark - getters
- (UIView *)imageView {
    switch (self.photoType) {
        case ZHNPhotoTypeNormal:
            return self.normalImageView;
            break;
        case ZHNPhotoTypeGIF:
            return self.gifImageView;
            break;
        case ZHNPhotoTypeLivePhoto:
            return self.livePhotoView;
            break;
    }
}

- (UIImage *)image {
    switch (self.photoType) {
        case ZHNPhotoTypeNormal:
            return self.normalImageView.image;
            break;
        case ZHNPhotoTypeGIF:
            return self.gifImageView.image;
            break;
        case ZHNPhotoTypeLivePhoto:
            return self.normalImageView.image;
            break;
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = KMaxZoomScale;
        _scrollView.minimumZoomScale = 1;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (ZHNPhotoProgressBar *)progressBar {
    if (_progressBar == nil) {
        _progressBar = [[ZHNPhotoProgressBar alloc]init];
    }
    return _progressBar;
}
@end
