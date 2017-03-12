//
//  SearchSpotCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/6.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SearchSpotCell.h"

@interface SearchSpotCell ()
@property (nonatomic, strong) UIImageView *spotImageView;
@property (nonatomic, strong) UILabel *spotNameLabel;
@property (nonatomic, strong) UIImageView *liveImageView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation SearchSpotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.spotImageView = [[UIImageView alloc] init];
        _spotImageView.layer.cornerRadius = 3;
        _spotImageView.clipsToBounds = YES;
        [self.contentView addSubview:_spotImageView];
        self.spotNameLabel = [[UILabel alloc] init];
        _spotNameLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _spotNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _spotNameLabel.numberOfLines = 1;
        [self.contentView addSubview:_spotNameLabel];
        self.liveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live"]];
        //        self.clipsToBounds = YES;
        [self.contentView addSubview:_liveImageView];
        self.gradeLabel = [[UILabel alloc] init];
        _gradeLabel.font = kFONT_SIZE_13;
        _gradeLabel.layer.cornerRadius = 2;
        _gradeLabel.textAlignment = NSTextAlignmentCenter;
        _gradeLabel.dk_textColorPicker = DKColorPickerWithKey(BTNGREENBG);
        _gradeLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _gradeLabel.layer.dk_borderColorPicker = DKColorPickerWithKey(BTNGREENBG);
        _gradeLabel.layer.borderWidth = 0.5;
        [self.contentView addSubview:_gradeLabel];
        self.introLabel = [[UILabel alloc] init];
        _introLabel.font = [UIFont systemFontOfSize:16];
        _introLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _introLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(30, 30, 30, 1), JYXColor(230, 230, 230, 1));
        _introLabel.numberOfLines = 3;
        [self.contentView addSubview:_introLabel];
        
        
        
        

    }
    return self;
}
- (void)setSearchSpot:(SearchSpot *)searchSpot {
    if (_searchSpot != searchSpot) {
        _searchSpot = searchSpot;
    }
    [_spotImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, searchSpot.PicUrl]] placeholderImage:[UIImage imageNamed:@"img_head_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _spotNameLabel.text = searchSpot.SceName;
    if (searchSpot.isLive == NO) {
        _liveImageView.hidden = YES;
    }
    NSString *grade = @"";
    for (int i = 0; i < [searchSpot.Stars integerValue]; i++) {
       grade = [grade stringByAppendingString:@"A"];
    }
    _gradeLabel.text = [NSString stringWithFormat:@"%@景区", grade];
    _introLabel.text  = searchSpot.SceRemark;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    _spotImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH / 5 * 2, SCREEN_WIDTH / 5 * 2 / 4 * 3);
    CGFloat nameWidth = [UILabel getWidthWithTitle:_spotNameLabel.text font:_spotNameLabel.font];
    if (nameWidth > SCREEN_WIDTH / 5 * 2) {
        nameWidth = SCREEN_WIDTH / 5 * 2;
    }
    _spotNameLabel.frame = CGRectMake(_spotImageView.x + _spotImageView.width + 10, _spotImageView.y + 5, nameWidth, 18);
    _liveImageView.frame = CGRectMake(_spotNameLabel.x + _spotNameLabel.width + 10, _spotNameLabel.centerY - 15, 30, 30);
    CGFloat gradeWidth = [UILabel getWidthWithTitle:_gradeLabel.text font:_gradeLabel.font] + 4;
    _gradeLabel.frame = CGRectMake(_spotNameLabel.x, _spotNameLabel.y + _spotNameLabel.height + 10, gradeWidth, 17);
    _introLabel.frame = CGRectMake(_gradeLabel.x, _gradeLabel.y + _gradeLabel.height + 5, SCREEN_WIDTH - _spotNameLabel.x - 15, 60);

}
- (void)prepareForReuse {
    [super prepareForReuse];
    _liveImageView.hidden = NO;
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
