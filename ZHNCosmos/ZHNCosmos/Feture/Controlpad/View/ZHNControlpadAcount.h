//
//  ZHNControlpadAcount.h
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNControlpadAcount : UIView

@end

/////////////////////////////////////////////////////
typedef NS_ENUM(NSInteger,countCellType) {
    countCellTypeNormal,
    countCellTypeAdd
};
@interface ZHNControlpadCountCell : UICollectionViewCell
@property (nonatomic,assign) countCellType cellType;
@property (nonatomic,copy) NSString *avatarURL;
@end
