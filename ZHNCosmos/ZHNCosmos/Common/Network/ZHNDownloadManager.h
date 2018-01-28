//
//  ZHNDownloadManager.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ZHNDownloadState) {
    ZHNDownloadStatePause,
    ZHNDownloadStateDownloading,
    ZHNDownloadStateComplete,
    ZHNDownloadStateError,
};
typedef void (^ZHNDownloadStateHandle)(ZHNDownloadState state);
typedef void(^ZHNDownloadProgressHandle)(NSInteger total, NSInteger current);
@interface ZHNDownloadManager : NSObject
/**
 Create download manager

 @return download manager
 */
+ (instancetype)manager;

/**
 Download data

 @param urlStr resource data url string
 @param progress download progress
 @param state download state
 */
- (void)zhn_downloadForURLStr:(NSString *)urlStr
                     progress:(ZHNDownloadProgressHandle)progress
                        state:(ZHNDownloadStateHandle)state;

/**
 Get cached data with url string

 @param urlStr resource url string
 @return cached data
 */
- (NSData *)zhn_getCacheDataForUrlStr:(NSString *)urlStr;

/**
 Get download data path for url

 @param urlStr source url string
 @return path
 */
- (NSString *)zhn_getDownloadSourcePathForUrlStr:(NSString *)urlStr;

/**
 Delete cached data with resource url string

 @param urlStr resource url string
 */
- (void)zhn_deleteCacheDataForUrlStr:(NSString *)urlStr;

/**
 Delete all cache datas
 */
- (void)zhn_deleteAllDatas;
@end

////////////////////////////////////////////////////////
@interface ZHNSessionModel : NSObject
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,strong) NSFileHandle *fileHandle;
@property (nonatomic,assign) NSInteger totalSize;
@property (nonatomic,assign) NSInteger currentSize;
@property (nonatomic,copy) ZHNDownloadStateHandle stateHandle;
@property (nonatomic,copy) ZHNDownloadProgressHandle progressHandle;
@end
