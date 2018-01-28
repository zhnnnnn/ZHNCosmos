//
//  JPEG.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "JPEG.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

@implementation JPEG
- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        self.path = path;
    }
    return self;
}

- (NSString *)read {
    NSDictionary *met = [self metadata];
    if (!met) {
        return nil;
    }
    NSDictionary *dict = [met objectForKey:(__bridge NSString *)kCGImagePropertyMakerAppleDictionary];
    NSString *str = [dict objectForKey:kFigAppleMakerNote_AssetIdentifier];
    return str;
}

- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier {
    // creating image destinations
    CGImageDestinationRef ret = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:dest], kUTTypeJPEG, 1, nil);
    if (!ret) {
        return;
    }
    CGImageSourceRef imageSource = [self imageSource];
    if (!imageSource) {
        return;
    }
    NSMutableDictionary *metadata = [[self metadata] mutableCopy];
    if (!metadata) {
        return;
    }
    // adding images
    NSMutableDictionary *makerNote = [NSMutableDictionary dictionary];
    [makerNote setObject:assetIdentifier forKey:kFigAppleMakerNote_AssetIdentifier];
    [metadata setObject:makerNote forKey:(__bridge NSString *)kCGImagePropertyMakerAppleDictionary];
    CGImageDestinationAddImageFromSource(ret, imageSource, 0, (__bridge CFDictionaryRef)metadata);
    
    CFRelease(imageSource);
    
    CGImageDestinationFinalize(ret);
}

#pragma mark - image metaData
- (NSDictionary *)metadata {
    CGImageSourceRef isrc = [self imageSource];
    NSDictionary *dict = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isrc, 0, nil));
    CFRelease(isrc);
    return dict;
}

- (CGImageSourceRef)imageSource {
    return CGImageSourceCreateWithData((__bridge CFDataRef)[self data], nil);
}

- (NSData *)data {
    return [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.path]];
}
@end
