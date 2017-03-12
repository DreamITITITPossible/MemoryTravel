//
//  SceNoteCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceNoteCell.h"
#import "Sex_AgeView.h"
@interface SceNoteCell ()
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) Sex_AgeView *sex_AgeView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) BOOL isReuse;

@end
@implementation SceNoteCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_picImageView];
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _headImageView.layer.cornerRadius = 15;
        _headImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headImageView];
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = [UIColor grayColor];
        _nickNameLabel.font = kFONT_SIZE_12;
        _nickNameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_nickNameLabel];
        self.sex_AgeView = [[Sex_AgeView alloc] init];
        _sex_AgeView.font = kFONT_SIZE_12_BOLD;
        [self.contentView addSubview:_sex_AgeView];
        self.createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = kFONT_SIZE_13;
        _createDateLabel.textColor = [UIColor lightGrayColor];
        _createDateLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:_createDateLabel];
        self.bottomLine = [[UIView alloc] init];
        _bottomLine.dk_backgroundColorPicker = DKColorPickerWithKey(LINEBG);
        [self.contentView addSubview:_bottomLine];
    }
    return self;
}
- (void)setSceNote:(SceNoteModel *)sceNote {
    if (_sceNote != sceNote) {
        _sceNote = sceNote;
    }
      [_picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceNote.picShortPath]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _titleLabel.text = sceNote.traceName;
    _nickNameLabel.text = sceNote.Nickname;
    _sex_AgeView.sex = sceNote.Sex;
    if ([sceNote.Age integerValue] == 0) {
        _sex_AgeView.age = @"";
    } else {
        _sex_AgeView.age = sceNote.Age;
    }
    _createDateLabel.text = sceNote.traceTime;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceNote.Photo]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _picImageView.frame = CGRectMake(10, 10, 120, 100);
    _titleLabel.frame = CGRectMake(_picImageView.x + _picImageView.width + 10, _picImageView.y, SCREEN_WIDTH - _picImageView.width - _picImageView.x - 10 - 10, 40);
    _headImageView.frame = CGRectMake(_titleLabel.x, _picImageView.y + _picImageView.height - 30, 30, 30);
    CGFloat nickNameWidth = [UILabel getWidthWithTitle:_nickNameLabel.text font:_nickNameLabel.font];
    if (nickNameWidth > 50) {
        nickNameWidth = 50;
    }
    _nickNameLabel.frame = CGRectMake(_headImageView.x + _headImageView.width + 2, _headImageView.centerY - 6, nickNameWidth, 12);
    _sex_AgeView.frame = CGRectMake(_nickNameLabel.x + _nickNameLabel.width + 10, _nickNameLabel.centerY - 10, 50, 15);
    CGFloat createDateWidth = [UILabel getWidthWithTitle:_createDateLabel.text font:_createDateLabel.font];
    _createDateLabel.frame = CGRectMake(SCREEN_WIDTH - createDateWidth - 5, _headImageView.centerY - 6, createDateWidth, 12);
    _bottomLine.frame = CGRectMake(0, self.contentView.height - 1, SCREEN_WIDTH, 1);
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
