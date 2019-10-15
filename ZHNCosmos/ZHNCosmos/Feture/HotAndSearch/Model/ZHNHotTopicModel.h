//
//  ZHNHotTopicModel.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/24.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNHotTopicModel : NSObject <YYModel>
@property (nonatomic,assign) NSInteger cardType;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *titleSub;// Topic title
@property (nonatomic,copy) NSString *desc1;// Desc
@property (nonatomic,copy) NSString *desc2;// Topic data
@end
