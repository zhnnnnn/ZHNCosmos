//
//  ZHNTimelineComment.h
//  ZHNCosmos
//
//  Created by zhn on 2018/1/18.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNTimelineModel.h"
@class ZHNTimelineComment,ZHNTimelineCommentMoreInfo;
@interface ZHNTimelineComment : ZHNTimelineStatus <YYModel>
@property (nonatomic,assign) unsigned long long ID;
@property (nonatomic,assign) BOOL liked;
@property (nonatomic,copy) NSString *likeCounts;
@property (nonatomic,strong) NSArray <ZHNTimelineComment *> *comments;
@property (nonatomic,strong) ZHNTimelineComment *replyComment;
@property (nonatomic,strong) ZHNTimelineCommentMoreInfo *moreInfo;
@property (nonatomic,strong) NSAttributedString *moreText;
@property (nonatomic,assign) CGSize moreTextPreSize;
@end

////////////////////////////////////////////////////////
@interface ZHNTimelineCommentMoreInfo : NSObject
@property (nonatomic,copy) NSString *scheme;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *highlightText;
@end
