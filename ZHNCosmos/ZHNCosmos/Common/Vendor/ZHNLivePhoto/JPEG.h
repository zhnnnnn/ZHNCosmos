//
//  JPEG.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kFigAppleMakerNote_AssetIdentifier = @"17";
@interface JPEG : NSObject
@property (nonatomic, copy) NSString *path;
- (id)initWithPath:(NSString *)path;
- (NSString *)read;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;
@end
