//
//  CommonPicCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "CommonPicCell.h"
#import "YHWorkGroupPhotoContainer.h"
#import "Sex_AgeView.h"
#import "PicList.h"
@interface CommonPicCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;

@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isReuse;

@end
@implementation CommonPicCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        
        self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:SCREEN_WIDTH-20];
        [self.contentView addSubview:self.picContainerView];
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0], [UIColor darkGrayColor]);
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
- (void)tapActionToVC{
    [self.delegate ClickHeadImageViewPushToPersonalVCWithFriends:_friends];
}
- (void)setFriends:(Friends *)friends {
    if (_friends != friends) {
        _friends = friends;
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, friends.vo.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _nickNameLabel.text = friends.vo.Nickname;
    _sex_AgeView.sex = friends.vo.Sex;
    if ([friends.vo.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = friends.vo.Age;
    }
    _createDateLabel.text = [friends.vo.creatDate substringToIndex:10];
    _titleLabel.text = friends.vo.title;
  
    NSMutableArray *shortPicURLArr = [NSMutableArray array];
    NSMutableArray *picURLArr = [NSMutableArray array];
    for (PicList *pic in friends.vo.picList) {
        [shortPicURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.shrotPicURL]]];
        [picURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.picURL]]];
    }
    
    _picContainerView.picUrlArray = shortPicURLArr;
    _picContainerView.picOriArray = picURLArr;
    
  
    if ([friends.vo.adress isEqualToString:@"未知地址"]) {
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    } else {
        _locationLabel.text = friends.vo.adress;
    }
    [_likeButton setTitle:friends.vo.vote forState:UIControlStateNormal];
    [_likeButton setTitle:friends.vo.vote forState:UIControlStateSelected];
    [_commentButton setTitle:friends.vo.commens forState:UIControlStateNormal];
    
    
    
    if (friends.vo.isVote == 0) {
        _likeButton.selected = NO;
    } else {
        _likeButton.selected = YES;
    }
    self.count = [friends.vo.vote integerValue];
    
    
    [_likeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        
        User *user = [User getUserInfo];
        NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
        if (user.isLogin == YES) {
#pragma mark - 点赞
            if (_likeButton.selected == 0) {
                NSString *urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=1&cmd=addUserVideoAndPicNum&type=0", friends.vo.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        [self.delegate voteChangedTableViewForCommonPicCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消点赞
                NSString *urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=-1&cmd=addUserVideoAndPicNum&type=0", friends.vo.ID];
                
                
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        [self.delegate voteChangedTableViewForCommonPicCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            NSLog(@"您未登录");
        }
        
    }];

    [_commentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.delegate ClickCommentPushToVCAndCommentWithFriend:friends];
        
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
    
    NSInteger count = _friends.vo.picList.count;
    CGFloat picHeight;
    if (count < 4) {
        picHeight = (SCREEN_WIDTH - 30) / 3;
    } else if (count >= 4 && count < 7) {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
    } else {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
    }
    
    _picContainerView.frame = CGRectMake(10, _titleLabel.y + _titleLabel.height + 10, SCREEN_WIDTH - 20, picHeight);
    _locationImageView.frame = CGRectMake(_picContainerView.x, _picContainerView.y + _picContainerView.height + 10, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:kFONT_SIZE_13];
    if (width > self.contentView.width / 2 - 5 - 24) {
        width = self.contentView.width / 2 - 5 - 24;
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);
    
    
    CGFloat likeButtonWidth = [UILabel getWidthWithTitle:_friends.vo.vote font:_likeButton.titleLabel.font];
    _likeButton.frame = CGRectMake(SCREEN_WIDTH - 150, _locationImageView.y, likeButtonWidth + 40, _locationImageView.height);
    CGSize likeimageSize = _likeButton.imageView.frame.size;
    _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - likeimageSize.width / 2);
    CGSize liketitleSize = _likeButton.titleLabel.frame.size;
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, - liketitleSize.width - 3, 0.0, 0.0);
    
    
    CGFloat commentButtonWidth = [UILabel getWidthWithTitle:_friends.vo.commens font:_commentButton.titleLabel.font];
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

@end
