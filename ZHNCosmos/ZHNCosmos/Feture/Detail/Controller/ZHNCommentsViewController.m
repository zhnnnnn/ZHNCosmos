//
//  ZHNCommentsViewController.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/12.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNCommentsViewController.h"
#import "ZHNTimelineCommentsCellNode.h"
#import "ZHNTimelineComment.h"
#import "RACSignal+ZHNRichTextHelper.h"
#import "NSAttributedString+ZHNStringPreferredSize.h"

@implementation ZHNCommentsViewController
- (NSArray<NSString *> *)gooeyMenuTitles {
    return @[@"分享",@"回复",@"取消"];
}

- (NSString *)requestURL {
    return @"https://api.weibo.com/2/comments/show.json";
}

- (Class)displayTableNode_dataClass {
    return [ZHNTimelineComment class];
}

- (NSArray *)displayTableNode_requestJsonArrayMapKeyArray {
    return @[@"comments"];
}

- (NSInteger)everyRequestMaxCount {
    return 25;
}

- (RACSignal *)displayTableNode_formatterDataArrat:(NSArray *)dataArray {
    return [[super displayTableNode_formatterDataArrat:dataArray]
    flattenMap:^RACStream *(NSArray *commentArray) {
        [commentArray enumerateObjectsUsingBlock:^(ZHNTimelineComment *comment, NSUInteger idx, BOOL * _Nonnull stop) {
            __block NSString *moreText;
            [comment.comments enumerateObjectsUsingBlock:^(ZHNTimelineComment *detailComment, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    moreText = [NSString stringWithFormat:@"@%@:%@",detailComment.user.name,detailComment.text];
                }else {
                    moreText = [NSString stringWithFormat:@"%@\n@%@:%@",moreText,detailComment.user.name,detailComment.text];
                }
            }];
            
            if (comment.moreInfo) {
                if (moreText) {
                    moreText = [NSString stringWithFormat:@"%@\n%@ >",moreText,comment.moreInfo.highlightText];
                }else {
                    moreText = [NSString stringWithFormat:@"%@ >",comment.moreInfo.highlightText];
                }
            }
            
            if (moreText) {
                [[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:[[NSMutableAttributedString alloc] initWithString:moreText]];
                    return nil;
                }]
                atFormatter]
                topicFormatter]
                emojiFormatter]
                subscribeNext:^(NSAttributedString *attText) {
                    NSMutableAttributedString *muAttText = [attText mutableCopy];
                    [muAttText yy_setFont:[UIFont zhn_fontWithSize:KTextFont - 2] range:muAttText.yy_rangeOfAll];
                    muAttText.yy_lineSpacing = KTextPadding;
                    attText = [muAttText copy];
                    comment.moreText = attText;
                    comment.moreTextPreSize = [attText zhn_sizeForMaxWidth:K_SCREEN_WIDTH - 100];
                }];
            }
        }];
        return [RACSignal return:commentArray];
    }];
}

- (NSDictionary *)requestParamsWithFetchDataType:(ZHNfetchDataType)type {
    unsigned long long maxID = 0;
    if (self.statusArray.count > 0) {
        maxID = [[self.statusArray lastObject] ID];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];    
    ZHNUserMetaDataModel *disPlayUser = [ZHNUserMetaDataModel displayUserMetaData];
    [params zhn_safeSetObjetct:disPlayUser.accessToken forKey:@"access_token"];
    [params zhn_safeSetObjetct:@([self everyRequestMaxCount]) forKey:@"count"];
    [params zhn_safeSetObjetct:@(self.statuID) forKey:@"id"];
    [params zhn_safeSetObjetct:@(0) forKey:@"since_id"];
    [params zhn_safeSetObjetct:@(maxID) forKey:@"max_id"];
    [params zhn_safeSetObjetct:@(0) forKey:@"filter_by_author"];
    return params;
}

#pragma mark - delegate
- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHNTimelineCommentsCellNode *node = [[ZHNTimelineCommentsCellNode alloc]init];
    node.comment = self.statusArray[indexPath.row];
    [self tableNodeDisplayCell:node indexpath:indexPath];
    return node;
}
@end
