//
//  RACSignal+ZHNRichTextHelper.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/4.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "RACSignal+ZHNRichTextHelper.h"
#import "ZHNStatusHelper.h"
#import "UIColor+highlight.h"
#import "ZHNTimelineModel.h"
#import "NSAttributedString+YYText.h"
#import "ZHNTimelineLayoutModel.h"

typedef void(^ZHNEventAction)();
@implementation RACSignal (ZHNRichTextHelper)
- (RACSignal *)atFormatter {
    return [self flattenMap:^RACStream *(NSAttributedString *attributeString) {
        NSMutableAttributedString *muAttribuString = [attributeString mutableCopy];
        // Need to set NSAttributedString color at first.
        [ZHNThemeManager zhn_extraNightHandle:^{
            [muAttribuString yy_setColor:ZHNHexColor(@"969696") range:muAttribuString.yy_rangeOfAll];
        } dayHandle:^{
           [muAttribuString yy_setColor:ZHNHexColor(@"000000") range:muAttribuString.yy_rangeOfAll];
        }];        
        attributeString = [RACSignal regularExpressionAttribustring:muAttribuString regularExpression:[ZHNStatusHelper regexAt] richTextType:ZHNRichTextTappedTypeAt];
        return [RACSignal return:attributeString];
    }];
}

- (RACSignal *)topicFormatter {
    return [self flattenMap:^RACStream *(NSAttributedString *attributeString) {
        NSMutableAttributedString *muAttribuString = [attributeString mutableCopy];
        attributeString = [RACSignal regularExpressionAttribustring:muAttribuString regularExpression:[ZHNStatusHelper regexTopic] richTextType:ZHNRichTextTappedTypeTopic];
        return [RACSignal return:attributeString];
    }];
}

- (RACSignal *)emojiFormatter {
    return [self flattenMap:^RACStream *(NSAttributedString *attributeString) {
        NSMutableAttributedString *muAttribuString = [attributeString mutableCopy];
        NSArray *emojiArray = [[ZHNStatusHelper regexEmoticon] matchesInString:attributeString.string options:kNilOptions range:attributeString.yy_rangeOfAll];
        CGFloat fontWH = [UIFont systemFontOfSize:KTextFont].pointSize;
        NSUInteger locationOffset = 0;
        for (NSTextCheckingResult *emo in emojiArray) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            NSString *emoString = [attributeString.string substringWithRange:range];
            NSString *imagePath = [ZHNStatusHelper WBEmojiDict][emoString];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (!image) continue;
            NSRange subRange = range;
            subRange.location = subRange.location - locationOffset;
            NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontWH];
            if (subRange.location + subRange.length > muAttribuString.length) continue;
            [muAttribuString replaceCharactersInRange:subRange withAttributedString:emoText];
            locationOffset += emoString.length - 1;
        }
        attributeString = [muAttribuString copy];
        return [RACSignal return:attributeString];
    }];
}

- (RACSignal *)urlFormatter:(ZHNTimelineStatus *)status richTextMaxWidth:(CGFloat)richTextMaxWidth; {
    return [self flattenMap:^RACStream *(NSAttributedString *value) {
        NSMutableAttributedString *attributedString = [value mutableCopy];
        [attributedString yy_setFont:[UIFont zhn_fontWithSize:KTextFont] range:attributedString.yy_rangeOfAll];
        attributedString.yy_lineSpacing = KTextPadding;
        CGFloat fontWH = [UIFont zhn_fontWithSize:KTextFont].pointSize;
        NSMutableArray *replaceRange = [NSMutableArray array];
        for (ZHNTimelineURL *urlStruct in status.urlStructs) {
            if (!urlStruct.replaceString) {break;}
            NSString *urlStr = urlStruct.urlType == ZHNUrlTypeNormal ? urlStruct.urlShort : urlStruct.urlLong;
            NSRange urlRange = [attributedString.string rangeOfString:urlStr options:kNilOptions range:attributedString.yy_rangeOfAll];
            // string
            NSMutableAttributedString *urlReplace = [[NSMutableAttributedString alloc]initWithString:urlStruct.replaceString];
            [urlReplace yy_setFont:[UIFont zhn_fontWithSize:KTextFont - 3] range:urlReplace.yy_rangeOfAll];
            [urlReplace yy_setColor:[UIColor whiteColor] range:urlReplace.yy_rangeOfAll];
            if (urlRange.location + urlRange.length > attributedString.string.length) {continue;}
            NSAttributedString *blank = [[NSAttributedString alloc]initWithString:@"  "];
            [urlReplace insertAttributedString:blank atIndex:0];
            [urlReplace insertAttributedString:blank atIndex:urlReplace.length];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // icon
                if (urlStruct.imageName.length > 0) {
                    UIImageView *structIconImageView;
                    structIconImageView = [[UIImageView alloc]init];
                    structIconImageView.contentMode = UIViewContentModeScaleAspectFit;
                    structIconImageView.bounds = CGRectMake(0, 0, fontWH, fontWH);
                    structIconImageView.image = [UIImage imageNamed:urlStruct.imageName];
                    NSAttributedString *icon = [NSAttributedString yy_attachmentStringWithContent:structIconImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(fontWH, fontWH) alignToFont:[UIFont systemFontOfSize:KTextFont] alignment:YYTextVerticalAlignmentCenter];
                    [urlReplace insertAttributedString:icon atIndex:0];
                }
                [urlReplace insertAttributedString:blank atIndex:0];
            });
            
            // boder
            YYTextBorder *border = [YYTextBorder new];
            border.fillColor = ZHNHexColor(urlStruct.urlColor);
            if ([urlStruct.replaceString isEqualToString:@"网页链接"]) {
                border.fillColor = [ZHNThemeManager zhn_getThemeColor];
            }
            urlReplace.yy_textBackgroundBorder = border;
            border.cornerRadius = 1000;
            
            // hightlight boder
            YYTextBorder *highlightBoder = [border copy];
            highlightBoder.fillColor = [border.fillColor zhn_darkTypeHighlight];
            YYTextHighlight *highlight = [[YYTextHighlight alloc]init];
            [highlight setColor:[UIColor whiteColor]];
            [highlight setBackgroundBorder:highlightBoder];
            
            [urlReplace yy_setTextHighlight:highlight range:urlReplace.yy_rangeOfAll];
            // shorturl replace with replaceAttributedString
            [attributedString replaceCharactersInRange:urlRange withAttributedString:urlReplace];
            // save range for calculate
            NSRange range = NSMakeRange(urlRange.location, urlReplace.length);
            [replaceRange addObject:[NSValue valueWithRange:range]];
            // insert blank for better display
            [attributedString insertAttributedString:blank atIndex:range.location];
            [attributedString insertAttributedString:blank atIndex:(range.location + range.length + 2)];
            
            // Hight userInfo
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo zhn_safeSetObjetct:@(ZHNRichTextTappedTypeURL) forKey:KCellRichTextTappedTypeKey];
            [userInfo zhn_safeSetObjetct:urlStruct forKey:KCellRichTextTappedURLMetaDataKey];
            highlight.userInfo = userInfo;
        }
    
        __block NSInteger offset = 0;
        [replaceRange enumerateObjectsUsingBlock:^(NSValue *range, NSUInteger idx, BOOL * _Nonnull stop) {
            // For boder show in a line
            // get layout
            CGFloat w = richTextMaxWidth;
            CGSize size = CGSizeMake(w, CGFLOAT_MAX);
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attributedString];
            // judge is boder have two line ? if `yes` insert `\n` in the first
            NSRange urlRange = [range rangeValue];
            urlRange.location = urlRange.location + offset;
            CGRect rect = [layout rectForRange:[YYTextRange rangeWithRange:urlRange]];
            if (rect.size.height > fontWH * 2) {
                [attributedString yy_insertString:@"\n" atIndex:urlRange.location];
                offset++;
            }else if (rect.origin.x + rect.size.width >= w - 5) {// 5 for padding
                [attributedString yy_insertString:@"\n" atIndex:urlRange.location];
                offset++;
            }
        }];
        
        return [RACSignal return:[attributedString copy]];
    }];
}

#pragma mark - pravite methods
+ (NSMutableAttributedString *)regularExpressionAttribustring:(NSMutableAttributedString *)attributeString regularExpression:(NSRegularExpression *)regular richTextType:(ZHNRichTextTappedType)richTextType{
    UIColor *textColor = [ZHNThemeManager zhn_getThemeColor];
    UIColor *backColor = [[ZHNThemeManager zhn_getThemeColor] zhn_lightTypeHighlight];
    NSArray *regularArray = [regular matchesInString:attributeString.string options:kNilOptions range:attributeString.yy_rangeOfAll];
    for (NSTextCheckingResult *result in regularArray) {
        if (result.range.location == NSNotFound || result.range.length <= 1) {continue;}
        YYTextBorder *border = [YYTextBorder borderWithFillColor:backColor cornerRadius:3];
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:textColor];
        [highlight setBackgroundBorder:border];
        [attributeString yy_setTextHighlight:highlight range:result.range];
        [attributeString yy_setColor:textColor range:result.range];
        highlight.userInfo = @{KCellRichTextTappedTypeKey:@(richTextType)};
    }
    return attributeString;
}

@end
