//
//  ZHNHotSearchModel.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHNHotSearchCardGroupModel;
@interface ZHNHotSearchModel : NSObject <YYModel>
@property (nonatomic,copy) NSString *itemid;
@property (nonatomic,strong) NSArray <ZHNHotSearchCardGroupModel *> *cardGroup;
@end

////////////////////////////////////////////////////////
@interface ZHNHotSearchCardGroupModel : NSObject <YYModel>
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *descExtr;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *icon;
// title pic
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) NSString *titlePic;
@end
