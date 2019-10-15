//
//  ZHNPhotoBrowser.h
//  ZHNPhotoBrowser
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ZHNBrowserHandle)();
@class ZHNPhotoBrowser,ZHNPhotoItem;
@interface ZHNPhotoBrowser : UIViewController

/**
 Create browser

 @param photoItems photo status item
 @param index current select index
 @return browser
 */
+ (ZHNPhotoBrowser *)zhn_photoBrowserWithPhotoItems:(NSArray <ZHNPhotoItem *> *)photoItems
                                       currentIndex:(NSInteger)index;

/**
 Show browser

 @param controller which controller show this browser
 */
- (void)showFromViewController:(UIViewController *)controller
         browserWillShowHandle:(ZHNBrowserHandle)showHandle
      browserWillDismissHandle:(ZHNBrowserHandle)dismissHandle;
@end
