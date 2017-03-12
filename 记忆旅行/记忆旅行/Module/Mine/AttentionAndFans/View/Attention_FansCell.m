//
//  Attention_FansCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "Attention_FansCell.h"
#import "Sex_AgeView.h"
@interface Attention_FansCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, retain) UILabel *signatureLabel;
@property (nonatomic, retain) UILabel *fansLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation Attention_FansCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 20;
        _headImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headImageView];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kFONT_SIZE_15_BOLD;
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        self.signatureLabel = [[UILabel alloc] init];
        _signatureLabel.font = kFONT_SIZE_12;
        _signatureLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_signatureLabel];

        self.fansLabel = [[UILabel alloc] init];
        _fansLabel.font = kFONT_SIZE_13;
        _fansLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:85 alpha:1.0];
        [self.contentView addSubview:_fansLabel];

        
        
        
        
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.layer.borderWidth = 2;
        _attentionButton.layer.cornerRadius = 4;
        
        [_attentionButton setImage:[UIImage imageNamed:@"attention_no"] forState:UIControlStateNormal];
        [_attentionButton setImage:[UIImage imageNamed:@"attention_yes"] forState:UIControlStateSelected];
        [self.contentView addSubview:_attentionButton];
        
        self.lineView = [[UIView alloc] init];
        _lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [self.contentView addSubview:_lineView];

    }
    return self;
}
- (void)setAttention_FansModel:(Attention_FansModel *)attention_FansModel {
    if (_attention_FansModel != attention_FansModel) {
        _attention_FansModel = attention_FansModel;
    }
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", _attention_FansModel.Photo]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    _nickNameLabel.text = _attention_FansModel.Nickname;
    _sex_AgeView.sex = _attention_FansModel.Sex;
    _sex_AgeView.age = _attention_FansModel.Age;
    if (_attention_FansModel.kidneyname.length == 0) {
        _signatureLabel.text = @"这个人还没来得及介绍自己~";
    } else {
        _signatureLabel.text = _attention_FansModel.kidneyname;
    }
    _fansLabel.text = [NSString stringWithFormat:@"粉丝: %@", _attention_FansModel.fans];

    if ([_attention_FansModel.focus integerValue] != 1) {
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
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=addfocus&in=%@", _attention_FansModel.TouristID];
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
                NSString *bodyStr = [NSString stringWithFormat:@"&cmd=delfocus&out=%@", _attention_FansModel.TouristID];
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
            [self.delegate presentAttention_FansToLoginIfNot];
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
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 10, 10, nameWidth, 15);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 50, 15);
    _attentionButton.frame = CGRectMake(SCREEN_WIDTH - 50, self.contentView.centerY - 15, 40, 30);
    _signatureLabel.frame = CGRectMake(_nickNameLabel.x, _nickNameLabel.y + _nickNameLabel.height + 6, _attentionButton.x - _headImageView.x - _headImageView.width - 10 - 10, 12);
    _fansLabel.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 4, 120, 13);
    _lineView.frame = CGRectMake(_headImageView.x + 10, self.contentView.height - 1, SCREEN_WIDTH - _headImageView.x - 10, 1);
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
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
