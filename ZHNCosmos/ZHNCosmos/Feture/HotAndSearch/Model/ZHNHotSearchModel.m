//
//  ZHNHotSearchModel.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/22.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNHotSearchModel.h"

@implementation ZHNHotSearchModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"cardGroup":@"card_group"};
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"cardGroup":[ZHNHotSearchCardGroupModel class]};
}
@end

////////////////////////////////////////////////////////
@implementation ZHNHotSearchCardGroupModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"descExtr":@"desc_extr"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"pic_items"] isKindOfClass:[NSArray class]]) {
        self.titlePic = dic[@"pic_items"][0][@"pic"];
    }
    return YES;
}
@end
