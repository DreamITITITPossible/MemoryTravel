//
//  PersonalHomepageHeaderView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "PersonalHomepageHeaderView.h"
#import "Sex_AgeView.h"
#import "VoteView.h"
//#import "DoubleLabelButton.h"
@interface PersonalHomepageHeaderView ()
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIView *memberView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIView *headView;;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_ageView;
@property (nonatomic, strong) UIImageView *officialImageView;
@property (nonatomic, retain) UILabel *signatureLabel;
@property (nonatomic, retain) VoteView *voteView;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *fansBtn;
@property (nonatomic, strong) UIView *lineXView;
@property (nonatomic, strong) UIView *lineHView;
@property (nonatomic, strong) UIView *lineBottom;
@end

@implementation PersonalHomepageHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        self.backView = [[UIView alloc] init];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor clearColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [self addSubview:_backView];
        //        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_headbg"]];
        //        _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
        //        _backImageView.userInteractionEnabled = YES;
        //        [self addSubview:_backImageView];
        
        self.memberView = [[UIView alloc] init];
        _memberView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _memberView.frame = CGRectMake(0, _backView.y + _backView.height, SCREEN_WIDTH, self.frame.size.height - _backView.height);
        [self addSubview:_memberView];
        
        self.headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(_memberView.centerX - 40, -40, 80, 80);
        _headView.layer.cornerRadius = 40;
        _headView.layer.borderWidth = 0.1f;
        _headView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.headView.userInteractionEnabled = YES;
        [_memberView addSubview:_headView];
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.frame = CGRectMake(5, 5, 70, 70);
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius = 35;
        _headImageView.clipsToBounds = YES;
        [_headView addSubview:_headImageView];
        
        // 轻拍手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToVC:)];
        // 设置需要轻拍的次数
        //    tap.numberOfTapsRequired = 2;
        // 设置多点轻拍
//        tap.numberOfTouchesRequired = 1;
        // 视图添加一个手势
//        [_headImageView addGestureRecognizer:tap];
        
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [_memberView addSubview:_nameLabel];
        self.sex_ageView = [[Sex_AgeView alloc] init];
        _sex_ageView.font = kFONT_SIZE_13;
        [_memberView addSubview:_sex_ageView];
        self.officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_official"]];
        [_memberView addSubview:_officialImageView];
        self.signatureLabel = [[UILabel alloc] init];
        _signatureLabel.font = kFONT_SIZE_13;
        _signatureLabel.numberOfLines = 0;
        _signatureLabel.textColor = [UIColor lightGrayColor];
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        [_memberView addSubview:_signatureLabel];
        
        self.voteView = [[VoteView alloc] init];
        [_memberView addSubview:_voteView];
        
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.dk_tintColorPicker = DKColorPickerWithKey(BG);
        [_attentionBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [_memberView addSubview:_attentionBtn];
        self.fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansBtn.dk_tintColorPicker = DKColorPickerWithKey(BG);
        [_fansBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];

        [_memberView addSubview:_fansBtn];
        self.lineXView = [[UIView alloc] init];
        _lineXView.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [_memberView addSubview:_lineXView];
        self.lineHView = [[UIView alloc] init];
        _lineHView.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [_memberView addSubview:_lineHView];
        self.lineBottom = [[UIView alloc] init];
        _lineBottom.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [_memberView addSubview:_lineBottom];
        
        
    }
    return self;
}
- (void)setPersonalInfo:(PersonalInfo *)personalInfo {
    if (_personalInfo != personalInfo) {
        _personalInfo = personalInfo;
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", personalInfo.Photo]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    _nameLabel.text = personalInfo.Nickname;
    if ([personalInfo.Age isEqualToString:@"0"]) {
        _sex_ageView.age = @"";
    } else {
        _sex_ageView.age = personalInfo.Age;
    }
    _sex_ageView.sex = personalInfo.Sex;
   
    if ([personalInfo.Sex isEqualToString:@""]) {
        _sex_ageView.hidden = YES;
    } else {
        _officialImageView.hidden = YES;
    }
    
    _signatureLabel.text = _personalInfo.kidneyname;
    if ([_personalInfo.clickNum isEqualToString:@""]) {
        _voteView.vote = @"0";
    } else {
    _voteView.vote = _personalInfo.clickNum;
    }


    _attentionBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _attentionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _attentionBtn.titleLabel.font = kFONT_SIZE_13;
    [_attentionBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"关注", _personalInfo.outNum] forState: UIControlStateNormal];
    [_attentionBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_attentionBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.delegate ClickFans_AttentionBtnPushToVCWithType:@"1" TouristID:_personalInfo.TouristID];
        
    }];
    _fansBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _fansBtn.titleLabel.font = kFONT_SIZE_13;

    [_fansBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"粉丝", _personalInfo.inNum] forState: UIControlStateNormal];
    [_fansBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [_fansBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.delegate ClickFans_AttentionBtnPushToVCWithType:@"0" TouristID:_personalInfo.TouristID];
        
    }];
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
    _nameLabel.frame = CGRectMake(_memberView.centerX - nameWidth / 2, 44, nameWidth, 20);
    _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 30, 15);
    _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 40, 20);
    CGFloat signatureHeight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 50) title:_signatureLabel.text font:_signatureLabel.font];
    _signatureLabel.frame = CGRectMake(25, _nameLabel.y + _nameLabel.height + 10, SCREEN_WIDTH - 50, signatureHeight);
    _voteView.frame = CGRectMake(_memberView.centerX - 40, _signatureLabel.y + _signatureLabel.height + 3, 80, 20);
    _lineXView.frame = CGRectMake(10, _voteView.y + _voteView.height + 10, SCREEN_WIDTH - 20, 1);
    _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 40);
    _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 24);
    _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, _attentionBtn.height);
    _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 1);
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _memberView.frame = CGRectMake(0, _backView.y + _backView.height, SCREEN_WIDTH, self.frame.size.height - _backView.height);
}


@end
