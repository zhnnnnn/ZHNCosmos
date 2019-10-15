//
//  ZHNMainControllerColorPickerTrasitionHelper.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/13.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZHNColorPickerDismissCompletionBlock)();
@interface ZHNMainControllerColorPickerTrasitionHelper : NSObject
+ (void)showColorPicker;
+ (void)disMissColorPciker;
+ (void)disMissColorPickerWithCompletion:(ZHNColorPickerDismissCompletionBlock)completion;
@end
