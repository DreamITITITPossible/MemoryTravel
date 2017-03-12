//
//  SceHeaderView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceHeaderView.h"
#import "SceInfoModel.h"
@interface SceHeaderView ()
@property (nonatomic, retain) UIImageView *backView;
@property (nonatomic, retain) UIView *memberView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@end

@implementation SceHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        self.backView = [[UIImageView alloc] init];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        [self addSubview:_backView];
  
        
        self.memberView = [[UIView alloc] init];
        _memberView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _memberView.frame = CGRectMake(0, _backView.y + _backView.height, SCREEN_WIDTH, self.frame.size.height - _backView.height);
        [self addSubview:_memberView];
        
   
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.frame = CGRectMake(_backView.centerX - 35, _backView.y + _backView.height - 35, 70, 70);
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius = 35;
        _headImageView.clipsToBounds = YES;
        [self addSubview:_headImageView];
        
        // 轻拍手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionToVC)];
        // 设置需要轻拍的次数
        //    tap.numberOfTapsRequired = 2;
        // 设置多点轻拍
        tap.numberOfTouchesRequired = 1;
        // 视图添加一个手势
        [_headImageView addGestureRecognizer:tap];
        
        
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [_memberView addSubview:_nameLabel];
        
        
    }
    return self;
}

- (void)setSceInfo:(SceInfoModel *)sceInfo {
    if (_sceInfo != sceInfo) {
        _sceInfo = sceInfo;
    }
    [_backView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", _sceInfo.logoUrl]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:[NSString stringWithFormat:@"/ssh2/%@", _sceInfo.Photo]]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"]];
    _nameLabel.text = _sceInfo.SceName;
  
    
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
    
    _nameLabel.frame = CGRectMake(_memberView.centerX - nameWidth / 2, 50, nameWidth, 20);
     
}
- (void)tapActionToVC {
    
}

@end
