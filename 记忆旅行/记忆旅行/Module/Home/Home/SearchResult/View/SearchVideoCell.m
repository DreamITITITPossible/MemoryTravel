//
//  SearchVideoCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/2.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchVideoCell.h"
#import "Sex_AgeView.h"
@interface SearchVideoCell ()


@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *liveImageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *hourLongLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation SearchVideoCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 16;
        _headImageView.userInteractionEnabled = YES;
        
        _headImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToVC:)];
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
        
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        
        
        self.videoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_videoImageView];
        self.playImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"video_play"] ];
        _playImageView.backgroundColor = [UIColor clearColor];
        [_videoImageView addSubview:_playImageView];
        self.blackView = [[UIView alloc] init];
        _blackView.backgroundColor = JYXColor(0, 0, 0, 0.4);
        [self.videoImageView addSubview:_blackView];
        
        self.playCountLabel = [[UILabel alloc] init];
        _playCountLabel.layer.cornerRadius = 2;
        _playCountLabel.font = kFONT_SIZE_10;
        _playCountLabel.textColor = [UIColor whiteColor];
        _playCountLabel.backgroundColor = [UIColor clearColor];
        [self.blackView addSubview:_playCountLabel];
        self.liveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live"]];

        [self.videoImageView addSubview:_liveImageView];
        self.hourLongLabel = [[UILabel alloc] init];
        _hourLongLabel.font = kFONT_SIZE_10;
        _hourLongLabel.layer.cornerRadius = 2;
        _hourLongLabel.textColor = [UIColor whiteColor];
        _hourLongLabel.backgroundColor = [UIColor clearColor];
        [self.blackView addSubview:_hourLongLabel];
        
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0], [UIColor darkGrayColor]);
        _locationLabel.textColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
        [self.contentView addSubview:_locationLabel];
        self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
        [self.contentView addSubview:_locationImageView];
        
        
    }
    return self;
}
- (void)tapActionToVC:(SceVideoModel *)sceVideo{
    
    [self.delegate ClickSearchHeadImageViewPushToPersonalVCWithArray:[NSMutableArray arrayWithObject:_sceVideo] type:@"sceVideo"];
   
}
- (void)setSceVideo:(SceVideoModel *)sceVideo {

    if (_sceVideo != sceVideo) {
        _sceVideo = sceVideo;
    }
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = sceVideo.Nickname;
    _sex_AgeView.sex = sceVideo.Sex;
    if ([sceVideo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = sceVideo.Age;
    }
    _titleLabel.text = sceVideo.videoName;
   
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [sceVideo.creatDate substringToIndex:10];
    if (![_sceVideo.videoType isEqualToString:@"1"]) {
        _liveImageView.hidden = YES;
        _hourLongLabel.text = _sceVideo.hour_long;
    } else {
        _hourLongLabel.hidden = YES;
        
    }    if ([sceVideo.videoAdress isEqualToString:@"未知地址"]) {
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    } else {
        _locationLabel.text = sceVideo.videoAdress;
    }
   
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _videoImageView.frame = CGRectMake(10, 10,(self.contentView.height - 20) / 3 * 4 , self.contentView.height - 20);
 
    _playImageView.frame = CGRectMake(_videoImageView.width / 2 - 10, _videoImageView.height / 2 - 10, 20, 20);
    _liveImageView.frame = CGRectMake(_videoImageView.width - 25, 5, 20, 20);
    _blackView.frame = CGRectMake(0, _videoImageView.height - 30, _videoImageView.width, 30);
    CGFloat playCountWidth = [UILabel getWidthWithTitle:_playCountLabel.text font:_playCountLabel.font];
    _playCountLabel.frame = CGRectMake(5, _blackView.height / 2 - 5, playCountWidth, 10);
    CGFloat hourLongWidth = [UILabel getWidthWithTitle:_hourLongLabel.text font:_hourLongLabel.font];
    _hourLongLabel.frame = CGRectMake(_blackView.width - hourLongWidth - 5, _playCountLabel.y, hourLongWidth, _playCountLabel.height);
    
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - _videoImageView.x - _videoImageView.width - 20) title:_titleLabel.text font:_titleLabel.font];
    if (titleHight > 40) {
        titleHight = 40;
    }
    _titleLabel.frame = CGRectMake(_videoImageView.x + _videoImageView.width + 10, _videoImageView.y + 3, SCREEN_WIDTH - _videoImageView.x - _videoImageView.width - 20, titleHight);
    
    _headImageView.frame = CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 15, 34, 34);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nameWidth > SCREEN_WIDTH - _headImageView.x - _headImageView.width - 3 - 3 - 25 - 10) {
        nameWidth = SCREEN_WIDTH - _headImageView.x - _headImageView.width - 3 - 3 - 25 - 10;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 3, _headImageView.centerY - 7, nameWidth, 14);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 3, _nickNameLabel.centerY - 10, 25, 15);
    
    _locationImageView.frame = CGRectMake(_headImageView.x, _videoImageView.y + _videoImageView.height - 24, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:kFONT_SIZE_13];
    if (width > self.contentView.width / 2 - 5 - 24) {
        width = self.contentView.width / 2 - 5 - 24;
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);

    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _locationImageView.hidden = NO;
    _locationLabel.hidden = NO;
    _liveImageView.hidden = NO;
    _hourLongLabel.hidden = NO;
    _liveImageView.image = [UIImage imageNamed:@"icon_live"];
    _isReuse = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
