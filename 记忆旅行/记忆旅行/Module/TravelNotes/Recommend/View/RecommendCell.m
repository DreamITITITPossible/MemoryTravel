//
//  RecommendCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "RecommendCell.h"
#import "Sex_AgeView.h"
@interface RecommendCell ()
{
    UserInfo *userInfo;
}
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, strong) UIImageView *officialImageView;

@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, assign) BOOL isReuse;
@end

@implementation RecommendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        userInfo = [UserInfo getUserDetailsInfomation];
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 20;
        _headImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headImageView];
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kFONT_SIZE_15_BOLD;
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _nickNameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        
        self.officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_official"]];
        [self.contentView addSubview:_officialImageView];
        
        
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
- (void)setRecommend:(RecommendModel *)recommend {
    if (_recommend != recommend) {
        _recommend = recommend;
    }
    if ([userInfo.TourID isEqualToString:recommend.TouristID]) {
        _attentionButton.hidden = YES;
    }
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", recommend.Photo]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    _nickNameLabel.text = recommend.Nickname;
    _sex_AgeView.sex = recommend.Sex;
    _sex_AgeView.age = recommend.Age;
    
        _attentionButton.selected = NO;
        _attentionButton.layer.borderColor = [UIColor colorWithRed:184 / 255.0 green:235 / 255.0 blue:228 / 255.0 alpha:1.0].CGColor;
   
    if ([recommend.Sex isEqualToString:@""]) {
        _sex_AgeView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    
    [_attentionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        
        if (user.isLogin == YES) {
#pragma mark - 关注
            NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
            if (_attentionButton.selected == 0) {
                
                NSString *urlString =[baseURL stringByAppendingString:@"/ssh2/userinfo"];
                // Body
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=addfocus&in=%@", recommend.TouristID];
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
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=delfocus&out=%@", recommend.TouristID];
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
            NSLog(@"您未登录");
        }
        
    }];
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(20, self.contentView.centerY - 20, 40, 40);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nameWidth > SCREEN_WIDTH / 2 - 40 - 20 - 10) {
        nameWidth = SCREEN_WIDTH / 2 - 40 - 20 - 10;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 10, _headImageView.centerY - 8, nameWidth, 15);
    _officialImageView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 8, 30, 15);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 50, 15);
    _attentionButton.frame = CGRectMake(SCREEN_WIDTH - 50, self.contentView.centerY - 15, 40, 30);
   
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _isReuse = YES;
    _sex_AgeView.hidden = NO;
    _nickNameLabel.hidden = NO;
    _attentionButton.hidden = NO;
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
