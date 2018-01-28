//
//  PHLivePhotoView+ZHNLivePhoto.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "PHLivePhotoView+ZHNLivePhoto.h"
#import "JPEG.h"
#import "QuickTimeMov.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation PHLivePhotoView (ZHNLivePhoto)
- (void)zhn_setLivePhotoWithVideoURL:(NSURL *)videoURL placeHolder:(UIImage *)placeHolder completion:(ZHNLivePhotoCompletionHandle)completion{
    // Cache
    NSString *cacheImagePath = [PHLivePhotoView JPGPathForURLStr:videoURL.absoluteString];
    NSString *cacheMovPath = [PHLivePhotoView MOVPathForURLStr:videoURL.absoluteString];
    if ([self p_isFileExistForPath:cacheImagePath] && [self p_isFileExistForPath:cacheMovPath]) {
        [self p_loadLivePhotoWithJPGURL:[NSURL fileURLWithPath:cacheImagePath]
                                 MOVURL:[NSURL fileURLWithPath:cacheMovPath]
                            placeholder:placeHolder
                         resourceURLStr:videoURL.absoluteString
                             completion:completion];
        return;
    }
    
    // Create livepoto
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    NSValue *time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, asset.duration.timescale)];

    [generator generateCGImagesAsynchronouslyForTimes:@[time] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (image) {
            NSString *cacheName = [PHLivePhotoView p_stringMD5:videoURL.absoluteString];
            NSData *data = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
            if (data.length) {
                [data writeToFile:[PHLivePhotoView tempJPGPathForName:cacheName] atomically:YES];
                if (error) {
                    NSLog(@"writeError: %@",error);
                }
                NSString *image = [PHLivePhotoView tempJPGPathForName:cacheName];
                NSString *mov = videoURL.path;
                
                NSString *assetIdentifier = [NSUUID UUID].UUIDString;
                
                
                @try {
                    NSError *remError = nil;
                    BOOL remRet = [[NSFileManager defaultManager] removeItemAtPath:[PHLivePhotoView JPGPathForName:cacheName] error:&remError];
                    NSError *remoError = nil;
                    BOOL remoRet = [[NSFileManager defaultManager] removeItemAtPath:[PHLivePhotoView MOVPathForName:cacheName] error:&remoError];
                    NSLog(@"remRet: %d, remError: %@; remoRet: %d, remoError: %@", remRet, remError, remoRet, remoError);
                } @catch (NSException *exception) {
                } @finally {
                }
                
                JPEG *jpeg = [[JPEG alloc] initWithPath:image];
                [jpeg write:[PHLivePhotoView JPGPathForName:cacheName] assetIdentifier:assetIdentifier];
                QuickTimeMov *quickMov = [[QuickTimeMov alloc] initWithPath:mov];
                [quickMov write:[PHLivePhotoView MOVPathForName:cacheName] assetIdentifier:assetIdentifier];
                [self p_loadLivePhotoWithJPGURL:[NSURL fileURLWithPath:[PHLivePhotoView JPGPathForName:cacheName]]
                                         MOVURL:[NSURL fileURLWithPath:[PHLivePhotoView MOVPathForName:cacheName]]
                                    placeholder:placeHolder 
                                 resourceURLStr:videoURL.absoluteString
                                     completion:completion];
            }
        }
    }];
}

- (void)play {
    [self startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

+ (NSString *)JPGPathForURLStr:(NSString *)URLStr {
    return [PHLivePhotoView JPGPathForName:[PHLivePhotoView p_stringMD5:URLStr]];
}

+ (NSString *)MOVPathForURLStr:(NSString *)URLStr {
    return [PHLivePhotoView MOVPathForName:[PHLivePhotoView p_stringMD5:URLStr]];
}

+ (void)zhn_saveLivePhotoToSystemPhotoAlbumWithSourceVideoURL:(NSURL *)videoURL completion:(void (^)(BOOL))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSString *cacheImagePath = [PHLivePhotoView JPGPathForURLStr:videoURL.absoluteString];
        NSString *cacheMovPath = [PHLivePhotoView MOVPathForURLStr:videoURL.absoluteString];
        PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        [creationRequest addResourceWithType:PHAssetResourceTypePairedVideo fileURL:[NSURL fileURLWithPath:cacheMovPath] options:options];
        [creationRequest addResourceWithType:PHAssetResourceTypePhoto fileURL:[NSURL fileURLWithPath:cacheImagePath] options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        completion(success);
    }];
}

#pragma mark - pravite methods
- (void)p_loadLivePhotoWithJPGURL:(NSURL *)JPGURL MOVURL:(NSURL *)MOVURL placeholder:(UIImage *)placeholder resourceURLStr:(NSString *)resourceURLStr completion:(ZHNLivePhotoCompletionHandle)completion{
    NSArray *urlArray = @[MOVURL,JPGURL];
    [PHLivePhoto requestLivePhotoWithResourceFileURLs:urlArray placeholderImage:placeholder targetSize:CGSizeZero contentMode:PHImageContentModeAspectFit resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
        [self removeTempJPGForName:[PHLivePhotoView p_stringMD5:resourceURLStr]];
        if (info[PHLivePhotoInfoCancelledKey] != nil) {
            if (completion) {
                completion(livePhoto);
            }
        }
        self.livePhoto = livePhoto;
        [self play];
    }];
}


+ (NSString *)p_stringMD5:(NSString *)string {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)filePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"ZHNLivePhotoCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"filePath: %@",filePath);
    return filePath;
}

+ (NSString *)JPGPathForName:(NSString *)name {
    return [[PHLivePhotoView filePath] stringByAppendingString:[NSString stringWithFormat:@"/%@.JPG",name]];
}

+ (NSString *)MOVPathForName:(NSString *)name {
    return [[PHLivePhotoView filePath] stringByAppendingString:[NSString stringWithFormat:@"/%@.MOV",name]];
}

+ (NSString *)tempJPGPathForName:(NSString *)name {
    NSString *tempJPGPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    tempJPGPath = [tempJPGPath stringByAppendingPathComponent:@"ZHNLivePhotoTempJPGCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempJPGPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:tempJPGPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [tempJPGPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.jpg",name]];
}

- (void)removeTempJPGForName:(NSString *)name {
    [[NSFileManager defaultManager] removeItemAtPath:[PHLivePhotoView tempJPGPathForName:name] error:nil];
}

- (BOOL)p_isFileExistForPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
