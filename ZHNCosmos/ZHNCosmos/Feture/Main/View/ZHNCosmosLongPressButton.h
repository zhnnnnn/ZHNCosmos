//
//  ZHNCosmosLongPressButton.h
//  ZHNCosmos
//
//  Created by zhn on 2017/10/24.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNCosmosTabbarItem.h"
#import "ZHNAwesome3DMenu.h"

@interface ZHNCosmosLongPressButton : UIView
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) ZHNTabbarItemSelectedTypeClickBlcok tapAction;
@property (nonatomic,copy) NSArray <ZHN3DMenuActivity *> *coronaActivityArray;
@end
