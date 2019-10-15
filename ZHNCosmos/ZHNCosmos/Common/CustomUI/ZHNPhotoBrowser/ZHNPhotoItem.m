//
//  ZHNPhotoItem.m
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNPhotoItem.h"

@implementation ZHNPhotoItem
+ (instancetype)zhn_photoItemWithImageView:(UIImageView *)sourceImageView placeholder:(UIImage *)placeholder imageUrlStr:(NSString *)imageUrlStr livePhotoMovUrlStr:(NSString *)livePhotoMovUrlStr{
    ZHNPhotoItem *item = [[ZHNPhotoItem alloc]init];
    item.sourceImageView = sourceImageView;
    item.imageUrlStr = imageUrlStr;
    item.placeholder = placeholder;
    item.livePhotoMovURLStr = livePhotoMovUrlStr;
    return item;
}
@end
