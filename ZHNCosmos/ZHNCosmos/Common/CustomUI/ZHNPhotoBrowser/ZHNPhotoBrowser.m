//
//  ZHNPhotoBrowser.m
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPhotoBrowser.h"
#import "ZHNPhotoView.h"
#import "ZHNPhotoProgressBar.h"
#import "UIImageView+WebCache.h"
#import "ZHNPhotoItem.h"
#import "YYWebImage.h"
#import "ZHNGooeyMenu.h"
#import "ZHNCosmosConfigManager.h"
#import "UIImage+YYWebimageCache.h"
#import "NSString+imageQuality.h"
#import "ZHNSudokuPicView.h"
#import "ZHNImageSaveToIphoneManager.h"
#import "PHLivePhotoView+ZHNLivePhoto.h"
#import "ZHNDownloadManager.h"

#define ZHNViewHeight self.view.frame.size.height
#define ZHNViewWidth self.view.frame.size.width
static CGFloat const KTransformScale = 0.95;
static CGFloat const KPhotoPadding = 20;
static CGFloat const KScrollToDismissMin = 80;
@interface ZHNPhotoBrowser()<UIScrollViewDelegate,ZHNPhotoViewDelegate>
@property (nonatomic,strong) UIVisualEffectView *blurMaskView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,assign) NSInteger showIndex;
@property (nonatomic,strong) NSArray <ZHNPhotoItem *> *photoItems;
@property (nonatomic,strong) NSMutableArray *souceFrames;
@property (nonatomic,strong) UILabel *reporterLabel;
@property (nonatomic,strong) UIButton *loadLargeBtn;
@property (nonatomic,strong) ZHNGooeyMenu *longPressGooeyMenu;
@property (nonatomic,copy) ZHNBrowserHandle dismissHandle;
@end

@implementation ZHNPhotoBrowser
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.blurMaskView.frame = self.view.bounds;
    [self.view addSubview:self.blurMaskView];
    [self.view addSubview:self.scrollView];
    // Reporter
    self.reporterLabel.frame = CGRectMake(self.view.width - 110, self.view.height - 40, 100, 40);
    [self.view addSubview:self.reporterLabel];
    [RACObserve(self, self.showIndex) subscribeNext:^(id value) {
        NSInteger index = [value integerValue];
        self.reporterLabel.text = [NSString stringWithFormat:@"%ld / %lu",(index+1),(unsigned long)self.photoItems.count];
    }];
    // Large image btn
    [self.view addSubview:self.loadLargeBtn];
    self.loadLargeBtn.center = CGPointMake(35, self.reporterLabel.center.y);
    self.loadLargeBtn.bounds = CGRectMake(0, 0, 50, 24);
    @weakify(self);
    [[self.loadLargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        ZHNPhotoView *photoView = self.photos[self.showIndex];
        ZHNPhotoItem *item = self.photoItems[self.showIndex];
        
        [photoView loadHighQualityImageWithImageURLstr:item.imageUrlStr livePhotoMovUrlStr:item.livePhotoMovURLStr loadPolicy:ZHNHighQualityPolicyLarge completion:^(BOOL isLarge) {
            if (isLarge) {
                self.loadLargeBtn.hidden = YES;
                if ([item.sourceImageView isKindOfClass:[ZHNPicItemView class]]) {
                    ZHNPicItemView *pic = (ZHNPicItemView *)item.sourceImageView;
                    pic.ribbonLabel.hidden = YES;
                }
            }
        }];
    }];
    // judge is largebtn need hidden ?
    self.loadLargeBtn.hidden = NO;
    switch ([ZHNCosmosConfigManager commonConfigModel].bigpicQuality) {
        case bigpicQualityOriginal_large:
        {
            self.loadLargeBtn.hidden = YES;
        }
            break;
        case bigpicQualitySmart:
        {
            if ([[ZHNNetworkManager shareInstance] isWIFI]) {
                self.loadLargeBtn.hidden = YES;
            }
        }
        default:
            break;
    }
    // Gestures
    [self p_addGestures];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger photoCount = self.photoItems.count;
    self.scrollView.frame = CGRectMake(0, 0, ZHNViewWidth + KPhotoPadding, ZHNViewHeight);
    self.scrollView.contentSize = CGSizeMake((ZHNViewWidth + KPhotoPadding)*photoCount, ZHNViewHeight);
    [self.photoItems enumerateObjectsUsingBlock:^(ZHNPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *placeholder = [UIImage fitPlaceholderForImageUrlStr:obj.imageUrlStr normalPlaceholder:obj.placeholder];
        CGRect frame = CGRectMake((ZHNViewWidth + KPhotoPadding)*idx, 0, ZHNViewWidth, ZHNViewHeight);
        ZHNPhotoView *photoView = [ZHNPhotoView photoViewWithImageUrlStr:obj.imageUrlStr livePhotoUrlStr:obj.livePhotoMovURLStr placeholderImage:placeholder frame:frame];
        photoView.delegate = self;
        [self.scrollView addSubview:photoView];
        [self.photos addObject:photoView];
        CGRect souceFrame = [obj.sourceImageView.superview convertRect:obj.sourceImageView.frame toView:self.view];
        [self.souceFrames addObject:@(souceFrame)];
    }];
    // Default position
    [self.scrollView setContentOffset:CGPointMake((ZHNViewWidth + KPhotoPadding)*self.showIndex, 0) animated:NO];
    [self p_loadHighQualityImageforIndex:self.showIndex];
    // Animate
    [self p_browserShowAnimate];
}

#pragma mark - public methods
+ (ZHNPhotoBrowser *)zhn_photoBrowserWithPhotoItems:(NSArray<ZHNPhotoItem *> *)photoItems currentIndex:(NSInteger)index {
    ZHNPhotoBrowser *browser = [[ZHNPhotoBrowser alloc]init];
    browser.photoItems = photoItems;
    browser.showIndex = index;
    // Model a controller. The controller under modal controller will hidden. If u want to show the bottom controller. set this two property.
    browser.modalPresentationStyle = UIModalPresentationCustom;
    browser.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    return browser;
}

- (void)showFromViewController:(UIViewController *)controller browserWillShowHandle:(ZHNBrowserHandle)showHandle browserWillDismissHandle:(ZHNBrowserHandle)dismissHandle {
    self.dismissHandle = dismissHandle;
    if (showHandle) {
        showHandle();
    }
    [controller presentViewController:self animated:NO completion:nil];
}

#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ZHNPhotoView *photoView = self.photos[self.showIndex];
    [photoView.scrollView setZoomScale:1 animated:NO];
    
    self.showIndex = (scrollView.contentOffset.x / (ZHNViewWidth + KPhotoPadding));
    [self p_loadHighQualityImageforIndex:self.showIndex];
}

- (void)ZHNPhotoViewLongImageScrollToDismiss {
    [self p_browserHideAnimate];
}

#pragma mark - target action
- (void)tapAction:(UITapGestureRecognizer *)tapGes {
    [self p_browserHideAnimate];
}

- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTapGes {
    ZHNPhotoView *photoView = self.photos[self.showIndex];
    UIScrollView *scrollView = [photoView scrollView];
    if (scrollView.zoomScale > 1) {
        [scrollView setZoomScale:1 animated:YES];
    }else {
        CGPoint touchPoint = [doubleTapGes locationInView:[photoView imageView]];
        CGRect newRect = CGRectZero;
        newRect.size.width =  scrollView.frame.size.width/KMaxZoomScale;
        newRect.size.height = scrollView.frame.size.height/KMaxZoomScale;
        newRect.origin.x = touchPoint.x - newRect.size.width * 0.5;
        newRect.origin.y = touchPoint.y - newRect.size.height * 0.5;
        [scrollView zoomToRect:newRect animated:YES];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGes {
    [self.longPressGooeyMenu showMenu];
}

- (void)panAction:(UIPanGestureRecognizer *)panGes {
    if ([[self.photos[self.showIndex] scrollView] zoomScale] > 1) {return;}
    ZHNPhotoView *photoView = self.photos[self.showIndex];
    if (photoView.imageView.height > self.view.height) {return;}
    CGPoint translate = [panGes translationInView:self.view];
    switch (panGes.state) {
        case UIGestureRecognizerStateChanged:
        {
            [self p_systemSetStatusBarHidden:NO];
            CGFloat scalePercent = fabs(translate.y)/KScrollToDismissMin;
            scalePercent = scalePercent > 1 ? 1 : scalePercent;
            //
            UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            CGFloat transScale = (1 - KTransformScale) * scalePercent + KTransformScale;
            rootView.transform = CGAffineTransformMakeScale(transScale, transScale);
            //
            photoView.transform = CGAffineTransformMakeTranslation(0, translate.y);
            photoView.progressBar.alpha = 0;
            //
            self.blurMaskView.alpha = 1 - scalePercent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            CGFloat scalePercent = fabs(translate.y)/KScrollToDismissMin;
            if (scalePercent > 1) {
                CGFloat transY = 0;
                if (translate.y > 0) { // down
                    transY = self.view.height;
                }else { // up
                    transY = -self.view.height;
                }
                CGAffineTransform photoTrans = CGAffineTransformIdentity;
                photoTrans = CGAffineTransformTranslate(photoTrans, 0, transY);
                [UIView animateWithDuration:0.3 animations:^{
                    photoView.transform = photoTrans;
                } completion:^(BOOL finished) {
                    if (self.dismissHandle) {
                        self.dismissHandle();
                    }
                    [self p_setStatusBarHidden:NO];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.blurMaskView.alpha = 1;
                    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
                    CGAffineTransform backContainerTrans = CGAffineTransformIdentity;
                    rootView.transform = CGAffineTransformScale(backContainerTrans, KTransformScale, KTransformScale);
                    photoView.transform = CGAffineTransformIdentity;
                    photoView.progressBar.alpha = 1;
                }];
            }
        }
        default:
            break;
    }
}

#pragma mark - pravite methods
- (void)p_loadHighQualityImageforIndex:(NSInteger)index {
    if (index < self.photos.count) {
        UIImageView *picItem = [self.photoItems[index] sourceImageView];
        if ([picItem isKindOfClass:[ZHNPicItemView class]]) {
            [(ZHNPicItemView *)picItem haveLoadedBigPic];
        }
    }
    
    ZHNPhotoView *photoView = self.photos[index];
    ZHNPhotoItem *item = self.photoItems[index];
    @weakify(self);
    [photoView loadHighQualityImageWithImageURLstr:item.imageUrlStr livePhotoMovUrlStr:item.livePhotoMovURLStr loadPolicy:ZHNHighQualityPolicySetting completion:^(BOOL isLarge) {
        if (isLarge) {
            @strongify(self);
            self.loadLargeBtn.hidden = YES;
        }else {
            self.loadLargeBtn.hidden = NO;
        }
    }];
}

- (void)p_addGestures {
    // Single tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    // Double tap
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
    // Longpress
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.view addGestureRecognizer:longpress];
    // Pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
}

- (void)p_browserShowAnimate {
    [self p_setStatusBarHidden:YES];
    ZHNPhotoItem *item = self.photoItems[self.showIndex];
    ZHNPhotoView *photoView = self.photos[self.showIndex];
    photoView.hidden = YES;
    //
    CGRect soureFrame = [self.souceFrames[self.showIndex] CGRectValue];
    UIImage *placeHolder = [UIImage fitPlaceholderForImageUrlStr:item.imageUrlStr normalPlaceholder:item.placeholder];
    CGRect contentframe = [photoView zhn_getBrowserImageViewFrameWithImage:placeHolder];
    //
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    //
    UIImageView *fakeImageView = [[UIImageView alloc]init];
    fakeImageView.clipsToBounds = YES;
    fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
    fakeImageView.image = placeHolder;
    fakeImageView.frame = soureFrame;
    [self.view addSubview:fakeImageView];
    [self.view bringSubviewToFront:self.reporterLabel];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fakeImageView.frame = contentframe;
        self.blurMaskView.alpha = 1;
        rootView.transform = CGAffineTransformMakeScale(KTransformScale, KTransformScale);
        self.reporterLabel.alpha = 1;
        self.loadLargeBtn.alpha = 1;
    } completion:^(BOOL finished) {
        [fakeImageView removeFromSuperview];
        photoView.hidden = NO;
    }];
}

- (void)p_browserHideAnimate {
    [self p_setStatusBarHidden:NO];
    ZHNPhotoItem *item = self.photoItems[self.showIndex];
    ZHNPhotoView *photoView = self.photos[self.showIndex];
    photoView.hidden = YES;
    //
    CGRect soureFrame = [self.souceFrames[self.showIndex] CGRectValue];
    UIImage *placeHolder = [UIImage getYYCachedImageForURLString:[item.imageUrlStr middle_360P]];
    if (!placeHolder) {
        placeHolder = photoView.image;
    }
    CGRect contentframe = [photoView zhn_getBrowserImageViewFrameWithImage:placeHolder];
    //
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    //
    UIImageView *fakeImageView = [[UIImageView alloc]init];
    fakeImageView.clipsToBounds = YES;
    fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
    fakeImageView.image = placeHolder;
    fakeImageView.frame = contentframe;
    [self.view addSubview:fakeImageView];
    [self.view bringSubviewToFront:self.reporterLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        fakeImageView.frame = soureFrame;
        self.blurMaskView.alpha = 0;
        rootView.transform = CGAffineTransformIdentity;
        self.reporterLabel.alpha = 0;
        self.loadLargeBtn.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.dismissHandle) {
            self.dismissHandle();
        }
        [fakeImageView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)p_setStatusBarHidden:(BOOL)hidden {
    if (hidden) {
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
        [self p_systemSetStatusBarHidden:hidden];
    }else {
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
        [self p_systemSetStatusBarHidden:hidden];
    }
}

- (void)p_systemSetStatusBarHidden:(BOOL)hidden {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
#pragma clang diagnostic pop
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)souceFrames {
    if (_souceFrames == nil) {
        _souceFrames = [NSMutableArray array];
    }
    return _souceFrames;
}

- (UIVisualEffectView *)blurMaskView {
    if (_blurMaskView == nil) {
        _blurMaskView = [[UIVisualEffectView alloc]init];
        _blurMaskView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurMaskView.alpha = 0;
    }
    return _blurMaskView;
}

- (UILabel *)reporterLabel {
    if (_reporterLabel == nil) {
        _reporterLabel = [[UILabel alloc]init];
        _reporterLabel.font = [UIFont systemFontOfSize:20];
        _reporterLabel.textColor = [UIColor whiteColor];
        _reporterLabel.textAlignment = NSTextAlignmentRight;
        _reporterLabel.alpha = 0;
        _reporterLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _reporterLabel.layer.shadowOpacity = 0.7;
    }
    return _reporterLabel;
}

- (UIButton *)loadLargeBtn {
    if (_loadLargeBtn == nil) {
        _loadLargeBtn = [[UIButton alloc]init];
        _loadLargeBtn.backgroundColor = [UIColor clearColor];
        [_loadLargeBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_loadLargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loadLargeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _loadLargeBtn.layer.shadowOpacity = 0.7;
        _loadLargeBtn.layer.cornerRadius = 5;
        _loadLargeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _loadLargeBtn.layer.borderWidth = 1;
    }
    return _loadLargeBtn;
}

- (ZHNGooeyMenu *)longPressGooeyMenu {
    if (_longPressGooeyMenu == nil) {
        _longPressGooeyMenu = [[ZHNGooeyMenu alloc]initWithTitleArray:@[@"分享",@"复制图片地址",@"保存图片",@"重新加载",@"取消"] itemHeight:50 menuColor:[ZHNThemeManager zhn_getThemeColor]];
        @weakify(self);
        _longPressGooeyMenu.clickHandle = ^(NSInteger index, NSString *title) {
            @strongify(self);
            switch (index) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    ZHNPhotoItem *item = self.photoItems[self.showIndex];
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    [pasteboard setString:[item.imageUrlStr large]];
                }
                    break;
                case 2:
                {
                    // Display
                    NSString *imageType;
                    switch ([self.photos[self.showIndex] photoType]) {
                        case ZHNPhotoTypeGIF:
                        {
                            imageType = @"动图";
                        }
                            break;
                        case ZHNPhotoTypeNormal:
                        {
                            imageType = @"图片";
                        }
                            break;
                        case ZHNPhotoTypeLivePhoto:
                        {
                            imageType = @"LivePhoto";
                        }
                    }
                    
                    // Action
                    ZHNPhotoItem *item = self.photoItems[self.showIndex];
                    switch ([self.photos[self.showIndex] photoType]) {
                        case ZHNPhotoTypeGIF:
                        case ZHNPhotoTypeNormal:
                        {
                            NSData *imageData = [UIImage saveToIphoneImageDataForImageURLStr:item.imageUrlStr];
                            if (!imageData) {return;}
                            [ZHNImageSaveToIphoneManager zhn_saveImageDataToIphone:imageData imageType:imageType success:nil failure:nil];
                        }
                            break;
                        case ZHNPhotoTypeLivePhoto:
                        {
                            NSString *livePhotoPath = [[ZHNDownloadManager manager] zhn_getDownloadSourcePathForUrlStr:item.livePhotoMovURLStr];
                            [PHLivePhotoView zhn_saveLivePhotoToSystemPhotoAlbumWithSourceVideoURL:[NSURL fileURLWithPath:livePhotoPath] completion:^(BOOL success) {
                                if (success) {
                                    [ZHNHudManager showSuccess:[NSString stringWithFormat:@"保存%@成功",imageType]];
                                }else {
                                    [ZHNHudManager showSuccess:[NSString stringWithFormat:@"保存%@失败",imageType]];
                                }
                            }];
                        }
                    }
                    
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _longPressGooeyMenu;
}
@end
