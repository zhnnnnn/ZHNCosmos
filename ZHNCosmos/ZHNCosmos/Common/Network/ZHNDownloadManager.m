//
//  ZHNDownloadManager.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNDownloadManager.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+substring.h"

#define KTotalSizePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZHNDownloadFileSize"]
#define KMimeTypeCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZHNMimeTypeCaches"]
#define KZHNDownloadPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZHNDownload"]
#define KCacheKeyForURLStr(urlStr) [self p_saveKeyForUrlStr:urlStr]
@interface ZHNDownloadManager()
@property (nonatomic,strong) AFURLSessionManager *dataManager;
@property (nonatomic,strong) NSMutableDictionary *sessionModelDict;
@property (nonatomic,strong) NSMutableDictionary *dataTaskDict;
@property (nonatomic,strong) NSFileManager *fileManager;
@end

@implementation ZHNDownloadManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static ZHNDownloadManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNDownloadManager alloc]init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.dataManager.operationQueue.maxConcurrentOperationCount = 5;
    });
    return manager;
}

- (void)zhn_downloadForURLStr:(NSString *)urlStr progress:(ZHNDownloadProgressHandle)progress state:(ZHNDownloadStateHandle)state{
    @weakify(self);
    // Judge if complete
    if ([self p_mimeTypeForUrl:urlStr]) {
        if ([self p_getFileSizeForUrlStr:urlStr] > 0 && [self p_getFileSizeForUrlStr:urlStr] == [self p_getTotalSizeForUrlStr:urlStr]) {
            if (state) {
                state(ZHNDownloadStateComplete);
            }
            return;
        }
    }
    
    // Judge pause or resume
    NSURLSessionDataTask *currentDataTask = [self.dataTaskDict objectForKey:KCacheKeyForURLStr(urlStr)];
    if (currentDataTask) {
        if (currentDataTask.state == NSURLSessionTaskStateRunning) {
            [currentDataTask suspend];
            state(ZHNDownloadStatePause);
            return;
        }else {
            [currentDataTask resume];
            state(ZHNDownloadStateDownloading);
            return;
        }
    }
    // Use http range to Breakpoint download
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:downloadUrl];
    NSInteger fileSize = [self p_getFileSizeForUrlStr:urlStr];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", fileSize];
    [downloadRequest setValue:range forHTTPHeaderField:@"Range"];
    // Create dataTask
    NSURLSessionDataTask *dataTask = [self.dataManager dataTaskWithRequest:downloadRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        @strongify(self);
        NSURLSessionDataTask *dataTask = [self.dataTaskDict objectForKey:KCacheKeyForURLStr(urlStr)];
        ZHNSessionModel *session = [self.sessionModelDict objectForKey:@(dataTask.taskIdentifier)];
        if (session) {
            if (session.stateHandle) {
                if (error.code != NSURLErrorCancelled && error.code != NSURLErrorCannotDecodeContentData) {
                    session.stateHandle(ZHNDownloadStateError);
                }else {
                    session.stateHandle(ZHNDownloadStateComplete);
                }
            }
            [session.fileHandle closeFile];
        }
        
        [self.sessionModelDict removeObjectForKey:@(dataTask.taskIdentifier)];
        [self.dataTaskDict removeObjectForKey:KCacheKeyForURLStr(urlStr)];
        dataTask = nil;
        session = nil;
    }];
    // Save
    [self.dataTaskDict setObject:dataTask forKey:KCacheKeyForURLStr(urlStr)];
    ZHNSessionModel *sessionModel = [[ZHNSessionModel alloc]init];
    NSInteger currentSize = [self p_getFileSizeForUrlStr:urlStr];
    sessionModel.currentSize = currentSize;
    sessionModel.urlStr = urlStr;
    sessionModel.progressHandle = progress;
    sessionModel.stateHandle = state;
    [self.sessionModelDict setObject:sessionModel forKey:@(dataTask.taskIdentifier)];
    
    [self.dataManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        @strongify(self);
        NSString *mineType = [response.MIMEType zhn_substringFromStr:@"/"];
        if ([mineType isEqualToString:@"octet-stream"]) {
            mineType = @"mov";
        }
        [self p_saveMimeType:mineType forUrlStr:urlStr];
        NSString *cachePath = [self p_getCachePathForUrlStr:urlStr mimeType:mineType];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:cachePath];
        ZHNSessionModel *cacheSession = [self.sessionModelDict objectForKey:@(dataTask.taskIdentifier)];
        cacheSession.fileHandle = fileHandle;
        cacheSession.totalSize = response.expectedContentLength + cacheSession.currentSize;
        [self p_saveTotalSize:cacheSession.totalSize forUrlStr:urlStr];
        if (cacheSession.stateHandle) {
            cacheSession.stateHandle(ZHNDownloadStateDownloading);
        }
        return NSURLSessionResponseAllow;
    }];
    
    [self.dataManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        @strongify(self);
        ZHNSessionModel *cacheSession = [self.sessionModelDict objectForKey:@(dataTask.taskIdentifier)];
        [cacheSession.fileHandle seekToEndOfFile];
        [cacheSession.fileHandle writeData:data];
        cacheSession.currentSize += data.length;
        if (cacheSession.progressHandle) {
            cacheSession.progressHandle(cacheSession.totalSize, cacheSession.currentSize);
        }
    }];
    
    [dataTask resume];
}

- (NSData *)zhn_getCacheDataForUrlStr:(NSString *)urlStr {
    NSString *path = [self p_getCachePathForUrlStr:urlStr mimeType:nil];
    return [NSData dataWithContentsOfFile:path];
}

- (void)zhn_deleteCacheDataForUrlStr:(NSString *)urlStr {
    NSURLSessionDataTask *task = [self.dataTaskDict objectForKey:KCacheKeyForURLStr(urlStr)];
    if (task) {
        [task cancel];
    }
    NSString *path = [self p_getCachePathForUrlStr:urlStr mimeType:nil];
    [self.fileManager removeItemAtPath:path error:nil];
}

- (void)zhn_deleteAllDatas {
    for (id key in self.dataTaskDict.allKeys) {
        NSURLSessionDataTask *task = [self.dataTaskDict objectForKey:key];
        [task cancel];
    }
    [self.dataTaskDict removeAllObjects];
    [self.sessionModelDict removeAllObjects];
    [self.fileManager removeItemAtPath:KTotalSizePath error:nil];
    [self.fileManager removeItemAtPath:KZHNDownloadPath error:nil];
    [self.fileManager removeItemAtPath:KMimeTypeCachePath error:nil];
}

- (NSString *)zhn_getDownloadSourcePathForUrlStr:(NSString *)urlStr {
    return [self p_getCachePathForUrlStr:urlStr mimeType:nil];
}
#pragma mark - pravite methods
#pragma mark - cache totalsize
- (void)p_saveTotalSize:(NSInteger)totalSize forUrlStr:(NSString *)urlStr {
    NSMutableDictionary *muDict = [[self p_getTotalSizeCacheDict] mutableCopy];
    [muDict setObject:@(totalSize) forKey:KCacheKeyForURLStr(urlStr)];
    [muDict writeToFile:KTotalSizePath atomically:YES];
}

- (NSInteger)p_getTotalSizeForUrlStr:(NSString *)urlStr {
    NSInteger totalSize = 0;
    totalSize = [[[self p_getTotalSizeCacheDict] objectForKey:KCacheKeyForURLStr(urlStr)] integerValue];
    return totalSize;
}

- (NSDictionary *)p_getTotalSizeCacheDict {
    return [self p_getCacheDictForPath:KTotalSizePath];
}

#pragma mark - data mime type
- (void)p_saveMimeType:(NSString *)mimeType forUrlStr:(NSString *)urlStr {
    NSMutableDictionary *muDict = [[self p_getMimeTypeCacheDict] mutableCopy];
    [muDict setObject:mimeType forKey:KCacheKeyForURLStr(urlStr)];
    [muDict writeToFile:KMimeTypeCachePath atomically:YES];
}

- (NSString *)p_mimeTypeForUrl:(NSString *)urlStr {
    return [[self p_getMimeTypeCacheDict] objectForKey:KCacheKeyForURLStr(urlStr)];
}

- (NSDictionary *)p_getMimeTypeCacheDict {
    return [self p_getCacheDictForPath:KMimeTypeCachePath];
}

#pragma mark - cache data
- (NSString *)p_getCachePathForUrlStr:(NSString *)urlStr mimeType:(NSString *)mimeType{
    if (![self.fileManager fileExistsAtPath:KZHNDownloadPath]) {
        [self.fileManager createDirectoryAtPath:KZHNDownloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!mimeType) {
        mimeType = [self p_mimeTypeForUrl:urlStr];
    }
    
    NSString *cachePath = [NSString stringWithFormat:@"%@.%@",KCacheKeyForURLStr(urlStr),mimeType];
    cachePath = [KZHNDownloadPath stringByAppendingPathComponent:cachePath];
    if (![self.fileManager fileExistsAtPath:cachePath]) {
        [self.fileManager createFileAtPath:cachePath contents:nil attributes:nil];
    }
    return  cachePath;
}

- (NSInteger)p_getFileSizeForUrlStr:(NSString *)urlStr {
    NSInteger fileSize = 0;
    if (![self p_mimeTypeForUrl:urlStr]) {
        return fileSize;
    }
    NSString *cachePath = [self p_getCachePathForUrlStr:urlStr mimeType:nil];
    NSError *error;
    NSDictionary *dict = [self.fileManager attributesOfItemAtPath:cachePath error:&error];
    if (dict) {
        fileSize = [dict fileSize];
    }
    return fileSize;
}

#pragma mark - global
- (NSString *)p_saveKeyForUrlStr:(NSString *)urlStr {
    return [self p_stringMD5:urlStr];
}

- (NSString *)p_stringMD5:(NSString *)string {
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

- (NSDictionary *)p_getCacheDictForPath:(NSString *)path {
    if (![self.fileManager fileExistsAtPath:path]) {
        [self.fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!dict) {
        dict = @{};
    }
    return dict;
}

#pragma mark - getters
- (NSMutableDictionary *)sessionModelDict {
    if (_sessionModelDict == nil) {
        _sessionModelDict = [NSMutableDictionary dictionary];
    }
    return _sessionModelDict;
}

- (NSMutableDictionary *)dataTaskDict {
    if (_dataTaskDict == nil) {
        _dataTaskDict = [NSMutableDictionary dictionary];
    }
    return _dataTaskDict;
}

- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end

////////////////////////////////////////////////////////
@implementation ZHNSessionModel
@end
