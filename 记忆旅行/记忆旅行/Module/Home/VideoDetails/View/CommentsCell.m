//
//  CommentsCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "CommentsCell.h"
#import "Sex_AgeView.h"
#import "QuoteView.h"

@interface CommentsCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *nickNameLabel;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, retain) UILabel *createdLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) QuoteView *quoteView;
@property (nonatomic, strong) UIView *bottomeLineView;
@property (nonatomic, copy) NSString *touristID;
@property (nonatomic, copy) NSString *isOfficial;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation CommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 15;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsTapActionToVC)];
        // 设置需要轻拍的次数
        //    tap.numberOfTapsRequired = 2;
        // 设置多点轻拍
        tap.numberOfTouchesRequired = 1;
        // 视图添加一个手势
        [_headImageView addGestureRecognizer:tap];

        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kFONT_SIZE_13;
        _nickNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _nickNameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        
        self.createdLabel = [[UILabel alloc] init];
        _createdLabel.font = kFONT_SIZE_13;
        _createdLabel.textColor = [UIColor lightGrayColor];
        _createdLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_createdLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        self.quoteView = [[QuoteView alloc] init];
        _quoteView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_quoteView];
        self.bottomeLineView = [[UIView alloc] init];
        _bottomeLineView.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [self.contentView addSubview:_bottomeLineView];
        
    }
    return self;
}
- (void)commentsTapActionToVC {
    [self.delegate CommentsTapActionWithTouristID:_touristID isOfficial:_isOfficial];
}
- (void)setContent:(CommentsContent *)content {
    if (_content != content) {
        _content = content;
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _content.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _touristID = content.TouristID;
    _isOfficial = content.YSofficial;
    _nickNameLabel.text = _content.Nickname;
    _sex_AgeView.sex = _content.Sex;
    if ([_content.Age intValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = _content.Age;
    }
    
    NSDate *createdDate = [NSDate dateWithString:_content.Created format:@"yyyy-MM-dd HH:mm:ss"];
    _createdLabel.text =  [createdDate timeAgoThreeDays];
    if (_content.pidNickname.length > 0) {
        _titleLabel.text = [NSString stringWithFormat:@"回复@%@:%@", _content.pidNickname, _content.comment];

    } else {
    _titleLabel.text = _content.comment;
        _quoteView.hidden = YES;
    }
    _quoteView.content = _content;
    if (self.isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.isReuse = YES;
    _quoteView.hidden = NO;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(20, 10, 30, 30);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 10, _headImageView.y, nameWidth, 15);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 40, 16);
    CGFloat createDateWidth = [UILabel getWidthWithTitle:_createdLabel.text font:_createdLabel.font];
    _createdLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - createDateWidth, _nickNameLabel.y, createDateWidth, _nickNameLabel.height);
    
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - _nickNameLabel.x - 30) title:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(_nickNameLabel.x + 10, _headImageView.y + _headImageView.height - 5, SCREEN_WIDTH - _nickNameLabel.x - 30, titleHight);
    
    NSString *str = [NSString stringWithFormat:@"引用@%@:%@", _content.pidNickname, _content.pidComment];


    CGFloat labelHeight;
    labelHeight = [UILabel getHeightByWidth:SCREEN_WIDTH - _nickNameLabel.x - 20 - 16 title:str font:[UIFont systemFontOfSize:17]];
    _quoteView.frame = CGRectMake(_nickNameLabel.x, _titleLabel.y + _titleLabel.height + 5, SCREEN_WIDTH - _nickNameLabel.x - 20, labelHeight + 10);
    _bottomeLineView.frame = CGRectMake(_nickNameLabel.x, self.height - 1, SCREEN_WIDTH - _nickNameLabel.x - 20, 1);
    
    
    
    
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
