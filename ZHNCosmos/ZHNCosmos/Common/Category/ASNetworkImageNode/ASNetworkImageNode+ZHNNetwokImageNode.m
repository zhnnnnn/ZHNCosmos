//
//  ASNetworkImageNode+ZHNNetwokImageNode.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/15.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ASNetworkImageNode+ZHNNetwokImageNode.h"
#import "YYWebImage.h"
#import <objc/runtime.h>

@implementation ASNetworkImageNode (ZHNNetwokImageNode)
+ (instancetype)imageNode {
    ZHNForASNetImageNodeWebImageManager *manager = [ZHNForASNetImageNodeWebImageManager sharedManager];
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc]initWithCache:manager downloader:manager];
    imageNode.imageManager = manager;
    return imageNode;
}

- (ZHNForASNetImageNodeWebImageManager *)imageManager {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setImageManager:(ZHNForASNetImageNodeWebImageManager *)imageManager {
    objc_setAssociatedObject(self, @selector(imageManager), imageManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

/////////////////////////////////////////////////////
@implementation ZHNForASNetImageNodeWebImageManager
- (id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgress:(ASImageDownloaderProgress)downloadProgress completion:(ASImageDownloaderCompletion)completion {
    YYWebImageOperation *operation;
    @weakify(operation);
    [self requestImageWithURL:URL options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(callbackQueue, ^{
            CGFloat progress = expectedSize == 0 ? 0 : receivedSize/expectedSize;
            downloadProgress(progress);
        });
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(operation);
        completion(image,error,operation);
    }];
    return operation;
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    if ([downloadIdentifier isKindOfClass:[YYWebImageOperation class]]) {
        [(YYWebImageOperation *)downloadIdentifier cancel];
    }
}

- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion {
    NSString *cacheKey = [self cacheKeyForURL:URL];
    UIImage *image = [self.cache getImageForKey:cacheKey];
    dispatch_async(callbackQueue, ^{
        completion(image);
    });
}
@end
