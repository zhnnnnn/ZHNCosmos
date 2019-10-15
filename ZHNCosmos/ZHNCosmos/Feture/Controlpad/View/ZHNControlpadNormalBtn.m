//
//  ZHNControlpadNormalBtn.m
//  ZHNCosmos
//
//  Created by zhn on 2017/10/29.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadNormalBtn.h"

@implementation ZHNControlpadNormalBtn
- (void)btnClickHandle {
    if (self.normalHandle) {
        self.normalHandle();
    }
}
@end
