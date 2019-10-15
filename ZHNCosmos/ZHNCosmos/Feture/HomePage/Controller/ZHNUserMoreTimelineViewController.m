//
//  ZHNUserMoreTimelineViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2017/12/30.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNUserMoreTimelineViewController.h"
#import "ZHNHomePageOriginalTimelineCacheModel.h"

@interface ZHNUserMoreTimelineViewController ()

@end

@implementation ZHNUserMoreTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userStatusType = ZHNUserTimelineStatusTypeOriginal;
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
    return [ZHNHomePageOriginalTimelineCacheModel class];
}

@end
