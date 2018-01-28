//
//  ZHNPhotoItem.h
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHNPhotoItem : NSObject
@property (nonatomic,strong) UIImageView *sourceImageView;
@property (nonatomic,strong) UIImage *placeholder;
@property (nonatomic,copy) NSString *imageUrlStr;
@property (nonatomic,copy) NSString *livePhotoMovURLStr;


+ (instancetype)zhn_photoItemWithImageView:(UIImageView *)sourceImageView
                               placeholder:(UIImage *)placeholder
                               imageUrlStr:(NSString *)imageUrlStr
                        livePhotoMovUrlStr:(NSString *)livePhotoMovUrlStr;
@end
