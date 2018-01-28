//
//  WBEmojiContentModel.h
//  AsyncDisplayWeibo
//
//  Created by zhn on 17/8/5.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBEmojiItemModel;
@interface WBEmojiInfoModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,strong) NSArray <WBEmojiItemModel *> *emoticons;
@end

// ----------------------------------------------
// ----------------------------------------------
// ----------------------------------------------
//chs = "[\U8bb8\U613f]";
//cht = "[\U8a31\U9858]";
//gif = "lxh_xuyuan.gif";
//png = "lxh_xuyuan.png";
//type = 0;
@interface WBEmojiItemModel : NSObject
// Simplified chinese
@property (nonatomic, strong) NSString *chs;
// Traditional chinese
@property (nonatomic, strong) NSString *cht;
// gif image naem
@property (nonatomic, strong) NSString *gif;
// png image name
@property (nonatomic, strong) NSString *png;
//
@property (nonatomic, strong) NSString *type;
@end
