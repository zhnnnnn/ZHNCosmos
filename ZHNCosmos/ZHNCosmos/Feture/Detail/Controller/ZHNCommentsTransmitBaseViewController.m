//
//  ZHNCommentsTransmitBaseViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/18.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNCommentsTransmitBaseViewController.h"
#import "RACSignal+statusMapping.h"
#import "RACSignal+CommentsPreferredSize.h"

@interface ZHNCommentsTransmitBaseViewController ()

@end

@implementation ZHNCommentsTransmitBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhn_navibarAlpha = 0;
}
- (RACSignal *)displayTableNode_formatterDataArrat:(NSArray *)dataArray {
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:dataArray];
                return nil;
            }]
            URLMapReweet:NO]
            formatterRichTextMaxWidth:(K_SCREEN_WIDTH - 80)]
            preferredSizeWithMaxWidth:(K_SCREEN_WIDTH - 80)];
}

@end
