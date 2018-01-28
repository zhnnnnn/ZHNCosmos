//
//  UIImage+resizeImage.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resizeImage)
+ (UIImage *)resizableImageWithImageName:(NSString *)name;
+ (UIImage *)resizableImageForImage:(UIImage *)image;
@end
