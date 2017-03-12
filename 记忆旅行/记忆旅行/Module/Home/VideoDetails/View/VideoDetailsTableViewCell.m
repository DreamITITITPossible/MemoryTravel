//
//  VideoDetailsTableViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "VideoDetailsTableViewCell.h"

#import "Sex_AgeView.h"

@interface VideoDetailsTableViewCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, strong) UIImageView *officialImageView;
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *hourLongLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, assign) BOOL isReuse;
@property (nonatomic, copy) NSString *touristID;
@property (nonatomic, copy) NSString *isOfficial;

@end
@implementation VideoDetailsTableViewCell

{
    NSString *_videoWidth;
    NSString *_videoHeight;
    NSString *_touristID;
    UserInfo *userinfo;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        userinfo = [UserInfo getUserDetailsInfomation];
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 20;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailsTapActionToVC)];
        // 设置需要轻拍的次数
        //    tap.numberOfTapsRequired = 2;
        // 设置多点轻拍
        tap.numberOfTouchesRequired = 1;
        // 视图添加一个手势
        [_headImageView addGestureRecognizer:tap];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kFONT_SIZE_15_BOLD;
        _nickNameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        self.officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_official"]];
        [self.contentView addSubview:_officialImageView];

        
        self.createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = kFONT_SIZE_13;
        _createDateLabel.textColor = [UIColor lightGrayColor];
        _createDateLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_createDateLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kFONT_SIZE_18;
        [self.contentView addSubview:_titleLabel];
        
        self.videoBackImgBlurView = [[UIImageView alloc] init];
        _videoBackImgBlurView.userInteractionEnabled = YES;
        [self.contentView addSubview:_videoBackImgBlurView];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [_videoBackImgBlurView addSubview:_effectView];
        
        self.videoImageView = [[UIImageView alloc] init];
        [self.videoBackImgBlurView addSubview:_videoImageView];
        
        self.playImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"video_play"] ];
        _playImageView.backgroundColor = [UIColor clearColor];
        [self.videoBackImgBlurView addSubview:_playImageView];
        self.playCountLabel = [[UILabel alloc] init];
        _playCountLabel.layer.cornerRadius = 2;
        _playCountLabel.font = kFONT_SIZE_13;
        _playCountLabel.textColor = [UIColor whiteColor];
        _playCountLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.videoBackImgBlurView addSubview:_playCountLabel];
        
        self.hourLongLabel = [[UILabel alloc] init];
        _hourLongLabel.font = kFONT_SIZE_13;
        _hourLongLabel.layer.cornerRadius = 2;
        _hourLongLabel.textColor = [UIColor whiteColor];
        _hourLongLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.videoBackImgBlurView addSubview:_hourLongLabel];
        
        

        
        
        
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.layer.borderWidth = 2;
        _attentionButton.layer.cornerRadius = 4;
        _attentionButton.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [_attentionButton setImage:[UIImage imageNamed:@"attention_no"] forState:UIControlStateNormal];
        [_attentionButton setImage:[UIImage imageNamed:@"attention_yes"] forState:UIControlStateSelected];
        [self.contentView addSubview:_attentionButton];
        
    
    }
    return self;
}
- (void)detailsTapActionToVC {
    [self.delegate detailsTapActionWithTouristID:_touristID isOfficial:_isOfficial];
}
- (void)setHomeListResult:(Home_VideoListResult *)homeListResult {
    if (_homeListResult != homeListResult) {
        _homeListResult = homeListResult;
    }
    self.touristID = _homeListResult.TouristID;
    self.isOfficial = _homeListResult.isOfficial;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = homeListResult.Nickname;
    _sex_AgeView.sex = homeListResult.Sex;
    if ([homeListResult.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = homeListResult.Age;
    }
  
    
    if ([homeListResult.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }


    NSDate *createdDate = [NSDate dateWithString:homeListResult.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _createDateLabel.text = [createdDate timeAgoThreeDays];
    _titleLabel.text = homeListResult.videoName;
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", homeListResult.fictitiousReviews];
    _hourLongLabel.text = homeListResult.hour_long;
    _videoWidth = homeListResult.videoWidth;
    _videoHeight = homeListResult.videoHeight;
    _touristID = homeListResult.TouristID;
   
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setPersonalList:(PersonalList *)personalList {
    if (_personalList != personalList) {
        _personalList = personalList;
    }
    self.touristID = personalList.vo.TouristID;
    self.isOfficial = personalList.vo.cameraVideoVo.isOfficial;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, personalList.vo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = personalList.vo.Nickname;
    _sex_AgeView.sex = personalList.vo.Sex;
    if ([personalList.vo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = personalList.vo.Age;
    }
   
    if ([personalList.vo.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    NSDate *createdDate = [NSDate dateWithString:personalList.vo.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _createDateLabel.text = [createdDate timeAgoThreeDays];
    _titleLabel.text = personalList.vo.cameraVideoVo.videoName;
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, personalList.vo.cameraVideoVo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, personalList.vo.cameraVideoVo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", personalList.vo.cameraVideoVo.fictitiousReviews];
    _hourLongLabel.text = personalList.vo.cameraVideoVo.hour_long;
    _videoWidth = personalList.vo.cameraVideoVo.videoWidth;
    _videoHeight = personalList.vo.cameraVideoVo.videoHeight;
    _touristID = personalList.vo.TouristID;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setSceVideo:(SceVideoModel *)sceVideo {
    if (_sceVideo != sceVideo) {
        _sceVideo = sceVideo;
    }
    self.touristID = _sceVideo.TouristID;
    self.isOfficial = _sceVideo.isOfficial;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = sceVideo.Nickname;
    _sex_AgeView.sex = sceVideo.Sex;
    if ([sceVideo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = sceVideo.Age;
    }
  
    if ([sceVideo.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    
    
    NSDate *createdDate = [NSDate dateWithString:sceVideo.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _createDateLabel.text = [createdDate timeAgoThreeDays];
    _titleLabel.text = sceVideo.videoName;
    
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", sceVideo.fictitiousReviews];
    _hourLongLabel.text = sceVideo.hour_long;
    _videoWidth = sceVideo.videoWidth;
    _videoHeight = sceVideo.videoHeight;
    _touristID = sceVideo.TouristID;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setFriends:(Friends *)friends {
    if (_friends != friends) {
        _friends = friends;
    }
    self.touristID = friends.vo.TouristID;
    self.isOfficial = friends.vo.isOfficial;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = friends.vo.Nickname;
    _sex_AgeView.sex = friends.vo.Sex;
    if ([friends.vo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = friends.vo.Age;
    }
 
    if ([friends.vo.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    
    
    NSDate *createdDate = [NSDate dateWithString:friends.vo.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _createDateLabel.text = [createdDate timeAgoThreeDays];
    _titleLabel.text = friends.vo.videoName;
    
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", friends.vo.fictitiousReviews];
    _hourLongLabel.text = friends.vo.hour_long;
    _videoWidth = friends.vo.videoWidth;
    _videoHeight = friends.vo.videoHeight;
    _touristID = friends.vo.TouristID;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setIsAttention:(BOOL)isAttention {
    if (_isAttention != isAttention) {
        _isAttention = isAttention;
    }
    if (_isAttention == 0) {
        _attentionButton.selected = NO;
        _attentionButton.layer.borderColor = [UIColor colorWithRed:184 / 255.0 green:235 / 255.0 blue:228 / 255.0 alpha:1.0].CGColor;
    } else {
        _attentionButton.selected = YES;
        _attentionButton.layer.borderColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1.0].CGColor;
    }
    
    
    [_attentionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
#pragma mark - 关注
            NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
            if (_attentionButton.selected == 0) {
                
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/userinfo"];
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=addfocus&in=%@", _touristID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        _attentionButton.selected = !_attentionButton.selected;
                         _attentionButton.layer.borderColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1.0].CGColor;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消关注
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/userinfo"];
                
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=delfocus&out=%@", _touristID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:dict response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        _attentionButton.selected = !_attentionButton.selected;
                         _attentionButton.layer.borderColor = [UIColor colorWithRed:184 / 255.0 green:235 / 255.0 blue:228 / 255.0 alpha:1.0].CGColor;
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self.delegate presentVideoDetailsToLoginVCIfNot];
        }
        
    }];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([_touristID isEqualToString:userinfo.TourID]) {
        _attentionButton.hidden = YES;
    }
    _headImageView.frame = CGRectMake(20, 10, 40, 40);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nameWidth > SCREEN_WIDTH / 2 - 40 - 20 - 10) {
        nameWidth = SCREEN_WIDTH / 2 - 40 - 20 - 10;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 10, _headImageView.y , nameWidth, 20);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 50, 15);
    _officialImageView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 3, _nickNameLabel.y, 40, 20);
    CGFloat createDateWidth = [UILabel getWidthWithTitle:_createDateLabel.text font:_createDateLabel.font];
    _createDateLabel.frame = CGRectMake(_nickNameLabel.x, _nickNameLabel.y + _nickNameLabel.height, createDateWidth, _nickNameLabel.height);
    _attentionButton.frame = CGRectMake(SCREEN_WIDTH - 50, _headImageView.centerY - 15, _headImageView.height, 30);
   
    
    if ([_videoWidth integerValue] < [_videoHeight integerValue]) {
        _videoBackImgBlurView.frame = CGRectMake(_headImageView.x, _headImageView.y + _headImageView.height + 10, SCREEN_WIDTH - 40, 360);
        _videoImageView.frame = CGRectMake(_videoBackImgBlurView.width / 2 - (360 * 9.0 / 16.0) / 2, 0, 360 * 9.0 / 16.0, _videoBackImgBlurView.height);
    } else {
        _videoBackImgBlurView.frame = CGRectMake(_headImageView.x, _headImageView.y + _headImageView.height + 10, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 9 / 16);
        _videoImageView.frame = _videoBackImgBlurView.bounds;
    }
    _effectView.frame = _videoBackImgBlurView.bounds;
    _playImageView.frame = CGRectMake(_videoBackImgBlurView.width / 2 - 20, _videoBackImgBlurView.height / 2 - 20, 40, 40);
    CGFloat playCountWidth = [UILabel getWidthWithTitle:_playCountLabel.text font:_playCountLabel.font];
    _playCountLabel.frame = CGRectMake(15, _videoBackImgBlurView.height - 30, playCountWidth, 20);
    CGFloat hourLongWidth = [UILabel getWidthWithTitle:_hourLongLabel.text font:_hourLongLabel.font];
    _hourLongLabel.frame = CGRectMake(_videoBackImgBlurView.width - hourLongWidth - 15, _playCountLabel.y, hourLongWidth, _playCountLabel.height);
    
    
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(_videoBackImgBlurView.x, _videoBackImgBlurView.y + _videoBackImgBlurView.height + 10, SCREEN_WIDTH - 40, titleHight);
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _sex_AgeView.hidden = NO;
    _officialImageView.hidden = NO;
    _isReuse = YES;
   
}
@end
