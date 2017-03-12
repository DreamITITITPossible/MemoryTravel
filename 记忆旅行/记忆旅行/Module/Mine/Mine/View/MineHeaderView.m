//
//  MineHeaderView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "MineHeaderView.h"

#import "Sex_AgeView.h"
#import "VoteView.h"
//#import "DoubleLabelButton.h"
@interface MineHeaderView ()
@property (nonatomic, retain) UIView *memberView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIView *headView;;
@property (nonatomic, retain) UIImageView *editImageView;
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
@property (nonatomic, strong) User *user;
@end

@implementation MineHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.user = [User getUserInfo];
        
        
        self.memberView = [[UIView alloc] init];
        _memberView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _memberView.userInteractionEnabled = YES;
        _memberView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        [self addSubview:_memberView];
        UITapGestureRecognizer *tapMember = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToPersonalHomePage)];
      
        //         设置多点轻拍
        tapMember.numberOfTouchesRequired = 1;
        //         视图添加一个手势
        [_memberView addGestureRecognizer:tapMember];

        self.headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(15, 15, 80, 80);
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToVC)];
 //         设置多点轻拍
                tap.numberOfTouchesRequired = 1;
//         视图添加一个手势
        [_headImageView addGestureRecognizer:tap];
        
        
        self.editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_pencil"]];
        _editImageView.frame = CGRectMake(57, 57, 20, 20);
        _editImageView.layer.cornerRadius = 10;
        _editImageView.clipsToBounds = YES;
        [_headView addSubview:_editImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.text = @"未登录";
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        
        [_memberView addSubview:_nameLabel];
        self.sex_ageView = [[Sex_AgeView alloc] init];
        _sex_ageView.font = kFONT_SIZE_13;
        _sex_ageView.age = @"0";
        
        
        _sex_ageView.hidden = YES;
        [_memberView addSubview:_sex_ageView];
        self.officialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_official"]];
        [_memberView addSubview:_officialImageView];
        self.signatureLabel = [[UILabel alloc] init];
        _signatureLabel.text = @"立即登录查看我的个人主页";
        _signatureLabel.font = kFONT_SIZE_13;
        _signatureLabel.numberOfLines = 1;
        _signatureLabel.textColor = [UIColor lightGrayColor];
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        [_memberView addSubview:_signatureLabel];
        
        self.voteView = [[VoteView alloc] init];
        _voteView.vote = @"0";
        [_memberView addSubview:_voteView];
        
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.dk_tintColorPicker = DKColorPickerWithKey(BG);
        _attentionBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _attentionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _attentionBtn.titleLabel.font = kFONT_SIZE_13;
        [_attentionBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"关注", @"0"] forState: UIControlStateNormal];
        [_attentionBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [_memberView addSubview:_attentionBtn];
        self.fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansBtn.dk_tintColorPicker = DKColorPickerWithKey(BG);
        _fansBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _fansBtn.titleLabel.font = kFONT_SIZE_13;
        
        [_fansBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"粉丝", @"0"] forState: UIControlStateNormal];
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
        
        
        
        _headImageView.image = [UIImage imageNamed:@"img_head_placeholder"];
            _officialImageView.hidden = YES;
        
        
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        if (nameWidth > 200) {
            nameWidth = 200;
        }
        _nameLabel.frame = CGRectMake(_headView.x + _headView.width + 10, _headView.y + 5, nameWidth, 20);
        _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 30, 15);
        
        CGFloat signatureWidth = [UILabel getWidthWithTitle:_signatureLabel.text font:_signatureLabel.font];
        _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 40, 20);
        if (signatureWidth > SCREEN_WIDTH - _nameLabel.x - 50) {
            signatureWidth = SCREEN_WIDTH - _nameLabel.x - 50;
        }
        _signatureLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 10, signatureWidth, 13);
        _voteView.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 3, 80, 20);
        _lineXView.frame = CGRectMake(10, _headView.y + _headView.height + 15, SCREEN_WIDTH - 20, 1);
        _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 40);
        _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 24);
        _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, _attentionBtn.height);
        _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 1);

        
        
    }
    return self;
}
- (void)setPersonalInfo:(PersonalInfo *)personalInfo {
    if (_personalInfo != personalInfo) {
        _personalInfo = personalInfo;
    }
    
    _attentionBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _attentionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _attentionBtn.titleLabel.font = kFONT_SIZE_13;
    _fansBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _fansBtn.titleLabel.font = kFONT_SIZE_13;
    if (_isLogin) {
        _sex_ageView.hidden = NO;
        //        _officialImageView.hidden = NO;
        _editImageView.hidden = NO;
        _lineHView.hidden = NO;
        _lineXView.hidden = NO;
        _lineBottom.hidden = NO;
        _attentionBtn.hidden = NO;
        _fansBtn.hidden = NO;
        _voteView.hidden = NO;
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
            _officialImageView.hidden = NO;
        } else {
            _officialImageView.hidden = YES;
            _sex_ageView.hidden = NO;
        }
        
        _signatureLabel.text = _personalInfo.kidneyname;
        if ([_personalInfo.clickNum isEqualToString:@""]) {
            _voteView.vote = @"0";
        } else {
            _voteView.vote = _personalInfo.clickNum;
        }
        
        [_attentionBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"关注", _personalInfo.outNum] forState: UIControlStateNormal];
        [_attentionBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [_attentionBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self.delegate ClickFans_AttentionBtnPushToVCWithType:@"1" TouristID:_personalInfo.TouristID];
            
        }];
        
        [_fansBtn setTitle: [NSString stringWithFormat:@"%@\n%@", @"粉丝", _personalInfo.inNum] forState: UIControlStateNormal];
        [_fansBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [_fansBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [self.delegate ClickFans_AttentionBtnPushToVCWithType:@"0" TouristID:_personalInfo.TouristID];
            
        }];
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        if (nameWidth > 200) {
            nameWidth = 200;
        }
        _nameLabel.frame = CGRectMake(_headView.x + _headView.width + 10, _headView.y + 5, nameWidth, 20);
        _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 30, 15);
        
        CGFloat signatureWidth = [UILabel getWidthWithTitle:_signatureLabel.text font:_signatureLabel.font];
        _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 40, 20);
        if (signatureWidth > SCREEN_WIDTH - _nameLabel.x - 50) {
            signatureWidth = SCREEN_WIDTH - _nameLabel.x - 50;
        }
        _signatureLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 10, signatureWidth, 13);
        _voteView.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 3, 80, 20);
        _lineXView.frame = CGRectMake(10, _headView.y + _headView.height + 15, SCREEN_WIDTH - 20, 1);
        _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 40);
        _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 24);
        _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, _attentionBtn.height);
        _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 1);

    } else {
        _nameLabel.text = @"未登录";
        _signatureLabel.text = @"立即登录查看我的个人主页";
        _voteView.vote = @"0";
        _headImageView.image = [UIImage imageNamed:@"img_head_placeholder"];
        _officialImageView.hidden = YES;
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        if (nameWidth > 200) {
            nameWidth = 200;
        }
        _nameLabel.frame = CGRectMake(_headView.x + _headView.width + 10, _headView.y + 5, nameWidth, 20);
        _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 0, 0);
        _sex_ageView.hidden = YES;
        _officialImageView.hidden = YES;
        _lineHView.hidden = YES;
        _lineXView.hidden = YES;
        _lineBottom.hidden = YES;
        _attentionBtn.hidden = YES;
        _fansBtn.hidden = YES;
        _editImageView.hidden = YES;
        _voteView.hidden = YES;
        CGFloat signatureWidth = [UILabel getWidthWithTitle:_signatureLabel.text font:_signatureLabel.font];
        _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 0, 0);
        if (signatureWidth > SCREEN_WIDTH - _nameLabel.x - 50) {
            signatureWidth = SCREEN_WIDTH - _nameLabel.x - 50;
        }
        _signatureLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 10, signatureWidth, 13);
        _voteView.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 3, 0, 0);
        _lineXView.frame = CGRectMake(10, _headView.y + _headView.height + 15
                                      , SCREEN_WIDTH - 20, 0);
        _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 0);
        _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 0);
        _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, 0);
        _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 0);

    }
    
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isLogin) {
        _sex_ageView.hidden = NO;
        //        _officialImageView.hidden = NO;
        _editImageView.hidden = NO;
        _voteView.hidden = NO;
        _lineHView.hidden = NO;
        _lineXView.hidden = NO;
        _lineBottom.hidden = NO;
        _attentionBtn.hidden = NO;
        _fansBtn.hidden = NO;
        
        if ([_sex_ageView.sex isEqualToString:@""]) {
            _sex_ageView.hidden = YES;
            _officialImageView.hidden = NO;
        } else {
            _officialImageView.hidden = YES;
            _sex_ageView.hidden = NO;
        }
        
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        if (nameWidth > 200) {
            nameWidth = 200;
        }
        _nameLabel.frame = CGRectMake(_headView.x + _headView.width + 10, _headView.y + 5, nameWidth, 20);
        _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 30, 15);
        
        CGFloat signatureWidth = [UILabel getWidthWithTitle:_signatureLabel.text font:_signatureLabel.font];
        _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 40, 20);
        if (signatureWidth > SCREEN_WIDTH - _nameLabel.x - 50) {
            signatureWidth = SCREEN_WIDTH - _nameLabel.x - 50;
        }
        _signatureLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 10, signatureWidth, 13);
        _voteView.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 3, 80, 20);
        _lineXView.frame = CGRectMake(10, _headView.y + _headView.height + 15, SCREEN_WIDTH - 20, 1);
        _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 40);
        _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 24);
        _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, _attentionBtn.height);
        _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 1);
        
    } else {
        _nameLabel.text = @"未登录";
        _signatureLabel.text = @"立即登录查看我的个人主页";
        _voteView.vote = @"0";
        _headImageView.image = [UIImage imageNamed:@"img_head_placeholder"];
        _officialImageView.hidden = YES;
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        if (nameWidth > 200) {
            nameWidth = 200;
        }
        _nameLabel.frame = CGRectMake(_headView.x + _headView.width + 10, _headView.y + 5, nameWidth, 20);
        _sex_ageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 10, _nameLabel.centerY - 9, 0, 0);
        _sex_ageView.hidden = YES;
        _officialImageView.hidden = YES;
        _lineHView.hidden = YES;
        _lineXView.hidden = YES;
        _lineBottom.hidden = YES;
        _attentionBtn.hidden = YES;
        _fansBtn.hidden = YES;
        _editImageView.hidden = YES;
        _voteView.hidden = YES;
        CGFloat signatureWidth = [UILabel getWidthWithTitle:_signatureLabel.text font:_signatureLabel.font];
        _officialImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 3, _nameLabel.y, 0, 0);
        if (signatureWidth > SCREEN_WIDTH - _nameLabel.x - 50) {
            signatureWidth = SCREEN_WIDTH - _nameLabel.x - 50;
        }
        _signatureLabel.frame = CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 10, signatureWidth, 13);
        _voteView.frame = CGRectMake(_signatureLabel.x, _signatureLabel.y + _signatureLabel.height + 3, 0, 0);
        _lineXView.frame = CGRectMake(10, _headView.y + _headView.height + 15
                                      , SCREEN_WIDTH - 20, 0);
        _attentionBtn.frame = CGRectMake(0, _lineXView.y + _lineXView.height + 1, SCREEN_WIDTH / 2, 0);
        _lineHView.frame = CGRectMake(_memberView.centerX, _attentionBtn.centerY - 12, 1, 0);
        _fansBtn.frame = CGRectMake(SCREEN_WIDTH / 2, _attentionBtn.y, SCREEN_WIDTH / 2, 0);
        _lineBottom.frame = CGRectMake(_lineXView.x, _fansBtn.y + _fansBtn.height + 1, _lineXView.width, 0);
        
    }
}

- (void)setIsLogin:(BOOL)isLogin {
    if (_isLogin != isLogin) {
        _isLogin = isLogin;
    }
    [self layoutSubviews];
   }
- (void)tapActionToVC {
    [self.delegate clickHeadImageViewPushToModificationInfo];
}
- (void)tapActionToPersonalHomePage {
    [self.delegate clickMemberViewPushToPersonalHomePageWithPersonalInfo:_personalInfo];
}
@end
