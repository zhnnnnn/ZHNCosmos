//
//  ZHNStatusHelper.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHNTimelineStatus;
@interface ZHNStatusHelper : NSObject

/**
 Caluate one line text height for font.

 @param font text font
 @return line height
 */
+ (CGFloat)oneLineTextHeightWithFont:(CGFloat)font;

/**
 Caluate text height

 @param text text
 @param maxWidth text max width
 @param font text font
 @return text heght
 */
+ (CGFloat)caluateTextHeightWithText:(NSString *)text MaxWidth:(CGFloat)maxWidth font:(CGFloat)font;

/**
 Caluate text width

 @param text text
 @param maxHeight text max height
 @param font text font
 @return text width
 */
+ (CGFloat)caluateTextWidthWithText:(NSString *)text MaxHeight:(CGFloat)maxHeight font:(CGFloat)font;

/**
 Get resource data

 @param name resource name
 @return resource data
 */
+ (NSData *)WBDataWithSourceName:(NSString *)name;

/**
 At regular. such as `@xxx`

 @return NSRegularExpression
 */
+ (NSRegularExpression *)regexAt;

/**
 Topic regular. such as `#LEWIS_MARNELL#`

 @return NSRegularExpression
 */
+ (NSRegularExpression *)regexTopic;

/**
 Emoji regular. such as `[偷笑]`

 @return NSRegularExpression
 */
+ (NSRegularExpression *)regexEmoticon;

/**
 Source regular
 */
+ (NSRegularExpression *)regexSource;

/**
 URL regular
 */
+ (NSRegularExpression *)regexUrl;


/**
 Domin Regular
 */
+ (NSRegularExpression *)regexDominName;

/**
 Judge is short url?
 */
+ (BOOL)isShortUrl:(NSString *)urlString;

/**
 Get regexed source string
 */
+ (NSString *)regexedSouceString:(NSString *)needRegexString;


/**
 Get emoji status dict

 @return emoji status dict
 */
+ (NSDictionary *)WBEmojiDict;

/**
 Get timeline linker mapping status dict

 @return dict
 */
+ (NSDictionary *)WBLinkerTypeDict;
  
/**
 Get attributeText height

 @param attributeText attributeText
 @param maxWidth attributeText max width
 @return attributeText height
 */
+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText maxWidth:(CGFloat)maxWidth;

/**
 Formatter date

 @param date date
 @return formatter date string
 */
+ (NSString *)formatterDate:(NSDate *)date;

/**
 change timeline` satus`s shorturl to longurl model

 @param statusArray timeline status array
 */
+ (void)longURLDisposeForStatusArray:(NSArray <ZHNTimelineStatus *> *)statusArray
                             success:(void(^)())success
                             failure:(void(^)())failure;
@end
