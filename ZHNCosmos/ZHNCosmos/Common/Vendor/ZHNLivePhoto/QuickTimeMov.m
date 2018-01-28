//
//  QuickTimeMov.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "QuickTimeMov.h"

static NSString *const kKeyContentIdentifier = @"com.apple.quicktime.content.identifier";
static NSString *const kKeyStillImageTime = @"com.apple.quicktime.still-image-time";
static NSString *const kKeySpaceQuickTimeMetadata = @"mdta";
static NSString *const kCustomFirst = @"first";
static NSString *const kCustomSecond = @"second";
@interface QuickTimeMov ()
@property (nonatomic, copy) NSString    *path;
@property (nonatomic, assign)CMTimeRange dummyTimeRange;
@property (nonatomic, strong)AVURLAsset *asset;
@end

@implementation QuickTimeMov
- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        self.path = path;
    }
    return self;
}

- (CMTimeRange)dummyTimeRange {
    return CMTimeRangeMake(CMTimeMake(0, 1000), CMTimeMake(200, 3000));
}

- (AVURLAsset *)asset {
    if (!_asset) {
        NSURL *url = [NSURL fileURLWithPath:self.path];
        _asset = [AVURLAsset assetWithURL:url];
    }
    return _asset;
}

- (NSString *)readAssetIdentifier {
    for (AVMetadataItem *item in [self metadata]) {
        if ((NSString *)(item.key) == kKeyContentIdentifier &&
            item.keySpace == kKeySpaceQuickTimeMetadata) {
            return [NSString stringWithFormat:@"%@",item.value];
        }
    }
    return nil;
}

- (NSNumber *)readStillImageTime {
    AVAssetTrack *track = [self track:AVMediaTypeMetadata];
    if (track) {
        NSDictionary *dict = [self reader:track settings:nil];
        AVAssetReader *reader = [dict objectForKey:kCustomFirst];
        [reader startReading];
        AVAssetReaderOutput *output = [dict objectForKey:kCustomSecond];
        while (YES) {
            CMSampleBufferRef buffer = [output copyNextSampleBuffer];
            if (!buffer) {
                return nil;
            }
            if (CMSampleBufferGetNumSamples(buffer) != 0) {
                AVTimedMetadataGroup *group = [[AVTimedMetadataGroup alloc] initWithSampleBuffer:buffer];
                for (AVMetadataItem *item in group.items) {
                    if ((NSString *)(item.key) == kKeyStillImageTime &&
                        item.keySpace == kKeySpaceQuickTimeMetadata) {
                        return item.numberValue;
                    }
                }
            }
        }
    }
    return nil;
}

- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier {
    AVAssetReader *audioReader = nil;
    AVAssetWriterInput *audioWriterInput = nil;
    AVAssetReaderOutput *audioReaderOutput = nil;
    @try {
        // reader for source video
        AVAssetTrack *track = [self track:AVMediaTypeVideo];
        if (!track) {
            NSLog(@"not found video track");
            return;
        }
        NSDictionary *dict = [self reader:track settings:@{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]}];
        AVAssetReader *reader = [dict objectForKey:kCustomFirst];
        AVAssetReaderOutput *output = [dict objectForKey:kCustomSecond];
        // writer for mov
        NSError *writerError = nil;
        AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:dest] fileType:AVFileTypeQuickTimeMovie error:&writerError];
        writer.metadata = @[[self metadataFor:assetIdentifier]];
        
        // video track
        AVAssetWriterInput *input = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:[self videoSettings:track.naturalSize]];
        input.expectsMediaDataInRealTime = YES;
        input.transform = track.preferredTransform;
        [writer addInput:input];
        
        NSURL *url = [NSURL fileURLWithPath:self.path];
        AVAsset *aAudioAsset = [AVAsset assetWithURL:url];
        
        if (aAudioAsset.tracks.count > 1) {
            NSLog(@"Has Audio");
            // setup audio writer
            audioWriterInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:nil];
            
            audioWriterInput.expectsMediaDataInRealTime = NO;
            if ([writer canAddInput:audioWriterInput]) {
                [writer addInput:audioWriterInput];
            }
            // setup audio reader
            AVAssetTrack *audioTrack = [aAudioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject;
            audioReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:nil];
            @try {
                NSError *audioReaderError = nil;
                audioReader = [AVAssetReader assetReaderWithAsset:aAudioAsset error:&audioReaderError];
                if (audioReaderError) {
                    NSLog(@"Unable to read Asset, error: %@",audioReaderError);
                }
            } @catch (NSException *exception) {
                NSLog(@"Unable to read Asset: %@", exception.description);
            } @finally {
                
            }
            
            if ([audioReader canAddOutput:audioReaderOutput]) {
                [audioReader addOutput:audioReaderOutput];
            } else {
                NSLog(@"cant add audio reader");
            }
        }
        
        // metadata track
        AVAssetWriterInputMetadataAdaptor *adapter = [self metadataAdapter];
        [writer addInput:adapter.assetWriterInput];
        
        // creating video
        [writer startWriting];
        [reader startReading];
        [writer startSessionAtSourceTime:kCMTimeZero];
        
        // write metadata track
        AVMetadataItem *metadataItem = [self metadataForStillImageTime];
        
        [adapter appendTimedMetadataGroup:[[AVTimedMetadataGroup alloc] initWithItems:@[metadataItem] timeRange:self.dummyTimeRange]];
        
        // write video track
        [input requestMediaDataWhenReadyOnQueue:dispatch_queue_create("assetVideoWriterQueue", 0) usingBlock:^{
            while (input.isReadyForMoreMediaData) {
                if (reader.status == AVAssetReaderStatusReading) {
                    CMSampleBufferRef buffer = [output copyNextSampleBuffer];
                    if (buffer) {
                        if (![input appendSampleBuffer:buffer]) {
                            NSLog(@"cannot write: %@", writer.error);
                            [reader cancelReading];
                        }
                    }
                } else {
                    [input markAsFinished];
                    if (reader.status == AVAssetReaderStatusCompleted && aAudioAsset.tracks.count > 1) {
                        [audioReader startReading];
                        [writer startSessionAtSourceTime:kCMTimeZero];
                        dispatch_queue_t media_queue = dispatch_queue_create("assetAudioWriterQueue", 0);
                        [audioWriterInput requestMediaDataWhenReadyOnQueue:media_queue usingBlock:^{
                            while ([audioWriterInput isReadyForMoreMediaData]) {
                                CMSampleBufferRef sampleBuffer2 = [audioReaderOutput copyNextSampleBuffer];
                                if (audioReader.status == AVAssetReaderStatusReading && sampleBuffer2 != nil) {
                                    if (![audioWriterInput appendSampleBuffer:sampleBuffer2]) {
                                        [audioReader cancelReading];
                                    }
                                } else {
                                    [audioWriterInput markAsFinished];
                                    NSLog(@"Audio writer finish");
                                    [writer finishWritingWithCompletionHandler:^{
                                        NSError *e = writer.error;
                                        if (e) {
                                            NSLog(@"cannot write: %@",e);
                                        } else {
                                            NSLog(@"finish writing.");
                                        }
                                    }];
                                }
                            }
                        }];
                    } else {
                        NSLog(@"Video Reader not completed");
                        [writer finishWritingWithCompletionHandler:^{
                            NSError *e = writer.error;
                            if (e) {
                                NSLog(@"cannot write: %@",e);
                            } else {
                                NSLog(@"finish writing.");
                            }
                        }];
                    }
                }
            }
        }];
        while (writer.status == AVAssetWriterStatusWriting) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (writer.error) {
            NSLog(@"cannot write: %@", writer.error);
        }
    } @catch (NSException *exception) {
        NSLog(@"error: %@", exception.description);
    } @finally {
        
    }
}

- (NSArray<AVMetadataItem *> *)metadata {
    return [self.asset metadataForFormat:AVMetadataFormatQuickTimeMetadata];
}

- (AVAssetTrack *)track:(NSString *)mediaType {
    return [self.asset tracksWithMediaType:mediaType].firstObject;
}

- (NSDictionary *)reader:(AVAssetTrack *)track settings:(NSDictionary *)settings {
    AVAssetReaderTrackOutput *output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:settings];
    NSError *readerError = nil;
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:self.asset error:&readerError];
    [reader addOutput:output];
    return @{kCustomFirst:reader, kCustomSecond:output};
}

- (AVAssetWriterInputMetadataAdaptor *)metadataAdapter {
    NSDictionary *spec = @{
                           (__bridge NSString *)kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier:[NSString stringWithFormat:@"%@/%@",kKeySpaceQuickTimeMetadata,kKeyStillImageTime],
                           (__bridge NSString *)kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType:@"com.apple.metadata.datatype.int8"
                           };
    
    CMFormatDescriptionRef desc = nil;

    CMMetadataFormatDescriptionCreateWithMetadataSpecifications(kCFAllocatorDefault, kCMMetadataFormatType_Boxed, (__bridge CFArrayRef)@[spec], &desc);
    AVAssetWriterInput *input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeMetadata outputSettings:nil sourceFormatHint:desc];
    return [AVAssetWriterInputMetadataAdaptor assetWriterInputMetadataAdaptorWithAssetWriterInput:input];
}

- (NSDictionary *)videoSettings:(CGSize)size {
    return @{
             AVVideoCodecKey : AVVideoCodecH264,
             AVVideoWidthKey : @(size.width),
             AVVideoHeightKey : @(size.height)
             };
}

- (AVMetadataItem *)metadataFor:(NSString *)assetIdentifier {
    AVMutableMetadataItem *item = [AVMutableMetadataItem metadataItem];
    item.key = kKeyContentIdentifier;
    item.keySpace = kKeySpaceQuickTimeMetadata;
    item.value = assetIdentifier;
    item.dataType = @"com.apple.metadata.datatype.UTF-8";
    return item;
}

- (AVMetadataItem *)metadataForStillImageTime {
    AVMutableMetadataItem *item = [AVMutableMetadataItem metadataItem];
    item.key = kKeyStillImageTime;
    item.keySpace = kKeySpaceQuickTimeMetadata;
    item.value = @(0);
    item.dataType = @"com.apple.metadata.datatype.int8";
    return item;
}

@end
