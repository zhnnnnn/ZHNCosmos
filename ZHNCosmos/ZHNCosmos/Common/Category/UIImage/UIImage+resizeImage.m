//
//  UIImage+resizeImage.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIImage+resizeImage.h"

@implementation UIImage (resizeImage)
+ (UIImage *)resizableImageWithImageName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h/2, w/2, h/2,w/2)];
}

+ (UIImage *)resizableImageForImage:(UIImage *)image {
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h/2, w/2, h/2,w/2)];
}
@end
