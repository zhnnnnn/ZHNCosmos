//
//  UIImageView+ZHNWebimage.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/16.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIImageView+ZHNWebimage.h"
#import "ZHNTimelineModel.h"
#import <objc/runtime.h>
#import "NSString+imageQuality.h"
#import "ZHNPicDataAsyncLoadManager.h"

@interface UIImageView()
@property (nonatomic,strong) NSURLSessionDataTask *videoImageTask;
@end

@implementation UIImageView (ZHNWebimage)
- (void)zhn_setImageWithVideoShortUrl:(NSString *)shortUrl placeholder:(NSString *)placeholder complete:(ZHNVideoMeteDataHanlde)complete{
    if (!shortUrl) {return;}
    // Like SDWebimage need to cancle task at first. To prevent image set in confusion.
    if (self.videoImageTask) {
        [self.videoImageTask cancel];
    }
    // get cache
    ZHNVideoMeteData *videMeteData = [ZHNTimelineURL zhn_searchVideoMetaDataForShortURLStr:shortUrl];
    
    if (videMeteData) {// have cache
        if (complete) {
            complete(videMeteData.videoSize,videMeteData.videDuration);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self yy_setImageWithURL:[NSURL URLWithString:videMeteData.imageUrl] placeholder:[UIImage imageNamed:placeholder] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        });
    }else {// no cache
        // Set placholder first.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageNamed:placeholder];
        });
        // Get image url
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params zhn_safeSetObjetct:@"2.00KpVmsGfj3PXC49e06d9a040uAPRD" forKey:@"access_token"];
        [params zhn_safeSetObjetct:shortUrl forKey:@"url_short"];
        [params zhn_safeSetObjetct:@"1" forKey:@"url_ssig"];
        
        self.videoImageTask = [ZHNNETWROK get:@"https://api.weibo.com/2/short_url/info.json" params:params responseType:ZHNResponseTypeJSON success:^(id result, NSURLSessionDataTask *task) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                if ([result[@"urls"] isKindOfClass:[NSArray class]]) {// Ordinary need to do more judge to confirm it won`t crash.
                    id videos = [result[@"urls"] firstObject];
                    if (![videos isKindOfClass:[NSDictionary class]]) {return;}
                    NSDictionary *video = [videos[@"annotations"] firstObject];
                    ZHNVideoMeteData *videoData = [[ZHNVideoMeteData alloc]init];
                    videoData.shortUrl = shortUrl;
                    videoData.videoUrl = [[[video zhn_SJMapKey:@"object"] zhn_SJMapKey:@"stream"] zhn_SJMapKey:@"url"];
                    videoData.imageUrl = [[[video zhn_SJMapKey:@"object"] zhn_SJMapKey:@"image"] zhn_SJMapKey:@"url"];
                    videoData.videDuration = [[[[video zhn_SJMapKey:@"object"] zhn_SJMapKey:@"stream"] zhn_SJMapKey:@"duration"] intValue];
                    videoData.videoSize = [[[[video zhn_SJMapKey:@"object"] zhn_SJMapKey:@"video_details"][0] zhn_SJMapKey:@"size"] longLongValue];
                    [videoData saveToDB];
                    
                    if (complete) {
                        complete(videoData.videoSize,videoData.videDuration);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self yy_setImageWithURL:[NSURL URLWithString:videoData.imageUrl] placeholder:[UIImage imageNamed:placeholder] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
                    });
                }
            }
        } failure:^(NSError *error,NSURLSessionDataTask *task) {
        }];
    }
}

- (void)zhn_setImageWithPicMeteData:(ZHNTimelinePicMetaData *)picMeteData placeholderStr:(NSString *)placeHolderStr complete:(ZHNImageLoaderHandle)complete {
    if (!picMeteData) {return;}
    [self.layer yy_setImageWithURL:[NSURL URLWithString:[picMeteData.picUrl middle_360P]] placeholder:[UIImage imageNamed:placeHolderStr] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (complete) {
                switch (picMeteData.picType) {
                    case TimelinePicTypeNormal:
                    {
                        CGFloat scale = image.size.height / image.size.width;
                        if (scale > 3) {
                            picMeteData.picType = TimelinePicTypeLong;
                        }
                    }
                        break;
                    default:
                        break;
                }
                complete(picMeteData.picType);
            }
        });
    }];
}

#pragma mark -
- (void)setVideoImageTask:(NSURLSessionDataTask *)videoImageTask {
    objc_setAssociatedObject(self, @selector(videoImageTask), videoImageTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURLSessionDataTask *)videoImageTask {
    return objc_getAssociatedObject(self, @selector(videoImageTask));
}

- (void)setCacheOperation:(NSBlockOperation *)cacheOperation {
    objc_setAssociatedObject(self, @selector(cacheOperation), cacheOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSBlockOperation *)cacheOperation {
    return objc_getAssociatedObject(self, _cmd);
}
@end

////////////////////////////////////////////////////////
@implementation ZHNAsyncVideoLoader
+ (instancetype)shareLoader {
    static ZHNAsyncVideoLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[ZHNAsyncVideoLoader alloc]init];
    });
    return loader;
}

- (NSOperationQueue *)videoQueue {
    if (_videoQueue == nil) {
        _videoQueue = [[NSOperationQueue alloc]init];
        _videoQueue.name = @"zhn.cosmos.video.loader";
        _videoQueue.maxConcurrentOperationCount = 4;
    }
    return _videoQueue;
}
@end
