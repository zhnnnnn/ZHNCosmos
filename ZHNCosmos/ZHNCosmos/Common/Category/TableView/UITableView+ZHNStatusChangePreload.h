//
//  UITableView+ZHNStatusChangePreload.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/17.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZHNStatusChangePreload)
- (void)zhn_preloadWithLoadPreferenceCount:(NSInteger)count
                                controller:(NSObject *)controller
                              dataArrayKey:(NSString *)dataArrayKey;
@end
