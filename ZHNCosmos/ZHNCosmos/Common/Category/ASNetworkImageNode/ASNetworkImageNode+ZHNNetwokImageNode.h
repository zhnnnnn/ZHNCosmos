//
//  ASNetworkImageNode+ZHNNetwokImageNode.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/15.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class ZHNForASNetImageNodeWebImageManager;
@interface ASNetworkImageNode (ZHNNetwokImageNode)
+ (instancetype)imageNode;
@property (nonatomic,strong) ZHNForASNetImageNodeWebImageManager *imageManager;
@end

/////////////////////////////////////////////////////
@interface ZHNForASNetImageNodeWebImageManager : YYWebImageManager <ASImageCacheProtocol,ASImageDownloaderProtocol>

@end
