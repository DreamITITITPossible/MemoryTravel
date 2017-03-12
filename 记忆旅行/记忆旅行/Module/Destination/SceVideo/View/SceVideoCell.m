//
//  SceVideoCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceVideoCell.h"
#import "Sex_AgeView.h"
@interface SceVideoCell ()
@property (nonatomic, strong) UIImageView *backImagView;
@property (nonatomic, strong) UIImageView *liveImageView;
@property (nonatomic, strong) UIView *blackAlphaView;

@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *hourLongLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, strong) Sex_AgeView *sex_AgeView;
@property (nonatomic, strong) UIImageView *officialImageView;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, assign) BOOL isReuse;

@end
@implementation SceVideoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImagView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backImagView];
        self.liveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live"]];
        [_backImagView addSubview:_liveImageView];

        self.blackAlphaView = [[UIView alloc] init];
        _blackAlphaView.backgroundColor = JYXColor(0, 0, 0, 0.5);
        [_backImagView addSubview:_blackAlphaView];
        
        self.videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.textColor = [UIColor whiteColor];
        _videoNameLabel.font = kFONT_SIZE_15;
        _videoNameLabel.backgroundColor = [UIColor clearColor];
        [_blackAlphaView addSubview:_videoNameLabel];
        
        self.hourLongLabel = [[UILabel alloc] init];
        _hourLongLabel.textColor = [UIColor whiteColor];
        _hourLongLabel.font = kFONT_SIZE_12;
        _hourLongLabel.backgroundColor = [UIColor clearColor];
        [_blackAlphaView addSubview:_hourLongLabel];

        self.createDateLabel = [[UILabel alloc] init];
        _createDateLabel.textColor = [UIColor whiteColor];
        _createDateLabel.font = kFONT_SIZE_12;
        _createDateLabel.backgroundColor = [UIColor clearColor];
        [_blackAlphaView addSubview:_createDateLabel];
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 20;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToVC)];
        // 设置需要轻拍的次数
        //    tap.numberOfTapsRequired = 2;
        // 设置多点轻拍
        tap.numberOfTouchesRequired = 1;
        // 视图添加一个手势
        [_headImageView addGestureRecognizer:tap];
        
        [self.contentView addSubview:_headImageView];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kFONT_SIZE_13;
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        self.officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_official"]];
        [self.contentView addSubview:_officialImageView];
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
        [self.contentView addSubview:_locationLabel];
        self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
        [self.contentView addSubview:_locationImageView];
    
         }
    return self;
}
- (void)tapActionToVC {
    [self.delegate ClickHeadImageViewPushToPersonalVCWithSceVideoModel:_sceVideo];
}
- (void)setSceVideo:(SceVideoModel *)sceVideo {
    if (_sceVideo != sceVideo) {
        _sceVideo = sceVideo;
    }
    if ([_sceVideo.videoPic hasSuffix:@".png"]) {
        
    }
    [_backImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _sceVideo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    if (![_sceVideo.videoType isEqualToString:@"1"]) {
        _liveImageView.hidden = YES;
        _hourLongLabel.text = _sceVideo.hour_long;
    } else {
        _hourLongLabel.hidden = YES;

    }
    _videoNameLabel.text = _sceVideo.videoName;
    _createDateLabel.text = [_sceVideo.creatDate componentsSeparatedByString:@" "].firstObject;
  
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _sceVideo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = _sceVideo.Nickname;
    if ([_sceVideo.Age isEqualToString:@"0"]) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = _sceVideo.Age;
    }
    _sex_AgeView.sex = _sceVideo.Sex;
  
   
    if ([_sceVideo.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    
    _locationLabel.text = _sceVideo.videoAdress;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }

}
- (void)prepareForReuse {
    [super prepareForReuse];
    _sex_AgeView.hidden = NO;
    _officialImageView.hidden = NO;
    _liveImageView.hidden = NO;
    _hourLongLabel.hidden = NO;
    _liveImageView.image = [UIImage imageNamed:@"icon_live"];
    self.isReuse = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _backImagView.frame = CGRectMake(0, 0, self.width, self.width);
    _liveImageView.frame = CGRectMake(_backImagView.width - 45, 5, 40, 40);
    _blackAlphaView.frame = CGRectMake(0, _backImagView.height - 50, _backImagView.width, 50);
    _videoNameLabel.frame = CGRectMake(5, 10, _blackAlphaView.width - 10, 20);
    CGFloat dateWidth = [UILabel getWidthWithTitle:_createDateLabel.text font:_createDateLabel.font];
    _createDateLabel.frame = CGRectMake(_videoNameLabel.x, _videoNameLabel.y + _videoNameLabel.height + 5, dateWidth, 12);
    CGFloat hourLongWidth = [UILabel getWidthWithTitle:_hourLongLabel.text font:_hourLongLabel.font];
    _hourLongLabel.frame = CGRectMake(_blackAlphaView.width - hourLongWidth - 10, _createDateLabel.y, hourLongWidth, 12);
    _headImageView.frame = CGRectMake(5, _backImagView.y + _backImagView.height + 10, 40, 40);
    CGFloat nickNameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nickNameWidth > 50) {
        nickNameWidth = 50;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 5, _headImageView.y + _headImageView.height / 2 - 8, nickNameWidth, 15);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 3, _nickNameLabel.y - 3, 50, 15);
    _officialImageView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 3, _nickNameLabel.y - 3, 40, 20);
    
    _locationImageView.frame = CGRectMake(_headImageView.x, _headImageView.y + _headImageView.height + 10, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:kFONT_SIZE_13];
    if (width > self.contentView.width - (_locationImageView.x + _locationImageView.width + 5 + 5)) {
        width = self.contentView.width - (_locationImageView.x + _locationImageView.width + 5 + 5);
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);

   
    
}
@end
