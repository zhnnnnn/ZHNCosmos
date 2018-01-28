//
//  ZHNConstantHeader.h
//  ZHNCosmos
//
//  Created by zhn on 2017/9/21.
//  Copyright © 2017年 zhn. All rights reserved.
//

#ifndef ZHNConstantHeader_h
#define ZHNConstantHeader_h

#define KTabbarItemNormalColor RGBCOLOR(97, 114, 130)
#define KTabbarMenuNormalColor RGBCOLOR(200, 200, 200)
#define K_tabbar_height ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83 : 49)
#define K_statusBar_height [UIApplication sharedApplication].statusBarFrame.size.height
static const CGFloat K_tabbar_response_height = 49;
static const CGFloat K_tabbar_safeArea_height = 34;
static const CGFloat K_navigationBar_content_height = 44;
#define K_Navibar_height (K_navigationBar_content_height + K_statusBar_height)

// mark - add user success (need reload data)
static NSString* const KUserAddSuccessNotification = @"KUserAddSuccessNotification";

// mark - network host
#define KNetWorkLivePhotoHost @"http://video.weibo.com/media/play?livephoto=http://us.sinaimg.cn/"

// mark - pic
static NSString* const KCellTapPicAction = @"KCellTapPicAction";
static NSString* const KCellTapPicPhotosKey = @"KCellTapPicPhotosKey";
static NSString* const KCellTapPicIndexKey = @"KCellTapPicIndexKey";
static NSString* const KCellTapPicMeteDatas = @"KCellTapPicMeteDatas";

// mark - video
static NSString* const KCellTapVideoAction = @"KCellTapVideoAction";
static NSString* const KCellTapVideoURLMetaDataKey = @"KCellTapVideoURLMetaDataKey";
static NSString* const KCellTapVideoVideoViewKey = @"KCellTapVideoVideoViewKey";
static NSString* const KCellTapVideoNeedRemoveFromViewKey = @"KCellTapVideoNeedRemoveFromViewKey";

// mark - Rich text
typedef NS_ENUM(NSInteger,ZHNRichTextTappedType) {
    ZHNRichTextTappedTypeAt,
    ZHNRichTextTappedTypeTopic,
    ZHNRichTextTappedTypeURL,
};
static NSString* const KCellRichTextTappedTypeKey = @"KCellRichTextTappedTypeKey"; // value ZHNRichTextTappedType

// mark - url
static NSString* const KCellRichTextTappedURLMetaDataKey = @"KCellRichTextTappedURLMetaDataKey";

// mark - normal url
static NSString* const KCellRichTextTapNormalURLAction = @"KCellRichTextTapNormalURLAction";
static NSString* const KCellRichTextTapNormalURLMetaDataKey = @"KCellRichTextTapNormalURLMetaDataKey";

// mark - pic url
static NSString* const KCellRichTextTapPicURLAction = @"KCellRichTextTapPicURLAction";
static NSString* const KCellRichTextTapPicURLKey = @"KCellRichTextTapPicURLKey";
static NSString* const KCellRichTextTapPicURLForAnimateViewKey = @"KCellRichTextTapPicURLForAnimateViewKey";

// mark - at
static NSString* const KCellRichTextTapAtAction = @"KCellRichTextTapAtAction";
static NSString* const KCellRichTextTapAtKeywordKey = @"KCellRichTextTapAtKeywordKey";

// mark - topic
static NSString* const KCellRichTextTapTopicAction = @"KCellRichTextTapTopicAction";
static NSString* const KCellRichTextTapTopicKeywordKey = @"KCellRichTextTapTopicKeywordKey";

// mark - avatar username
static NSString* const KCellTapAvatarOrUsernameAction = @"KCellTapAvatarOrUsernameAction";
static NSString* const KCellTapAvatarOrUsernameUserModelKey = @"KCellTapAvatarOrUsernameUserModelKey";

// mark - detail
static NSString* const KCellToSeeStatusDetailAction = @"KCellToSeeStatusDetailAction";
static NSString* const KCellToSeeStatusDetailStatusKey = @"KCellToSeeStatusDetailStatusKey";
static NSString* const KCellToSeeStatusDetailDefaultTypeKey = @"KCellToSeeStatusDetailDefaultTypeKey";

// mark - search
static NSString* const KCellTapToSearchWordAction = @"KCellTapToSearchWordAction";
static NSString* const KCellTapToSearchWordKey = @"KCellTapToSearchWordKey";
#endif
