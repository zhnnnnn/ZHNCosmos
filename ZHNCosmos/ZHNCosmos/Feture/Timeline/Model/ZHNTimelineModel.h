//
//  ZHNTimelineModel.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNArchivedDataRootObject.h"

@class ZHNTimelineURL,ZHNTimelineUser,ZHNTimelinePicMetaData,ZHNVideoMeteData;
// every timeline status model
@interface ZHNTimelineStatus : ZHNArchivedDataRootObject
// basics
@property (nonatomic,strong) NSDate *createdDate;
@property (nonatomic,assign) unsigned long long statusID;
@property (nonatomic,assign) unsigned long long mid;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,assign) int sourceAllowclick;
@property (nonatomic,assign) BOOL favorited;
@property (nonatomic,assign) BOOL truncated;
@property (nonatomic,copy) NSString *thumbnailPic;
@property (nonatomic,copy) NSString *bmiddlePic;
@property (nonatomic,copy) NSString *originalPic;
@property (nonatomic,assign) int repostsCount; // reweet
@property (nonatomic,assign) int commentsCount; // comment
@property (nonatomic,assign) int attitudesCount; // like
@property (nonatomic,copy) NSString *picVideo;// for Live Photo
@property (nonatomic,copy) NSString *gifIds;
@property (nonatomic,copy) NSArray *picIds;
@property (nonatomic,copy) NSArray *picUrlDicts;
@property (nonatomic,copy) NSString *picStatus;
@property (nonatomic,assign) BOOL isLongText;
@property (nonatomic,strong) ZHNTimelineStatus *retweetedStatus;
@property (nonatomic,strong) ZHNTimelineUser *user;

// deal
@property (nonatomic,assign) BOOL isReweetAtnameAdded;
@property (nonatomic,strong) NSData *richTextData;// Use nsdata for cache
@property (nonatomic,copy) NSArray *picUrlStrings;// pic url string array
@property (nonatomic,strong) NSArray <ZHNTimelinePicMetaData *> *picMetaDatas;
@property (nonatomic,strong) NSArray <ZHNTimelineURL *> *urlStructs;
@property (nonatomic,copy) NSString *dateAndSourceStr;
@property (nonatomic,assign) BOOL isHaveVideo;
@property (nonatomic,assign) CGSize richTextPreferredSize;
@end

////////////////////////////////////////////////////////
// user model
@interface ZHNTimelineUser : ZHNArchivedDataRootObject
@property (nonatomic,assign) unsigned long long userID;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *gender; // `f` `m`
@property (nonatomic,assign) int province;
@property (nonatomic,assign) int city;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *userDescription;
@property (nonatomic,copy) NSString *profileImageUrl;
@property (nonatomic,copy) NSString *coverImage;
@property (nonatomic,copy) NSString *coverImagePhone;
@property (nonatomic,assign) unsigned long long followersCount;// fans
@property (nonatomic,assign) int friendsCount;// Focus
@property (nonatomic,assign) int statusesCount;
@property (nonatomic,assign) BOOL following;
@property (nonatomic,assign) BOOL followMe;
@property (nonatomic,copy) NSString *avatarLarge;
@property (nonatomic,copy) NSString *avatarHd;
@property (nonatomic,copy) NSString *verifiedReason;
@property (nonatomic,assign) int verifiedLevel;
@property (nonatomic,assign) int verifiedType;
@end

////////////////////////////////////////////////////////
typedef NS_ENUM(NSInteger,ZHNUrlType) {
    ZHNUrlTypeNormal,// normal url such as `video` `pic` etc
    ZHNUrlTypeMoreStatues// status is too long. use this url to see more
};
@interface ZHNTimelineURL : ZHNArchivedDataRootObject
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *urlShort;
@property (nonatomic,copy) NSString *urlLong;
@property (nonatomic,copy) NSString *replaceString;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *urlColor;
@property (nonatomic,assign) NSInteger urlType;
- (ZHNVideoMeteData *)zhn_searchVideoMetaData;
+ (ZHNVideoMeteData *)zhn_searchVideoMetaDataForShortURLStr:(NSString *)shortURLStr;
@end

////////////////////////////////////////////////////////
typedef NS_ENUM(NSInteger,TimelinePicType) {
    TimelinePicTypeNormal,
    TimelinePicTypeLong,
    TimelinePicTypeGif,
    TimelinePicTypeLivePhoto
};
@interface ZHNTimelinePicMetaData : ZHNArchivedDataRootObject
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *livePhotoMovUrl;
@property (nonatomic,assign) TimelinePicType picType;
@end

////////////////////////////////////////////////////////
@interface ZHNVideoMeteData : ZHNArchivedDataRootObject
@property (nonatomic,copy) NSString *shortUrl;// PrimaryKey
@property (nonatomic,assign) long long int videoSize;
@property (nonatomic,assign) int videDuration;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *imageUrl;
@end

