//
//  PicDetailsTableViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "PicDetailsTableViewCell.h"
#import "YHWorkGroupPhotoContainer.h"
#import "PicList.h"
#import "Sex_AgeView.h"

@interface PicDetailsTableViewCell ()
{
    UserInfo *userInfo;
}
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;

@property (nonatomic, strong) UIImageView *officialImageView;
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, assign) BOOL isReuse;
@property (nonatomic, copy) NSString *touristID;
@property (nonatomic, copy) NSString *isOfficial;
@end

@implementation PicDetailsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        userInfo = [UserInfo getUserDetailsInfomation];
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
        _titleLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kFONT_SIZE_18;
        [self.contentView addSubview:_titleLabel];
        
        
        self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:SCREEN_WIDTH-20];
        _picContainerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);

        [self.contentView addSubview:self.picContainerView];
        
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
    [self.delegate picDetailsTapActionWithTouristID:_touristID isOfficial:_isOfficial];
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
    _titleLabel.text = friends.vo.title;
    
    
    NSMutableArray *shortPicURLArr = [NSMutableArray array];
    NSMutableArray *picURLArr = [NSMutableArray array];
    for (PicList *pic in friends.vo.picList) {
        [shortPicURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.shrotPicURL]]];
        [picURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.picURL]]];
    }
    
    _picContainerView.picUrlArray = shortPicURLArr;
    _picContainerView.picOriArray = picURLArr;

    
    
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
    _titleLabel.text = personalList.vo.UserPictureVo.title;
  
    NSMutableArray *shortPicURLArr = [NSMutableArray array];
    NSMutableArray *picURLArr = [NSMutableArray array];
    for (PicList *pic in personalList.vo.UserPictureVo.picList) {
        [shortPicURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.shrotPicURL]]];
        [picURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.picURL]]];
    }
    
    _picContainerView.picUrlArray = shortPicURLArr;
    _picContainerView.picOriArray = picURLArr;
    
    
    
    
    _touristID = personalList.vo.TouristID;
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
            [self.delegate presentPicDetailsToLoginVCIfNot];
        }
        
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([userInfo.TourID isEqualToString:_touristID]) {
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
    NSInteger count;
    if (_friends) {
       count = _friends.vo.picList.count;
    } else {
        count = _personalList.vo.UserPictureVo.picList.count;
    }
    CGFloat picHeight;
    if (count < 4) {
        picHeight = (SCREEN_WIDTH - 30) / 3;
    } else if (count >= 4 && count < 7) {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
    } else {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
    }
    
    _picContainerView.frame = CGRectMake(10, _headImageView.y + _headImageView.height + 10, SCREEN_WIDTH - 20, picHeight);
   
    
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(_picContainerView.x, _picContainerView.y + _picContainerView.height + 10, SCREEN_WIDTH - 40, titleHight);
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _sex_AgeView.hidden = NO;
    _officialImageView.hidden = NO;
    _isReuse = YES;
    
}
@end
