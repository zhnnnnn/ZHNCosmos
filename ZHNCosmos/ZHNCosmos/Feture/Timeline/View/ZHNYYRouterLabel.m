//
//  ZHNYYRouterLabel.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/13.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNYYRouterLabel.h"
#import "ZHNTimelineModel.h"
#import "ZHNStripedBarManager.h"
#import "ZHNRichTextPicURLManager.h"

@implementation ZHNYYRouterLabel
- (instancetype)init {
    if (self = [super init]) {
        self.displaysAsynchronously = YES;
        self.fadeOnHighlight = NO;
        self.fadeOnAsynchronouslyDisplay = NO;
        self.numberOfLines = 0;
        @weakify(self);
        self.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            [self p_richTextHighlightTapActionWithText:text selectRect:rect selectRange:range animateContainerView:containerView];
        };
    }
    return self;
}

- (void)p_richTextHighlightTapActionWithText:(NSAttributedString *)text selectRect:(CGRect)rect selectRange:(NSRange)range animateContainerView:(UIView *)containerView{
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:range.location];
    NSDictionary *userInfo = highlight.userInfo;
    ZHNRichTextTappedType type = [[userInfo valueForKey:KCellRichTextTappedTypeKey] integerValue];
    switch (type) {
        case ZHNRichTextTappedTypeURL:
        {
            ZHNTimelineURL *URLMetaData = [userInfo valueForKey:KCellRichTextTappedURLMetaDataKey];
            if (URLMetaData.urlType == ZHNUrlTypeNormal) {
                if ([URLMetaData.replaceString isEqualToString:@"微博视频"] || [URLMetaData.replaceString isEqualToString:@"秒拍"]) {
                    ZHNVideoMeteData *videoMetaData = [URLMetaData zhn_searchVideoMetaData];
                    UIImageView *imageView = [[UIImageView alloc]init];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.frame = rect;
                    [imageView yy_setImageWithURL:[NSURL URLWithString:videoMetaData.imageUrl] placeholder:nil];
                    [containerView addSubview:imageView];
                    [self zhn_routerEventWithName:KCellTapVideoAction
                                         userInfo:@{
                                                    KCellTapVideoURLMetaDataKey:URLMetaData,
                                                    KCellTapVideoVideoViewKey:imageView,
                                                    KCellTapVideoNeedRemoveFromViewKey:@(YES)
                                                    }];
                }else if ([URLMetaData.replaceString isEqualToString:@"查看图片"]) {
                    [ZHNStripedBarManager zhn_animateShowStripedBarToProgress:0.7];
                    @weakify(self);
                    [ZHNRichTextPicURLManager zhn_getDefaultPicURLWithKeyURL:URLMetaData.urlLong success:^(NSString *imageURL) {
                        [ZHNStripedBarManager zhn_animateFinish];
                        @strongify(self);
                        UIImageView *imageView = [[UIImageView alloc]init];
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;
                        imageView.frame = rect;
                        [imageView yy_setImageWithURL:[NSURL URLWithString:URLMetaData.urlLong] placeholder:[UIImage imageNamed:@"placeholder_image"]];
                        [containerView addSubview:imageView];
                        [self zhn_routerEventWithName:KCellRichTextTapPicURLAction
                                             userInfo:@{
                                                        KCellRichTextTapPicURLKey:imageURL,
                                                        KCellRichTextTapPicURLForAnimateViewKey:imageView
                                                        }];
                    } failure:^{
                        [ZHNStripedBarManager zhn_animateFinish];
                    }];
                }else {
                    [self zhn_routerEventWithName:KCellRichTextTapNormalURLAction
                                         userInfo:@{
                                                    KCellRichTextTapNormalURLMetaDataKey:URLMetaData
                                                    }];
                }
            }
            
        }
            break;
        case ZHNRichTextTappedTypeAt:
        {
            NSString *str = [text.string substringWithRange:range];
            str = [[str mutableCopy] substringFromIndex:1];
            [self zhn_routerEventWithName:KCellRichTextTapAtAction
                                 userInfo:@{KCellRichTextTapAtKeywordKey:str}];
        }
            break;
        case ZHNRichTextTappedTypeTopic:
        {
            NSString *str = [text.string substringWithRange:range];
            [self zhn_routerEventWithName:KCellRichTextTapTopicAction
                                 userInfo:@{KCellRichTextTapTopicKeywordKey:str}];
        }
            break;
    }
}
@end
