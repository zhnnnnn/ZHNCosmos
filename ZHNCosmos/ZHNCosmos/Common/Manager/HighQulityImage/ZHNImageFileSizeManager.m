//
//  ZHNImageFileSizeManager.m
//  ZHNTestWebview
//
//  Created by zhn on 2017/11/17.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNImageFileSizeManager.h"
#import "YYCache.h"
#import "UIImage+YYWebimageCache.h"

@interface ZHNImageFileSizeManager()<NSURLSessionDataDelegate,NSURLSessionDelegate>
@property (nonatomic,strong) NSOperationQueue *loadCacheQueue;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) YYCache *fileSizeCache;
@end

@implementation ZHNImageFileSizeManager
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static ZHNImageFileSizeManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNImageFileSizeManager alloc]init];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"com.zhnnnnn"];
        cachePath = [cachePath stringByAppendingPathComponent:@"imagefilesize"];
        manager.fileSizeCache = [YYCache cacheWithPath:cachePath];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        queue.maxConcurrentOperationCount = 5;
        manager.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
        manager.loadCacheQueue = [[NSOperationQueue alloc]init];
        manager.loadCacheQueue.maxConcurrentOperationCount = 6;
    });
    return manager;
}

- (ZHNOpetation *)zhn_showImagefileSizeForPicMeteData:(ZHNTimelinePicMetaData *)picMeteData InRobbionLabel:(YYLabel *)robbionLabel {
    @weakify(self);
    ZHNOpetation *zhnOperation = [[ZHNOpetation alloc]init];
    __block NSOperation *opera = [NSBlockOperation blockOperationWithBlock:^{
        @strongify(self);
        NSString *bigImageUrlStr = [UIImage policyMappingBigPicUrlStrForNormalPicUrlStr:picMeteData.picUrl];
        UIImage *bigImage = [UIImage getYYCachedImageForURLString:bigImageUrlStr];
        if (bigImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                robbionLabel.hidden = YES;
            });
        }else {
            // Get big pic image size
            id fileSize = [self.fileSizeCache objectForKey:bigImageUrlStr];
            if (fileSize) {// Cache
                long long size = [fileSize longLongValue];
                if (![opera isCancelled]) {
                    [self p_showImageSize:size InRobbionLabel:robbionLabel];
                }
            }else {// No cache
                dispatch_group_t sizeGroup = dispatch_group_create();
                __block long long sourceSize = 0;
                // 1. `Normal` `GIF`
                dispatch_group_enter(sizeGroup);
                NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:bigImageUrlStr]];
                [imageRequest setHTTPMethod:@"HEAD"];
                NSURLSessionDataTask *imageTask = [self.session dataTaskWithRequest:imageRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    // cancle
                    if (error.code == NSURLErrorCancelled) {
                        dispatch_group_leave(sizeGroup);
                        return;
                    }
                    // success
                    sourceSize += [response expectedContentLength];
                    dispatch_group_leave(sizeGroup);
                }];
                zhnOperation.imageTask = imageTask;
                [imageTask resume];

                // 2. `LivePhoto`
                if (picMeteData.picType == TimelinePicTypeLivePhoto) {
                    dispatch_group_enter(sizeGroup);
                    NSMutableURLRequest *liveMovRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:picMeteData.livePhotoMovUrl]];
                    [liveMovRequest setHTTPMethod:@"GET"];// Use HEAD can`t get correct size.
                    NSURLSessionDataTask *liveMovTask = [self.session dataTaskWithRequest:liveMovRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        // cancle
                        if (error.code == NSURLErrorCancelled) {
                            dispatch_group_leave(sizeGroup);
                            return;
                        }
                        // success
                        sourceSize += [response expectedContentLength];
                        dispatch_group_leave(sizeGroup);
                    }];

                    zhnOperation.liveMovTask = liveMovTask;
                    [liveMovTask resume];
                }

                dispatch_group_notify(sizeGroup, dispatch_get_global_queue(0, 0), ^{
                    [self p_showImageSize:sourceSize InRobbionLabel:robbionLabel];
                    [self.fileSizeCache setObject:@(sourceSize) forKey:bigImageUrlStr];
                });
            }
        }
    }];
    [self.loadCacheQueue addOperation:opera];
    zhnOperation.operation = opera;
    return zhnOperation;
}

#pragma mark - delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseCancel);
}

#pragma mark - pravite methods
- (void)p_showImageSize:(long long)imageSize InRobbionLabel:(YYLabel *)rabbionLabel {
    NSString *unit = @"KB";
    CGFloat size = (CGFloat)imageSize/1024;
    if (size > 1024) {
        size = size/1024;
        unit = @"MB";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        rabbionLabel.hidden = NO;
        rabbionLabel.text = [NSString stringWithFormat:@"%.1f%@",size,unit];
    });
}
@end

////////////////////////////////////////////////////////
@implementation ZHNOpetation
- (void)cancel {
    [self.operation cancel];
    [self.imageTask cancel];
    [self.liveMovTask cancel];
    self.operation = nil;
    self.imageTask = nil;
    self.liveMovTask = nil;
}
@end

