//
//  ZHNSearchDot.m
//  ZHNCosmos
//
//  Created by zhn on 2018/1/25.
//  Copyright © 2018年 zhn. All rights reserved.
//

#import "ZHNSearchDot.h"
#import "UIColor+highlight.h"
#import "ZHNSearchHistoryTableView.h"

static CGFloat const KDotSize = 50;
static CGFloat const KControlHeight = 30;
#define KDotStartFrame CGRectMake(K_SCREEN_WIDTH - (KDotSize + 20), K_SCREEN_HEIGHT - 200, KDotSize , KDotSize + KControlHeight)
#define KDotInputFrame CGRectMake(0, KControlHeight, KDotSize, KDotSize)
@interface ZHNSearchDot()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *inputContainerView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UITextField *searhWordField;
@property (nonatomic,strong) UISegmentedControl *searchTypeControl;
@property (nonatomic,strong) UITableView *historyView;
@property (nonatomic,assign,getter=isShowing) BOOL showing;
@end

@implementation ZHNSearchDot
- (instancetype)init {
    if (self = [super init]) {
        self.showing = YES;
        self.frame = KDotStartFrame;
        [self addSubview:self.searchTypeControl];
        [self addSubview:self.inputContainerView];
        [self.inputContainerView addSubview:self.iconImageView];
        [self.inputContainerView addSubview:self.searhWordField];
        self.searchTypeControl.frame = CGRectMake(0, KControlHeight, K_SCREEN_WIDTH, KControlHeight);

        // Begin enditing
        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification){
            @strongify(self);
            CGRect endFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
            self.historyView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height + (KDotSize + KControlHeight), 0);
            [UIView animateWithDuration:duration animations:^{
                self.historyView.alpha = 1;
                self.iconImageView.hidden = YES;
                self.searhWordField.hidden = NO;
                self.inputContainerView.layer.cornerRadius = 0;
                self.frame = CGRectMake(0, endFrame.origin.y - (KDotSize + KControlHeight), endFrame.size.width, (KDotSize + KControlHeight));
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.searchTypeControl.hidden = NO;
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.searchTypeControl.frame = CGRectMake(0, 3, K_SCREEN_WIDTH, KControlHeight);
                } completion:nil];
            }];
        }];
        
        // End enditing
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
            self.searchTypeControl.hidden = YES;
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
            self.iconImageView.alpha = 0;
            self.iconImageView.hidden = NO;
            [UIView animateWithDuration:duration animations:^{
                self.historyView.alpha = 0;
                self.searhWordField.alpha = 0;
                self.iconImageView.alpha = 1;
                self.inputContainerView.layer.cornerRadius = KDotSize/2;
                self.frame = KDotStartFrame;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.searhWordField.alpha = 1;
                self.searhWordField.hidden = YES;
                self.searchTypeControl.frame = CGRectMake(0, KControlHeight, K_SCREEN_WIDTH, KControlHeight);
            }];
        }];
        
        // Tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self zhn_beginSearchEditing];
        }];
        [self addGestureRecognizer:tap];
        
        // Theme color
        self.extraThemeColorChangeHandle = ^{
            @strongify(self);
            self.searchTypeControl.tintColor = [ZHNThemeManager zhn_getThemeColor];
            [ZHNThemeManager zhn_extraNightHandle:^{
                self.searchTypeControl.backgroundColor = ZHNHexColor(@"202020");
                self.searhWordField.backgroundColor = [[ZHNThemeManager zhn_getThemeColor] zhn_darkTypeHighlight];
            } dayHandle:^{
                self.searchTypeControl.backgroundColor = ZHNHexColor(@"ececec");
                self.searhWordField.backgroundColor = [UIColor whiteColor];
            }];
        };
        
        self.extraNightVersionChangeHandle = ^{
            @strongify(self);
            self.extraThemeColorChangeHandle();
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.inputContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(KDotSize);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.inputContainerView);
        make.size.mas_equalTo(CGSizeMake(KDotSize/2, KDotSize/2));
    }];
    [self.searhWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
}

#pragma mark - public methods
- (void)zhn_beginSearchEditing {
    self.searhWordField.userInteractionEnabled = YES;
    [self.searhWordField becomeFirstResponder];
}

- (void)zhn_endSearchEditing {
    [self.searhWordField resignFirstResponder];
    self.searhWordField.userInteractionEnabled = NO;
}

- (void)zhn_animateShow {
    if (self.isShowing) {return;}
    self.showing = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)zhn_animateHide {
    if (!self.isShowing) {return;}
    self.showing = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }];
}

+ (instancetype)zhn_searchDotWithRelevanceHistoryTableView:(UITableView *)historyView {
    ZHNSearchDot *dot = [[ZHNSearchDot alloc]init];
    dot.historyView = historyView;
    return dot;
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length != 0) {
        [self.delegate ZHNSearchDotClickKeyboardSearhKeyWithSearchWord:textField.text];
    }else {
        [ZHNHudManager showError:@"请输入搜索的内容~"];
    }
    return YES;
}

#pragma mark - getters
- (ZHNSearchType)searchType {
    return self.searchTypeControl.selectedSegmentIndex == 0 ? ZHNSearchTypeTimeline : ZHNSearchTypeUser;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"icon_search_2"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UITextField *)searhWordField {
    if (_searhWordField == nil) {
        _searhWordField = [[UITextField alloc]init];
        _searhWordField.userInteractionEnabled = NO;
        UIImageView *leftIcon = [[UIImageView alloc]init];
        leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        leftIcon.image = [[UIImage imageNamed:@"icon_search_2"] imageWithTintColor:[UIColor lightGrayColor]];
        leftIcon.frame = CGRectMake(0, 0, 40, 20);
        _searhWordField.leftView = leftIcon;
        _searhWordField.leftViewMode = UITextFieldViewModeAlways;
        _searhWordField.backgroundColor = [UIColor whiteColor];
        _searhWordField.returnKeyType = UIReturnKeySearch;
        _searhWordField.layer.cornerRadius = 10;
        _searhWordField.tintColor = [ZHNThemeManager zhn_getThemeColor];
        _searhWordField.clipsToBounds = YES;
        _searhWordField.hidden = YES;
        _searhWordField.delegate = self;
        _searhWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searhWordField;
}

- (UIView *)inputContainerView {
    if (_inputContainerView == nil) {
        _inputContainerView = [[UIView alloc]init];
        _inputContainerView.isCustomThemeColor = YES;
        _inputContainerView.layer.cornerRadius = KDotSize/2;
    }
    return _inputContainerView;
}

- (UISegmentedControl *)searchTypeControl {
    if (_searchTypeControl == nil) {
        _searchTypeControl = [[UISegmentedControl alloc]initWithItems:@[@"微博",@"用户"]];
        _searchTypeControl.selectedSegmentIndex = 0;
        _searchTypeControl.hidden = YES;
    }
    return _searchTypeControl;
}
@end
