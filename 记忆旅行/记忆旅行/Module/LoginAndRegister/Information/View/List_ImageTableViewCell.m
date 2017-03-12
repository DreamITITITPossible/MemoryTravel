//
//  List_ImageTableViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "List_ImageTableViewCell.h"

@interface List_ImageTableViewCell ()
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *headImageView;
@end
@implementation List_ImageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFONT_SIZE_15_BOLD;
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        [self.contentView addSubview:_titleLabel];
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.layer.cornerRadius = 25;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;        _headImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headImageView];
        
        
      
        
    }
    return self;
}
- (void)setListTitle:(NSString *)listTitle {
    if (_listTitle != listTitle) {
        _listTitle = listTitle;
    }
    _titleLabel.text = listTitle;
}
- (void)setHeadIcon:(UIImage *)headIcon {
    if (_headIcon != headIcon) {
        _headIcon = headIcon;
    }
    _headImageView.image = _headIcon;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWidth = [UILabel getWidthWithTitle:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(15, 23, labelWidth, 20);
    
    _headImageView.frame = CGRectMake(SCREEN_WIDTH - 90, 10, 50, 50);
    
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
