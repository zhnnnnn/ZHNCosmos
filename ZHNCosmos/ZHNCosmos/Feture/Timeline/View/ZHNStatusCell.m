//
//  ZHNStatusCell.m
//  ZHNCosmos
//
//  Created by zhn on 2017/11/6.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNStatusCell.h"
#import "ZHNProfileView.h"
#import "UIImage+resizeImage.h"
#import "ZHNSudokuPicView.h"
#import "ZHNStatusVideoView.h"
#import "ZHNStatusToolView.h"
#import "ZHNVideoPlayerManager.h"
#import "UIColor+highlight.h"
#import "ZHNCosmosConfigManager.h"
#import "ZHNNetworkManager+timeline.h"
#import "ZHNRichTextPicURLManager.h"
#import "ZHNRichTextPicURLManager.h"
#import "ZHNStripedBarManager.h"
#import "RACSignal+ZHNRichTextHelper.h"
#import "ZHNYYRouterLabel.h"
#import "ZHNTimelineDetailContainViewController.h"

@interface ZHNStatusCell()
@property (nonatomic,strong) UIImageView *backCardView;
@property (nonatomic,strong) ZHNProfileView *headView;
@property (nonatomic,strong) ZHNYYRouterLabel *statusTextLabel;
@property (nonatomic,strong) ZHNYYRouterLabel *reweetStatuTextLabel;
@property (nonatomic,strong) ZHNSudokuPicView *sudokuPicView;
@property (nonatomic,strong) ZHNStatusVideoView *videoView;
@property (nonatomic,strong) UIImageView *reweetBackView;
@property (nonatomic,strong) ZHNStatusToolView *toolBar;
@property (nonatomic,strong) ZHNStatusToolView *reweetToolBar;
@end

@implementation ZHNStatusCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
        [self addSubview:self.backCardView];
        [self addSubview:self.reweetBackView];
        [self addSubview:self.headView];
        [self addSubview:self.statusTextLabel];
        [self addSubview:self.reweetStatuTextLabel];
        [self addSubview:self.sudokuPicView];
        [self addSubview:self.videoView];
        [self addSubview:self.toolBar];
        [self addSubview:self.reweetToolBar];
    }
    return self;
}

+ (ZHNStatusCell *)zhn_statusCellWithTableView:(UITableView *)tableView {
    ZHNStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
    if (!cell) {
        cell = [[ZHNStatusCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"statusCell"];
    }
    return cell;
}

- (void)setLayout:(ZHNTimelineLayoutModel *)layout {
    _layout = layout;
    // head
    self.headView.layout = layout;
    // text
    self.statusTextLabel.frame = layout.textF;
    self.statusTextLabel.attributedText = [NSAttributedString yy_unarchiveFromData:layout.status.richTextData];
    // reweet text
    self.reweetStatuTextLabel.frame = layout.reweetTextF;
    self.reweetStatuTextLabel.attributedText = [NSAttributedString yy_unarchiveFromData:layout.status.retweetedStatus.richTextData];
    // pics
    self.sudokuPicView.layout = layout;
    // vide
    self.videoView.frame = layout.videoCardF;
    ZHNTimelineStatus *status = layout.status.retweetedStatus ? layout.status.retweetedStatus : layout.status;
    if (status.isHaveVideo) {
        self.videoView.videoUrlModel = [status.urlStructs firstObject];
    }
    // reweet back
    self.reweetBackView.frame = layout.reweetBackViewF;
    // reweet toolbar
    self.reweetToolBar.isReweet = YES;
    self.reweetToolBar.toolbarFrame = layout.reweetToolBarF;
    self.reweetToolBar.status = layout.status.retweetedStatus;
    // toolbar
    self.toolBar.isReweet = NO;
    self.toolBar.toolbarFrame = layout.toolBarF;
    self.toolBar.status = layout.status;
    // cardcontainrView
    self.backCardView.frame = layout.cardContainerF;
}

- (void)reloadCellRichTextConfig {
    [self p_reloadRichTextLabel:self.statusTextLabel mappingStatus:self.layout.status];
    if (self.layout.status.retweetedStatus) {
        [self p_reloadRichTextLabel:self.reweetStatuTextLabel mappingStatus:self.layout.status.retweetedStatus];
    }
}

- (void)p_reloadRichTextLabel:(YYLabel *)richTextLabel mappingStatus:(ZHNTimelineStatus *)status{
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
    [[[[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSAttributedString *attribuString = [[NSAttributedString alloc] initWithString:status.text];
        [subscriber sendNext:attribuString];
        return nil;
    }]
    atFormatter]
    topicFormatter]
    emojiFormatter]
    urlFormatter:status richTextMaxWidth:[ZHNTimelineLayoutModel richTextMaxWidth]]
    subscribeOn:scheduler]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(NSAttributedString *richText) {
         richTextLabel.attributedText = richText;
     }];
}

- (void)touchingAnimateForView:(UIView *)view touchPoint:(CGPoint)touchPoint{
    ZHNCosmosConfigCommonModel *commonModel = [ZHNCosmosConfigManager commonConfigModel];
    if (commonModel) {
#warning TODO Setting
    }
    UIView *needScaleView = view;
    UIView *needColorView;
    UIColor *startColor;
    if ([self.headView.subviews containsObject:view] || [view isKindOfClass:[ZHNProfileView class]]) {
        needScaleView = self;
    }
    if ([view isKindOfClass:[YYLabel class]]) {
        needScaleView = self;
    }
    if (CGRectContainsPoint(self.reweetBackView.frame, touchPoint) && [view isEqual:self.reweetStatuTextLabel]) {
        needColorView = self.reweetBackView;
        startColor = self.reweetBackView.backgroundColor;
    }
    [UIView animateWithDuration:0.15 animations:^{
        needScaleView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        needColorView.backgroundColor = [startColor zhn_darkTypeHighlightForPercent:0.05];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 animations:^{
                needScaleView.transform = CGAffineTransformIdentity;
                needColorView.backgroundColor = startColor;
            }];
        });
    }];
}

- (void)tapCellInView:(UIView *)view point:(CGPoint)tapPoint {
    if (CGRectContainsPoint(self.backCardView.frame, tapPoint)) {
        if (CGRectContainsPoint(self.reweetBackView.frame, tapPoint)) {
            [self zhn_routerEventWithName:KCellToSeeStatusDetailAction  userInfo:@{KCellToSeeStatusDetailStatusKey:self.layout.status.retweetedStatus,KCellToSeeStatusDetailDefaultTypeKey:@(ZHNDefaultShowTypeDetail)}];
        }else {
            [self zhn_routerEventWithName:KCellToSeeStatusDetailAction userInfo:@{KCellToSeeStatusDetailStatusKey:self.layout.status,KCellToSeeStatusDetailDefaultTypeKey:@(ZHNDefaultShowTypeDetail)}];
        }
    }
}

- (void)longPressCellInView:(UIView *)view point:(CGPoint)point {
    [ZHNHudManager showWarning:@"longPress TODO~~"];
}

#pragma mark -
- (ZHNProfileView *)headView {
    if (_headView == nil) {
        _headView = [[ZHNProfileView alloc]init];
    }
    return _headView;
}

- (ZHNYYRouterLabel *)statusTextLabel {
    if (_statusTextLabel == nil) {
        _statusTextLabel = [[ZHNYYRouterLabel alloc]init];
    }
    return _statusTextLabel;
}

- (UIImageView *)backCardView {
    if (_backCardView == nil) {
        _backCardView = [[UIImageView alloc]init];
        _backCardView.dk_backgroundColorPicker = DKColorPickerWithKey(CellBG);
        _backCardView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _backCardView.layer.shadowOpacity = 0.3;
        _backCardView.layer.cornerRadius = 6;
        _backCardView.layer.shadowOffset = CGSizeMake(0, 0.5);
    }
    return _backCardView;
}

- (ZHNSudokuPicView *)sudokuPicView {
    if (_sudokuPicView == nil) {
        _sudokuPicView = [[ZHNSudokuPicView alloc]init];
    }
    return _sudokuPicView;
}

- (ZHNStatusVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [[ZHNStatusVideoView alloc]init];
    }
    return _videoView;
}

- (ZHNYYRouterLabel *)reweetStatuTextLabel {
    if (_reweetStatuTextLabel == nil) {
        _reweetStatuTextLabel = [[ZHNYYRouterLabel alloc]init];
    }
    return _reweetStatuTextLabel;
}

- (UIImageView *)reweetBackView {
    if (_reweetBackView == nil) {
        _reweetBackView = [[UIImageView alloc]init];
        _reweetBackView.dk_backgroundColorPicker = DKColorPickerWithKey(CellReweetBG);
    }
    return _reweetBackView;
}

- (ZHNStatusToolView *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[ZHNStatusToolView alloc]init];
    }
    return _toolBar;
}

- (ZHNStatusToolView *)reweetToolBar {
    if (_reweetToolBar == nil) {
        _reweetToolBar = [[ZHNStatusToolView alloc]init];
    }
    return _reweetToolBar;
}
@end
