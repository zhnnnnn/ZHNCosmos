//
//  PHLivePhotoView+ZHNLivePhoto.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

// methods reference from https://github.com/genadyo/LivePhotoDemo

#import <PhotosUI/PhotosUI.h>
typedef void (^ZHNLivePhotoCompletionHandle)(PHLivePhoto *livePhoto);
@interface PHLivePhotoView (ZHNLivePhoto)

/**
 Show livePhoto view (videoURL is local file URL)

 @param videoURL video local URL
 @param placeHolder placeholder image
 @param completion completion handle
 */
- (void)zhn_setLivePhotoWithVideoURL:(NSURL *)videoURL
                         placeHolder:(UIImage *)placeHolder
                          completion:(ZHNLivePhotoCompletionHandle)completion;

/**
 Save live photo to system photo album. Need call `- (void)zhn_setLivePhotoWithVideoURL:(NSURL *)videoURL placeHolder:(UIImage *)placeHolder completion:(ZHNLivePhotoCompletionHandle)completion;` first.

 @param videoURL video source local file URL
 @param completion completion handle
 */
+ (void)zhn_saveLivePhotoToSystemPhotoAlbumWithSourceVideoURL:(NSURL *)videoURL
                                                   completion:(void(^)(BOOL success))completion;


- (void)play;
+ (NSString *)JPGPathForURLStr:(NSString *)URLStr;
+ (NSString *)MOVPathForURLStr:(NSString *)URLStr;
@end
