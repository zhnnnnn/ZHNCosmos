//
//  QuickTimeMov.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QuickTimeMov : NSObject
- (id)initWithPath:(NSString *)path;
- (NSString *)readAssetIdentifier;
- (NSNumber *)readStillImageTime;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;
@end
