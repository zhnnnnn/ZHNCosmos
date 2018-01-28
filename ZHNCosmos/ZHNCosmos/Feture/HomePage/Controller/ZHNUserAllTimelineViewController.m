//
//  ZHNUserAllTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNUserAllTimelineViewController.h"
#import "ZHNHomePageAllTimelineCacheModel.h"

@interface ZHNUserAllTimelineViewController ()

@end

@implementation ZHNUserAllTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userStatusType = ZHNUserTimelineStatusTypeAll;
}

- (void)initializeLayoutsWithCachesIfHave {
    [[self loadDataWithType:ZHNfetchDataTypeLoadCache]
     subscribeCompleted:^{
     }];
}

- (Class)cacheModelCalss {
    ZHNUserMetaDataModel *userMeta = [ZHNUserMetaDataModel displayUserMetaData];
    if (self.uid == 0 || userMeta.uid != self.uid) {
        return nil;
    }
    return [ZHNHomePageAllTimelineCacheModel class];
}

@end
