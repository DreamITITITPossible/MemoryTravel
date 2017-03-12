//
//  CommonVideoTableViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "CommonVideoTableViewCell.h"
#import "Sex_AgeView.h"

@interface CommonVideoTableViewCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *hourLongLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isReuse;
@property (nonatomic, copy) NSString *videoWidth;
@property (nonatomic, copy) NSString *videoHeight;
@property (nonatomic, copy) NSString *vote;
@property (nonatomic, copy) NSString *commons;
@end
@implementation CommonVideoTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 20;
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
        _nickNameLabel.font = kFONT_SIZE_15_BOLD;
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        self.createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = kFONT_SIZE_13;
        _createDateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_createDateLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kFONT_SIZE_18;
        _titleLabel.backgroundColor = [UIColor clearColor];
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
        
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0], [UIColor darkGrayColor]);
        _locationLabel.textColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
        [self.contentView addSubview:_locationLabel];
        self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
        [self.contentView addSubview:_locationImageView];
        
        
        
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_likeButton setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_null"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_full"] forState:UIControlStateSelected];
        _likeButton.titleLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_likeButton];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comments"] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_commentButton];
        
    }
    return self;
}
- (void)tapActionToVC:(Home_VideoListResult *)listResult{
    if (_friends) {
        
        [self.delegate ClickHeadImageViewPushToPersonalVCWithArray:[NSMutableArray arrayWithObject:_friends] type:@"friends"];
    } else {
        [self.delegate ClickHeadImageViewPushToPersonalVCWithArray:[NSMutableArray arrayWithObject:_homeListResult] type:@"homeListResult"];
    }
}
- (void)setFriends:(Friends *)friends {
    if (_friends != friends) {
        _friends = friends;
    }
    self.commons = friends.vo.commens;
    self.vote = friends.vo.vote;
    self.videoWidth = friends.vo.videoWidth;
    self.videoHeight = friends.vo.videoHeight;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = friends.vo.Nickname;
    _sex_AgeView.sex = friends.vo.Sex;
    if ([friends.vo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = friends.vo.Age;
    }
    _createDateLabel.text = [friends.vo.creatDate substringToIndex:10];
    _titleLabel.text = friends.vo.videoName;
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", friends.vo.fictitiousReviews];
    _hourLongLabel.text = friends.vo.hour_long;
    if ([friends.vo.videoAdress isEqualToString:@"未知地址"]) {
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    } else {
        _locationLabel.text = friends.vo.videoAdress;
    }
    [_likeButton setTitle:friends.vo.vote forState:UIControlStateNormal];
    [_likeButton setTitle:friends.vo.vote forState:UIControlStateSelected];
    [_commentButton setTitle:friends.vo.commens forState:UIControlStateNormal];
    
    
    
    if (friends.vo.isVote == NO) {
        _likeButton.selected = NO;
    } else {
        _likeButton.selected = YES;
    }
    self.count = [friends.vo.vote integerValue];
    
    
    [_likeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
#pragma mark - 点赞
            if (_likeButton.selected == 0) {
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/livideo"];
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=VoteLCVideo&num=1&id=%@", friends.vo.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        [self.delegate voteChangedTableViewForCommonVideoCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消点赞
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/livideo"];
                
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=cancelVideoVote&videoID=%@", friends.vo.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                       [self.delegate voteChangedTableViewForCommonVideoCell:self];
                        
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self.delegate presentToLoginIfNot];
        }
        
    }];
    [_commentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {

            [self.delegate ClickCommentPushToVCAndCommentWithArray:[NSMutableArray arrayWithObject:_friends] type:@"friends"];
        } else {
            [self.delegate presentToLoginIfNot];
        }
   
    }];
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setHomeListResult:(Home_VideoListResult *)homeListResult {
    if (_homeListResult != homeListResult) {
        _homeListResult = homeListResult;
    }
    self.commons = homeListResult.commens;
    self.vote = homeListResult.vote;
    self.videoWidth = homeListResult.videoWidth;
    self.videoHeight = homeListResult.videoHeight;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = homeListResult.Nickname;
    _sex_AgeView.sex = homeListResult.Sex;
    if ([homeListResult.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = homeListResult.Age;
    }
    _createDateLabel.text = [homeListResult.creatDate substringToIndex:10];
    _titleLabel.text = homeListResult.videoName;
    [_videoBackImgBlurView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, homeListResult.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _playCountLabel.text = [NSString stringWithFormat:@"%@次播放", homeListResult.fictitiousReviews];
    _hourLongLabel.text = homeListResult.hour_long;
    if ([homeListResult.videoAdress isEqualToString:@"未知地址"]) {
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    } else {
    _locationLabel.text = homeListResult.videoAdress;
    }
    [_likeButton setTitle:homeListResult.vote forState:UIControlStateNormal];
    [_likeButton setTitle:homeListResult.vote forState:UIControlStateSelected];
    [_commentButton setTitle:homeListResult.commens forState:UIControlStateNormal];

    
    
    if (homeListResult.isVote == NO) {
        _likeButton.selected = NO;
    } else {
        _likeButton.selected = YES;
    }
    self.count = [homeListResult.vote integerValue];

    
    [_likeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
       
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
#pragma mark - 点赞
            if (_likeButton.selected == 0) {
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/livideo"];
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=VoteLCVideo&num=1&id=%@", homeListResult.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        [self.delegate voteChangedTableViewForCommonVideoCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消点赞
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/livideo"];
                
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=cancelVideoVote&videoID=%@", homeListResult.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient POST:urlString body:bodyStr bodyStyle:JYX_BodyString headerFile:nil response:JYX_JSON isShowHub:YES success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        [self.delegate voteChangedTableViewForCommonVideoCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
        } else {
            [self.delegate presentToLoginIfNot];
        }

    }];
     [_commentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
         User *user = [User getUserInfo];
         
         if (user.isLogin == YES) {

         [self.delegate ClickCommentPushToVCAndCommentWithArray:[NSMutableArray arrayWithObject:homeListResult] type:@"homeListResult"];
         } else {
             [self.delegate presentToLoginIfNot];
         }
     }];
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
     


- (void)layoutSubviews {
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(20, 10, 40, 40);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nameWidth > SCREEN_WIDTH / 2 - 40 - 20 - 10) {
        nameWidth = SCREEN_WIDTH / 2 - 40 - 20 - 10;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 10, _headImageView.centerY - 12, nameWidth, 25);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 50, 20);
    CGFloat createDateWidth = [UILabel getWidthWithTitle:_createDateLabel.text font:_createDateLabel.font];
    _createDateLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - createDateWidth, _nickNameLabel.y, createDateWidth, _nickNameLabel.height);
   
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(_headImageView.x, _headImageView.y + _headImageView.height + 10, SCREEN_WIDTH - 40, titleHight);
    
    if ([_videoWidth integerValue] < [_videoHeight integerValue]) {
        _videoBackImgBlurView.frame = CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 10, _titleLabel.width, 360);
        _videoImageView.frame = CGRectMake(_titleLabel.width / 2 - (360 * 9.0 / 16.0) / 2, 0, 360 * 9.0 / 16.0, _videoBackImgBlurView.height);
    } else {
        _videoBackImgBlurView.frame = CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 10, _titleLabel.width, _titleLabel.width * 9 / 16);
        _videoImageView.frame = _videoBackImgBlurView.bounds;
    }
    _effectView.frame = _videoBackImgBlurView.bounds;
    _playImageView.frame = CGRectMake(_videoBackImgBlurView.width / 2 - 20, _videoBackImgBlurView.height / 2 - 20, 40, 40);
    CGFloat playCountWidth = [UILabel getWidthWithTitle:_playCountLabel.text font:_playCountLabel.font];
    _playCountLabel.frame = CGRectMake(15, _videoBackImgBlurView.height - 30, playCountWidth, 20);
    CGFloat hourLongWidth = [UILabel getWidthWithTitle:_hourLongLabel.text font:_hourLongLabel.font];
    _hourLongLabel.frame = CGRectMake(_videoBackImgBlurView.width - hourLongWidth - 15, _playCountLabel.y, hourLongWidth, _playCountLabel.height);
    
    _locationImageView.frame = CGRectMake(_videoBackImgBlurView.x, _videoBackImgBlurView.y + _videoBackImgBlurView.height + 10, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:kFONT_SIZE_13];
    if (width > self.contentView.width / 2 - 5 - 24) {
        width = self.contentView.width / 2 - 5 - 24;
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);
    
    
    CGFloat likeButtonWidth = [UILabel getWidthWithTitle:_vote font:_likeButton.titleLabel.font];
    _likeButton.frame = CGRectMake(SCREEN_WIDTH - 150, _locationImageView.y, likeButtonWidth + 40, _locationImageView.height);
    CGSize likeimageSize = _likeButton.imageView.frame.size;
    _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - likeimageSize.width / 2);
    CGSize liketitleSize = _likeButton.titleLabel.frame.size;
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, - liketitleSize.width - 3, 0.0, 0.0);

    
    CGFloat commentButtonWidth = [UILabel getWidthWithTitle:_commons font:_commentButton.titleLabel.font];
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - 80, _locationImageView.y, commentButtonWidth + 40, _locationImageView.height);
    CGSize commentimageSize = _commentButton.imageView.frame.size;
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - commentimageSize.width / 2);
    CGSize commenttitleSize = _commentButton.titleLabel.frame.size;
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, - commenttitleSize.width - 3, 0.0, 0.0);
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _locationImageView.hidden = NO;
    _locationLabel.hidden = NO;
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
