//
//  ZHNControlpadAcount.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/2.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNControlpadAcount.h"
#import "ZHNUserMetaDataModel.h"
#import "ZHNCosmosLoginView.h"
#import "ZHNControlpadTransitionHelper.h"

static NSString *const KReuseKey = @"controlpadcountCell";
@interface ZHNControlpadAcount()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *userArray;
@end

@implementation ZHNControlpadAcount
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        self.userArray = [ZHNUserMetaDataModel addedUsers];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHNControlpadCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KReuseKey forIndexPath:indexPath];
    if (indexPath.row >= self.userArray.count) {
        cell.cellType = countCellTypeAdd;
    }else {
        cell.avatarURL = [[(ZHNUserMetaDataModel *)self.userArray[indexPath.row] userDetail] profileImageUrl];
        cell.cellType = countCellTypeNormal;
    }
    return cell;
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([ZHNUserMetaDataModel displayUserMetaData]) {
        [ZHNHudManager showWarning:@"多账号切换TODO~"];
    }else {
        [ZHNControlpadTransitionHelper dismissControlpadCompletion:^{
            [ZHNCosmosLoginView zhn_showLoginView];
        }];
    }
}

#pragma mark - getters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(45, 45);
        layout.minimumInteritemSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[ZHNControlpadCountCell class] forCellWithReuseIdentifier:KReuseKey];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
@end

/////////////////////////////////////////////////////
@interface ZHNControlpadCountCell()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIImageView *addImageView;
@end

@implementation ZHNControlpadCountCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [ZHNThemeManager zhn_getThemeColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.addImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
    self.iconImageView.layer.cornerRadius = (self.width - 2)/2;
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.addImageView.layer.cornerRadius = self.width/2;
}

- (void)setAvatarURL:(NSString *)avatarURL {
    _avatarURL = avatarURL;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:avatarURL] placeholder:nil];
}

- (void)setCellType:(countCellType)cellType {
    _cellType = cellType;
    switch (cellType) {
        case countCellTypeAdd:
        {
            self.addImageView.hidden = NO;
            self.iconImageView.hidden = YES;
        }
            break;
        case countCellTypeNormal:
        {
            self.addImageView.hidden = YES;
            self.iconImageView.hidden = NO;
        }
            break;
    }
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)addImageView {
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc]init];
        _addImageView.clipsToBounds = YES;
        _addImageView.image = [UIImage imageNamed:@"control_pad_user_add"];
    }
    return _addImageView;
}
@end
